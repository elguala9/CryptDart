import '../../interfaces/key_exchange/i_algorithm_negotiation.dart';
import '../../types/crypto_algorithm.dart';
import '../../types/key_exchange_algorithm.dart';

/// Default implementation of algorithm negotiation
class AlgorithmNegotiation implements IAlgorithmNegotiation {
  /// Priority order for key exchange algorithms (most secure first)
  static const List<KeyExchangeAlgorithm> _keyExchangePriority = [
    KeyExchangeAlgorithm.ecdh,
    KeyExchangeAlgorithm.rsa,
  ];

  /// Priority order for asymmetric algorithms (most secure first)
  static const List<CryptoAlgorithm> _asymmetricPriority = [
    CryptoAlgorithm.rsa,
  ];

  /// Priority order for symmetric algorithms (most secure first)
  static const List<CryptoAlgorithm> _symmetricPriority = [
    CryptoAlgorithm.chacha20,
    CryptoAlgorithm.aes,
    CryptoAlgorithm.des,
  ];

  @override
  Map<String, dynamic> createHandshakeMessage(CryptoPeerCapabilities capabilities) {
    return {
      'peerId': capabilities.peerId,
      'keyExchange': capabilities.keyExchange
          .map((e) => e.name)
          .toList(),
      'asymmetric': capabilities.asymmetric
          .map((e) => e.name)
          .toList(),
      'symmetric': capabilities.symmetric
          .map((e) => e.name)
          .toList(),
      'version': '1.0',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  @override
  CryptoPeerCapabilities parseHandshakeMessage(Map<String, dynamic> message) {
    final keyExchange = (message['keyExchange'] as List<dynamic>)
        .map((e) => _stringToKeyExchangeAlgorithm(e.toString()))
        .where((e) => e != null)
        .cast<KeyExchangeAlgorithm>()
        .toList();

    final asymmetric = (message['asymmetric'] as List<dynamic>)
        .map((e) => _stringToAlgorithm(e.toString()))
        .where((e) => e != null)
        .cast<CryptoAlgorithm>()
        .toList();

    final symmetric = (message['symmetric'] as List<dynamic>)
        .map((e) => _stringToAlgorithm(e.toString()))
        .where((e) => e != null)
        .cast<CryptoAlgorithm>()
        .toList();

    return (
      peerId: message['peerId'].toString(),
      keyExchange: keyExchange,
      asymmetric: asymmetric,
      symmetric: symmetric,
    );
  }

  @override
  NegotiationResult? negotiateAlgorithms(
    CryptoPeerCapabilities local,
    CryptoPeerCapabilities remote, {
    bool isInitiator = true,
  }) {
    // Find common algorithms
    final commonKeyExchange = local.keyExchange
        .where((alg) => remote.keyExchange.contains(alg))
        .toList();

    final commonAsymmetric = local.asymmetric
        .where((alg) => remote.asymmetric.contains(alg))
        .toList();

    final commonSymmetric = local.symmetric
        .where((alg) => remote.symmetric.contains(alg))
        .toList();

    if (commonKeyExchange.isEmpty || commonAsymmetric.isEmpty || commonSymmetric.isEmpty) {
      return null; // No compatible algorithms
    }

    // Select algorithms using priority order
    final selectedKeyExchange = _keyExchangePriority
        .firstWhere((alg) => commonKeyExchange.contains(alg));

    final selectedAsymmetric = _asymmetricPriority
        .firstWhere((alg) => commonAsymmetric.contains(alg));

    final selectedSymmetric = _symmetricPriority
        .firstWhere((alg) => commonSymmetric.contains(alg));

    return (
      keyExchange: selectedKeyExchange,
      asymmetric: selectedAsymmetric,
      symmetric: selectedSymmetric,
      localPeerId: local.peerId,
      remotePeerId: remote.peerId,
      isInitiator: isInitiator,
    );
  }

  @override
  bool validateNegotiation(NegotiationResult negotiation) {
    // Basic validation
    if (negotiation.localPeerId.isEmpty || negotiation.remotePeerId.isEmpty) {
      return false;
    }

    // Ensure algorithms are supported
    final supportedKeyExchange = _keyExchangePriority;
    final supportedAsymmetric = _asymmetricPriority;
    final supportedSymmetric = _symmetricPriority;

    return supportedKeyExchange.contains(negotiation.keyExchange) &&
        supportedAsymmetric.contains(negotiation.asymmetric) &&
        supportedSymmetric.contains(negotiation.symmetric);
  }


  /// Helper method to convert string to CryptoAlgorithm
  CryptoAlgorithm? _stringToAlgorithm(String algorithmName) {
    try {
      return CryptoAlgorithm.values
          .firstWhere((e) => e.name == algorithmName);
    } catch (e) {
      return null;
    }
  }

  /// Helper method to convert string to KeyExchangeAlgorithm
  KeyExchangeAlgorithm? _stringToKeyExchangeAlgorithm(String algorithmName) {
    try {
      return KeyExchangeAlgorithm.values
          .firstWhere((e) => e.name == algorithmName);
    } catch (e) {
      return null;
    }
  }
}