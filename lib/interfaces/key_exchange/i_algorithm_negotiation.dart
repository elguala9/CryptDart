import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:meta/meta.dart';
import '../../types/crypto_algorithm.dart';
import '../../types/key_exchange_algorithm.dart';

/// Represents the capability set of a cryptographic peer.
@immutable
class CryptoPeerCapabilities {
  final List<KeyExchangeAlgorithm> keyExchange;
  final List<CryptoAlgorithm> asymmetric;
  final List<CryptoAlgorithm> symmetric;
  final String peerId;

  const CryptoPeerCapabilities({
    required this.keyExchange,
    required this.asymmetric,
    required this.symmetric,
    required this.peerId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CryptoPeerCapabilities &&
          runtimeType == other.runtimeType &&
          keyExchange == other.keyExchange &&
          asymmetric == other.asymmetric &&
          symmetric == other.symmetric &&
          peerId == other.peerId;

  @override
  int get hashCode =>
      keyExchange.hashCode ^
      asymmetric.hashCode ^
      symmetric.hashCode ^
      peerId.hashCode;

  @override
  String toString() =>
      'CryptoPeerCapabilities(keyExchange: $keyExchange, asymmetric: $asymmetric, symmetric: $symmetric, peerId: $peerId)';
}

/// Result of algorithm negotiation between two peers.
@immutable
class NegotiationResult {
  final KeyExchangeAlgorithm keyExchange;
  final CryptoAlgorithm asymmetric;
  final CryptoAlgorithm symmetric;
  final String localPeerId;
  final String remotePeerId;
  final bool isInitiator;

  const NegotiationResult({
    required this.keyExchange,
    required this.asymmetric,
    required this.symmetric,
    required this.localPeerId,
    required this.remotePeerId,
    required this.isInitiator,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NegotiationResult &&
          runtimeType == other.runtimeType &&
          keyExchange == other.keyExchange &&
          asymmetric == other.asymmetric &&
          symmetric == other.symmetric &&
          localPeerId == other.localPeerId &&
          remotePeerId == other.remotePeerId &&
          isInitiator == other.isInitiator;

  @override
  int get hashCode =>
      keyExchange.hashCode ^
      asymmetric.hashCode ^
      symmetric.hashCode ^
      localPeerId.hashCode ^
      remotePeerId.hashCode ^
      isInitiator.hashCode;

  @override
  String toString() =>
      'NegotiationResult(keyExchange: $keyExchange, asymmetric: $asymmetric, symmetric: $symmetric, localPeerId: $localPeerId, remotePeerId: $remotePeerId, isInitiator: $isInitiator)';
}

/// Interface for algorithm negotiation between cryptographic peers.
@includeInBarrelFile
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