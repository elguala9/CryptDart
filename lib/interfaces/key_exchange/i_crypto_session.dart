import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import '../i_handler.dart';
import 'i_algorithm_negotiation.dart';

/// Represents an established secure session between two peers.
typedef SecureSession = ({
  IHandlerCipher asymmetricHandler,
  IHandlerCipher symmetricHandler,
  NegotiationResult negotiationResult,
  String sharedSecret,
  DateTime establishedAt,
});

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