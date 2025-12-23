import 'dart:convert';
import 'package:cryptdart/cryptdart.dart';

/// Example of bidirectional ECDH communication with algorithm negotiation
Future<void> main() async {
  print('=== CryptDart Bidirectional ECDH Example ===\n');

  try {
    // Simulate message transport between peers
    Map<String, dynamic>? messageFromAlice;
    
    // Peer Alice initiates the session
    print('🔵 Alice (Initiator) starting secure session...');
    final aliceSession = await SecureCommunicationFactory.initiateSecureSession(
      localPeerId: 'alice@example.com',
      sendToRemote: (initiationMessage) async {
        messageFromAlice = initiationMessage;
        print('📤 Alice sent initiation message');
        
        // Peer Bob responds to the session
        print('🟢 Bob (Responder) processing initiation...');
        final bobResult = await SecureCommunicationFactory.respondToSecureSession(
          localPeerId: 'bob@example.com',
          initiationMessage: messageFromAlice!,
        );
        
        print('📤 Bob sent response message');
        print('🟢 Bob session established:');
        print(bobResult.session.sessionInfo);
        print('');
        
        // Test Bob encrypting/decrypting data
        final testDataBob = utf8.encode('Hello from Bob! 🟢');
        final encryptedByBob = bobResult.session.encryptData(testDataBob);
        final decryptedByBob = bobResult.session.decryptData(encryptedByBob);
        print('🟢 Bob test: "${utf8.decode(decryptedByBob)}" ✅\n');
        
        return bobResult.responseMessage;
      },
    );

    print('🔵 Alice session established:');
    print(aliceSession.sessionInfo);
    print('');

    // Test Alice encrypting/decrypting data
    final testDataAlice = utf8.encode('Hello from Alice! 🔵');
    final encryptedByAlice = aliceSession.encryptData(testDataAlice);
    final decryptedByAlice = aliceSession.decryptData(encryptedByAlice);
    print('🔵 Alice test: "${utf8.decode(decryptedByAlice)}" ✅');

    print('\n✨ Secure bidirectional communication established successfully!');
    print('Both peers can now use their handlers to encrypt/decrypt data.');

  } catch (e, stackTrace) {
    print('❌ Error: $e');
    print('Stack trace: $stackTrace');
  }
}