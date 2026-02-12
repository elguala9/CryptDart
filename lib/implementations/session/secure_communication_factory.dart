import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import '../../interfaces/key_exchange/i_crypto_session.dart';
import '../../interfaces/key_exchange/i_algorithm_negotiation.dart';
import '../../implementations/session/crypto_session_manager.dart';
import '../../types/crypto_algorithm.dart';
import '../../types/key_exchange_algorithm.dart';

/// High-level factory for creating secure bidirectional communication sessions
@includeInBarrelFile
class SecureCommunicationFactory {
  /// Creates a default peer capability set
  static CryptoPeerCapabilities createDefaultCapabilities({
    required String peerId,
    List<KeyExchangeAlgorithm>? supportedKeyExchange,
    List<CryptoAlgorithm>? supportedAsymmetric,
    List<CryptoAlgorithm>? supportedSymmetric,
    KeyExchangeAlgorithm? preferredKeyExchange,
    CryptoAlgorithm? preferredAsymmetric,
    CryptoAlgorithm? preferredSymmetric,
  }) {
    return (
      peerId: peerId,
      keyExchange: supportedKeyExchange ?? [
        KeyExchangeAlgorithm.ecdh,
        KeyExchangeAlgorithm.rsa,
      ],
      asymmetric: supportedAsymmetric ?? [
        CryptoAlgorithm.rsa,
      ],
      symmetric: supportedSymmetric ?? [
        CryptoAlgorithm.chacha20,
        CryptoAlgorithm.aes,
        CryptoAlgorithm.des,
      ],
    );
  }

  /// Creates a new session manager
  static CryptoSessionManager createSessionManager() {
    return CryptoSessionManager();
  }

  /// Full workflow for session initiator
  static Future<SecureSession> initiateSecureSession({
    required String localPeerId,
    required Future<Map<String, dynamic>> Function(Map<String, dynamic>) sendToRemote,
    List<CryptoAlgorithm>? supportedAsymmetric,
    List<CryptoAlgorithm>? supportedSymmetric,
    CryptoAlgorithm? preferredAsymmetric,
    CryptoAlgorithm? preferredSymmetric,
  }) async {
    final sessionManager = createSessionManager();
    
    final localCapabilities = createDefaultCapabilities(
      peerId: localPeerId,
      supportedAsymmetric: supportedAsymmetric,
      supportedSymmetric: supportedSymmetric,
      preferredAsymmetric: preferredAsymmetric,
      preferredSymmetric: preferredSymmetric,
    );

    // Step 1: Send initiation message
    final initiationMessage = await sessionManager.initiateSession(localCapabilities);
    
    // Step 2: Receive response from remote peer
    final responseMessage = await sendToRemote(initiationMessage);
    
    // Step 3: Finalize session
    final session = await sessionManager.finalizeSession(responseMessage);
    
    return session;
  }

  /// Full workflow for session responder
  static Future<({SecureSession session, Map<String, dynamic> responseMessage})> respondToSecureSession({
    required String localPeerId,
    required Map<String, dynamic> initiationMessage,
    List<CryptoAlgorithm>? supportedAsymmetric,
    List<CryptoAlgorithm>? supportedSymmetric,
    CryptoAlgorithm? preferredAsymmetric,
    CryptoAlgorithm? preferredSymmetric,
  }) async {
    final sessionManager = createSessionManager();
    
    final localCapabilities = createDefaultCapabilities(
      peerId: localPeerId,
      supportedAsymmetric: supportedAsymmetric,
      supportedSymmetric: supportedSymmetric,
      preferredAsymmetric: preferredAsymmetric,
      preferredSymmetric: preferredSymmetric,
    );

    // Step 1: Respond to initiation
    final responseMessage = await sessionManager.respondToSession(
      initiationMessage,
      localCapabilities,
    );
    
    // Step 2: Complete session
    final session = await sessionManager.completeSession();
    
    return (session: session, responseMessage: responseMessage);
  }
}

/// Extension methods for easier session usage
extension SecureSessionExtensions on SecureSession {
  /// Encrypts data using the negotiated symmetric cipher
  List<int> encryptData(List<int> data) {
    return symmetricHandler.encrypt(data);
  }

  /// Decrypts data using the negotiated symmetric cipher
  List<int> decryptData(List<int> encryptedData) {
    return symmetricHandler.decrypt(encryptedData);
  }

  /// Encrypts data using the asymmetric cipher (for key exchange, signatures, etc.)
  List<int> encryptAsymmetric(List<int> data) {
    return asymmetricHandler.encrypt(data);
  }

  /// Decrypts data using the asymmetric cipher
  List<int> decryptAsymmetric(List<int> encryptedData) {
    return asymmetricHandler.decrypt(encryptedData);
  }

  /// Gets session information
  String get sessionInfo {
    return 'Session established at ${establishedAt.toIso8601String()}\n'
        'Key Exchange: ${negotiationResult.keyExchange.name}\n'
        'Asymmetric: ${negotiationResult.asymmetric.name}\n'
        'Symmetric: ${negotiationResult.symmetric.name}\n'
        'Local Peer: ${negotiationResult.localPeerId}\n'
        'Remote Peer: ${negotiationResult.remotePeerId}\n'
        'Is Initiator: ${negotiationResult.isInitiator}';
  }
}