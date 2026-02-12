import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import '../../interfaces/key_exchange/i_crypto_session.dart';
import '../../interfaces/key_exchange/i_algorithm_negotiation.dart';
import '../../implementations/session/algorithm_negotiation.dart';
import '../../implementations/key_exchange/ecdh_key_exchange.dart';
import '../../implementations/handlers/handler_cipher.dart';
import '../../types/crypto_algorithm.dart';
import '../../types/key_exchange_algorithm.dart';
import '../../utils/crypto_utils.dart';

// Import all cipher implementations
import '../symmetric/aes_cipher.dart';
import '../symmetric/chacha20_cipher.dart';
import '../symmetric/des_cipher.dart';
import '../asymmetric/prime_based/rsa_cipher.dart';

/// Manages cryptographic sessions between peers with algorithm negotiation and key exchange
@includeInBarrelFile
class CryptoSessionManager implements ICryptoSession {
  final IAlgorithmNegotiation _negotiator;
  SecureSession? _currentSession;
  ECDHKeyExchange? _keyExchange;
  NegotiationResult? _negotiationResult;
  String? _sharedSecret;

  CryptoSessionManager({IAlgorithmNegotiation? negotiator})
      : _negotiator = negotiator ?? AlgorithmNegotiation();

  @override
  SecureSession? get currentSession => _currentSession;

  @override
  Future<Map<String, dynamic>> initiateSession(
      CryptoPeerCapabilities localCapabilities) async {
    // Generate ECDH key pair for session
    final keyPairData = await ECDHKeyExchange.generateKeyPair();
    _keyExchange = ECDHKeyExchange((
      parent: (
        algorithm: KeyExchangeAlgorithm.ecdh,
        expirationDate: DateTime.now().add(const Duration(hours: 24)),
        expirationTimes: null,
      ),
      publicKey: keyPairData['publicKey']!,
      privateKey: keyPairData['privateKey']!,
      curve: keyPairData['curve']!,
    ));

    // Create handshake message
    final handshakeMessage = _negotiator.createHandshakeMessage(localCapabilities);
    
    // Add key exchange information
    handshakeMessage['keyExchangeData'] = {
      'type': 'ecdh',
      'publicKey': _keyExchange!.getPublicKey(),
      'curve': _keyExchange!.curve,
    };

    return handshakeMessage;
  }

  @override
  Future<Map<String, dynamic>> respondToSession(
    Map<String, dynamic> initiationMessage,
    CryptoPeerCapabilities localCapabilities,
  ) async {
    // Parse remote capabilities
    final remoteCapabilities = _negotiator.parseHandshakeMessage(initiationMessage);

    // Negotiate algorithms
    _negotiationResult = _negotiator.negotiateAlgorithms(
      localCapabilities,
      remoteCapabilities,
      isInitiator: false,
    );

    if (_negotiationResult == null) {
      throw StateError('No compatible algorithms found');
    }

    if (!_negotiator.validateNegotiation(_negotiationResult!)) {
      throw StateError('Invalid negotiation result');
    }

    // Generate our ECDH key pair
    // Generate ECDH key pair for session
    final keyPairData = await ECDHKeyExchange.generateKeyPair();
    _keyExchange = ECDHKeyExchange((
      parent: (
        algorithm: KeyExchangeAlgorithm.ecdh,
        expirationDate: DateTime.now().add(const Duration(hours: 24)),
        expirationTimes: null,
      ),
      publicKey: keyPairData['publicKey']!,
      privateKey: keyPairData['privateKey']!,
      curve: keyPairData['curve']!,
    ));

    // Calculate shared secret with initiator's public key
    final initiatorPublicKey = initiationMessage['keyExchangeData']['publicKey'];
    _sharedSecret = await _keyExchange!.generateSharedSecret(initiatorPublicKey);

    // Create response message
    final responseMessage = _negotiator.createHandshakeMessage(localCapabilities);
    responseMessage['negotiation'] = {
      'keyExchange': _negotiationResult!.keyExchange.name,
      'asymmetric': _negotiationResult!.asymmetric.name,
      'symmetric': _negotiationResult!.symmetric.name,
    };
    responseMessage['keyExchangeData'] = {
      'type': 'ecdh',
      'publicKey': _keyExchange!.getPublicKey(),
      'curve': _keyExchange!.curve,
    };

    return responseMessage;
  }

  @override
  Future<SecureSession> finalizeSession(Map<String, dynamic> responseMessage) async {
    if (_keyExchange == null) {
      throw StateError('Session not initiated');
    }

    // Parse remote capabilities and negotiation result
    final remoteCapabilities = _negotiator.parseHandshakeMessage(responseMessage);
    final negotiation = responseMessage['negotiation'];
    
    _negotiationResult = (
      keyExchange: KeyExchangeAlgorithm.values
          .firstWhere((e) => e.name == negotiation['keyExchange']),
      asymmetric: CryptoAlgorithm.values
          .firstWhere((e) => e.name == negotiation['asymmetric']),
      symmetric: CryptoAlgorithm.values
          .firstWhere((e) => e.name == negotiation['symmetric']),
      localPeerId: 'local',
      remotePeerId: remoteCapabilities.peerId,
      isInitiator: true,
    );

    // Calculate shared secret with responder's public key
    final responderPublicKey = responseMessage['keyExchangeData']['publicKey'];
    _sharedSecret = await _keyExchange!.generateSharedSecret(responderPublicKey);

    return _createSecureSession();
  }

