import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:meta/meta.dart';
import '../i_handler.dart';
import 'i_algorithm_negotiation.dart';

/// Represents an established secure session between two peers.
@immutable
class SecureSession {
  final IHandlerCipher asymmetricHandler;
  final IHandlerCipher symmetricHandler;
  final NegotiationResult negotiationResult;
  final String sharedSecret;
  final DateTime establishedAt;

  const SecureSession({
    required this.asymmetricHandler,
    required this.symmetricHandler,
    required this.negotiationResult,
    required this.sharedSecret,
    required this.establishedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecureSession &&
          runtimeType == other.runtimeType &&
          asymmetricHandler == other.asymmetricHandler &&
          symmetricHandler == other.symmetricHandler &&
          negotiationResult == other.negotiationResult &&
          sharedSecret == other.sharedSecret &&
          establishedAt == other.establishedAt;

  @override
  int get hashCode =>
      asymmetricHandler.hashCode ^
      symmetricHandler.hashCode ^
      negotiationResult.hashCode ^
      sharedSecret.hashCode ^
      establishedAt.hashCode;

  @override
  String toString() =>
      'SecureSession(asymmetricHandler: $asymmetricHandler, symmetricHandler: $symmetricHandler, negotiationResult: $negotiationResult, sharedSecret: $sharedSecret, establishedAt: $establishedAt)';
}

/// Interface for managing cryptographic sessions between peers.
@includeInBarrelFile
abstract class ICryptoSession {
  /// Initiates a session establishment process with remote peer.
  /// Returns the handshake message to send to the remote peer.
  Future<Map<String, dynamic>> initiateSession(CryptoPeerCapabilities localCapabilities);

  /// Responds to a session initiation from a remote peer.
  /// Returns the response message to send back.
  Future<Map<String, dynamic>> respondToSession(
    Map<String, dynamic> initiationMessage,
    CryptoPeerCapabilities localCapabilities,
  );

  /// Finalizes the session establishment process.
  /// Called by the initiator after receiving the response.
  Future<SecureSession> finalizeSession(
    Map<String, dynamic> responseMessage,
  );

  /// Completes the session establishment process.
  /// Called by the responder after sending the response.
  Future<SecureSession> completeSession();

  /// Gets the current session if established.
  SecureSession? get currentSession;

  /// Closes the current session and cleans up resources.
  Future<void> closeSession();
}