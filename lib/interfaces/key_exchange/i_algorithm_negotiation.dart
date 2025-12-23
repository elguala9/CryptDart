import '../../types/crypto_algorithm.dart';
import '../../types/key_exchange_algorithm.dart';

/// Represents the capability set of a cryptographic peer.
typedef CryptoPeerCapabilities = ({
  List<KeyExchangeAlgorithm> keyExchange,
  List<CryptoAlgorithm> asymmetric,
  List<CryptoAlgorithm> symmetric,
  String peerId,
});

/// Result of algorithm negotiation between two peers.
typedef NegotiationResult = ({
  KeyExchangeAlgorithm keyExchange,
  CryptoAlgorithm asymmetric,
  CryptoAlgorithm symmetric,
  String localPeerId,
  String remotePeerId,
  bool isInitiator,
});

/// Interface for algorithm negotiation between cryptographic peers.
abstract class IAlgorithmNegotiation {
  /// Creates a handshake message containing this peer's capabilities.
  Map<String, dynamic> createHandshakeMessage(CryptoPeerCapabilities capabilities);

  /// Parses a handshake message from the remote peer.
  CryptoPeerCapabilities parseHandshakeMessage(Map<String, dynamic> message);

  /// Negotiates algorithms based on local and remote capabilities.
  /// Returns null if no compatible algorithms are found.
  NegotiationResult? negotiateAlgorithms(
    CryptoPeerCapabilities local,
    CryptoPeerCapabilities remote,
    {bool isInitiator = true}
  );

  /// Validates that the negotiated algorithms are supported and secure.
  bool validateNegotiation(NegotiationResult negotiation);
}