  @override
  Future<SecureSession> completeSession() async {
    if (_negotiationResult == null || _sharedSecret == null) {
      throw StateError('Session not properly negotiated');
    }

    return _createSecureSession();
  }

  /// Creates handlers based on negotiated algorithms
  Future<SecureSession> _createSecureSession() async {
    if (_negotiationResult == null || _sharedSecret == null) {
      throw StateError('Session not ready');
    }

    // Create asymmetric handler
    final asymmetricHandler = await _createAsymmetricHandler(
      _negotiationResult!.asymmetric,
    );

    // Create symmetric handler using shared secret
    final symmetricHandler = await _createSymmetricHandler(
      _negotiationResult!.symmetric,
      _sharedSecret!,
    );

    _currentSession = (
      asymmetricHandler: asymmetricHandler,
      symmetricHandler: symmetricHandler,
      negotiationResult: _negotiationResult!,
      sharedSecret: _sharedSecret!,
      establishedAt: DateTime.now(),
    );

    return _currentSession!;
  }

  /// Creates asymmetric cipher handler
  Future<HandlerCipherAsymmetric> _createAsymmetricHandler(
      CryptoAlgorithm algorithm) async {
    switch (algorithm) {
      case CryptoAlgorithm.rsa:
        final keyPair = await RSACipher.generateKeyPair();
        final rsaCipher = RSACipher((
          parent: (
            publicKey: keyPair['publicKey']!,
            privateKey: keyPair['privateKey']!,
            parent: (
              parent: (
                algorithm: CryptoAlgorithm.rsa,
                expirationDate: DateTime.now().add(const Duration(hours: 24)),
                expirationTimes: null,
              ),
            ),
          ),
        ));
        return HandlerCipherAsymmetric((
          initialCrypt: rsaCipher,
          maxCrypts: 10,
          maxExpiredCrypts: 5,
          maxDaysExpiredCrypts: 7,
        ));

      default:
        throw UnsupportedError('Asymmetric algorithm $algorithm not supported');
    }
  }

  /// Creates symmetric cipher handler
  Future<HandlerCipherSymmetric> _createSymmetricHandler(
      CryptoAlgorithm algorithm, String sharedSecret) async {
    // Derive key from shared secret (simple hash for demo)
    final derivedKey = KeyEncodingUtils.bytesToHex(
      KeyEncodingUtils.hexToBytes(sharedSecret.substring(0, 64)),
    );

    switch (algorithm) {
      case CryptoAlgorithm.aes:
        final aesCipher = AESCipher((
          parent: (
            key: derivedKey,
            parent: (
              parent: (
                algorithm: CryptoAlgorithm.aes,
                expirationDate: DateTime.now().add(const Duration(hours: 24)),
                expirationTimes: null,
              ),
            ),
          ),
        ));
        return HandlerCipherSymmetric((
          initialCrypt: aesCipher,
          maxCrypts: 100,
          maxExpiredCrypts: 10,
          maxDaysExpiredCrypts: 7,
        ));

      case CryptoAlgorithm.chacha20:
        final nonce = SecureRandomUtils.generateRandomBytes(8); // ChaCha20 uses 8-byte IV in PointyCastle
        final chacha20Cipher = ChaCha20Cipher((
          parent: (
            key: derivedKey,
            parent: (
              parent: (
                algorithm: CryptoAlgorithm.chacha20,
                expirationDate: DateTime.now().add(const Duration(hours: 24)),
                expirationTimes: null,
              ),
            ),
          ),
          nonce: nonce,
        ));
        return HandlerCipherSymmetric((
          initialCrypt: chacha20Cipher,
          maxCrypts: 100,
          maxExpiredCrypts: 10,
          maxDaysExpiredCrypts: 7,
        ));

      case CryptoAlgorithm.des:
        // DES uses smaller keys
        final desKey = derivedKey.substring(0, 16);
        final desCipher = DESCipher((
          parent: (
            key: desKey,
            parent: (
              parent: (
                algorithm: CryptoAlgorithm.des,
                expirationDate: DateTime.now().add(const Duration(hours: 24)),
                expirationTimes: null,
              ),
            ),
          ),
        ));
        return HandlerCipherSymmetric((
          initialCrypt: desCipher,
          maxCrypts: 50,
          maxExpiredCrypts: 5,
          maxDaysExpiredCrypts: 3,
        ));

      default:
        throw UnsupportedError('Symmetric algorithm $algorithm not supported');
    }
  }

  @override
  Future<void> closeSession() async {
    _currentSession = null;
    _keyExchange = null;
    _negotiationResult = null;
    _sharedSecret = null;
  }
}