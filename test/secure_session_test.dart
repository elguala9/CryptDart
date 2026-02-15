import 'package:test/test.dart';
import 'package:cryptdart/cryptdart.dart';
import 'dart:convert';

void main() {
  group('Secure Session Tests', () {
    test('should establish bidirectional ECDH session', () async {
      // Create two peers with different algorithm preferences
      final aliceCapabilities = SecureCommunicationFactory.createDefaultCapabilities(
        peerId: 'alice',
      );

      final bobCapabilities = SecureCommunicationFactory.createDefaultCapabilities(
        peerId: 'bob',
      );

      // Alice initiates session
      final aliceSessionManager = CryptoSessionManager();
      final initiationMessage = await aliceSessionManager.initiateSession(aliceCapabilities);

      expect(initiationMessage['peerId'], equals('alice'));
      expect(initiationMessage['keyExchangeData']['type'], equals('ecdh'));

      // Bob responds
      final bobSessionManager = CryptoSessionManager();
      final responseMessage = await bobSessionManager.respondToSession(
        initiationMessage,
        bobCapabilities,
      );

      expect(responseMessage['peerId'], equals('bob'));
      expect(responseMessage['negotiation']['keyExchange'], equals('ecdh'));
      expect(responseMessage['negotiation']['asymmetric'], equals('rsa')); 
      expect(responseMessage['negotiation']['symmetric'], equals('chacha20')); 

      // Alice finalizes
      final aliceSession = await aliceSessionManager.finalizeSession(responseMessage);
      
      // Bob completes
      final bobSession = await bobSessionManager.completeSession();

      // Verify sessions are established
      expect(aliceSession.negotiationResult.keyExchange, equals(KeyExchangeAlgorithm.ecdh));
      expect(aliceSession.negotiationResult.asymmetric, equals(AsymmetricCipherAlgorithm.rsa));
      expect(aliceSession.negotiationResult.symmetric, equals(SymmetricCipherAlgorithm.chacha20));
      expect(bobSession.negotiationResult.keyExchange, equals(KeyExchangeAlgorithm.ecdh));
      expect(bobSession.negotiationResult.asymmetric, equals(AsymmetricCipherAlgorithm.rsa));
      expect(bobSession.negotiationResult.symmetric, equals(SymmetricCipherAlgorithm.chacha20));

      // Test symmetric encryption/decryption
      final testData = utf8.encode('Hello secure world!');
      
      // Alice encrypts, Bob should be able to decrypt with same shared secret
      final aliceEncrypted = aliceSession.encryptData(testData);
      expect(aliceEncrypted.isNotEmpty, isTrue);
      expect(aliceEncrypted, isNot(equals(testData))); // Should be different when encrypted

      // Test alice can decrypt her own encryption
      final aliceDecrypted = aliceSession.decryptData(aliceEncrypted);
      expect(aliceDecrypted, equals(testData));

      // Test Bob's encryption/decryption
      final bobEncrypted = bobSession.encryptData(testData);
      final bobDecrypted = bobSession.decryptData(bobEncrypted);
      expect(bobDecrypted, equals(testData));

      print('✅ Bidirectional ECDH session test passed');
    });

    test('should fail with incompatible algorithms', () async {
      // Alice only supports ECDH and ChaCha20
      final aliceCapabilities = SecureCommunicationFactory.createDefaultCapabilities(
        peerId: 'alice',
        supportedKeyExchange: [KeyExchangeAlgorithm.ecdh],
        supportedAsymmetric: [AsymmetricCipherAlgorithm.rsa],
        supportedSymmetric: [SymmetricCipherAlgorithm.chacha20],
      );

      // Bob only supports RSA key exchange and AES (incompatible key exchange)
      final bobCapabilities = SecureCommunicationFactory.createDefaultCapabilities(
        peerId: 'bob',
        supportedKeyExchange: [KeyExchangeAlgorithm.rsa],
        supportedAsymmetric: [AsymmetricCipherAlgorithm.rsa],
        supportedSymmetric: [SymmetricCipherAlgorithm.aes],
      );

      final aliceSessionManager = CryptoSessionManager();
      final bobSessionManager = CryptoSessionManager();

      final initiationMessage = await aliceSessionManager.initiateSession(aliceCapabilities);

      // Should fail due to incompatible key exchange algorithms
      expect(
        () => bobSessionManager.respondToSession(initiationMessage, bobCapabilities),
        throwsA(isA<StateError>()),
      );

      print('✅ Incompatible algorithms test passed');
    });

    test('should use SecureCommunicationFactory properly', () async {
      final session = await SecureCommunicationFactory.initiateSecureSession(
        localPeerId: 'test-alice',
        sendToRemote: (initMessage) async {
          
          final bobResult = await SecureCommunicationFactory.respondToSecureSession(
            localPeerId: 'test-bob',
            initiationMessage: initMessage,
          );
          
          return bobResult.responseMessage;
        },
      );

      expect(session.negotiationResult.localPeerId, isNotEmpty);
      print('Shared secret length: ${session.sharedSecret.length}');
      expect(session.sharedSecret.length, greaterThan(0));
      expect(session.establishedAt.isBefore(DateTime.now().add(Duration(seconds: 1))), isTrue);

      // Test data encryption
      final originalData = utf8.encode('Factory test message');
      final encrypted = session.encryptData(originalData);
      final decrypted = session.decryptData(encrypted);
      
      expect(utf8.decode(decrypted), equals('Factory test message'));

      print('✅ SecureCommunicationFactory test passed');
    });
  });
}