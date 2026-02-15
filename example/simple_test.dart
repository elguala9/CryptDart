/// Simple CryptDart Test Example
/// 
/// Quick test to verify all functionality works
/// Run with: dart run example/simple_test.dart

import 'package:cryptdart/cryptdart.dart';
import 'dart:typed_data';
import 'dart:convert';

void main() async {
  print('🧪 CryptDart Simple Test\n');
  
  await testSymmetric();
  await testAsymmetric(); 
  await testSignatures();
  await testECDH();
  await testSecureSessions();
  
  print('\n✅ All tests completed successfully!');
}

Future<void> testSymmetric() async {
  print('🔐 Testing Symmetric Encryption...');
  
  // AES Test
  final aesKey = AESCipher.generateKey();
  final aes = AESCipher((
    parent: (
      key: aesKey,
      parent: (
        parent: (
          expirationDate: DateTime.now().add(Duration(hours: 1)),
          expirationTimes: null,
        ),
      ),
    ),
  ));
  
  final data = 'Hello AES!';
  final encrypted = aes.encrypt(data.codeUnits);
  final decrypted = aes.decrypt(encrypted);
  print('  AES: ${String.fromCharCodes(decrypted) == data ? '✅' : '❌'}');
  
  // ChaCha20 Test
  final chachaKey = ChaCha20Cipher.generateKey();
  final nonce = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
  final chacha = ChaCha20Cipher((
    nonce: nonce,
    parent: (
      key: chachaKey,
      parent: (
        parent: (
          expirationDate: DateTime.now().add(Duration(hours: 1)),
          expirationTimes: null,
        ),
      ),
    ),
  ));
  
  final chachaEncrypted = chacha.encrypt(data.codeUnits);
  final chachaDecrypted = chacha.decrypt(chachaEncrypted);
  print('  ChaCha20: ${String.fromCharCodes(chachaDecrypted) == data ? '✅' : '❌'}');
}

Future<void> testAsymmetric() async {
  print('🔑 Testing Asymmetric Encryption...');
  
  final keyPair = await RSACipher.generateKeyPair();
  final rsa = RSACipher((
    parent: (
      publicKey: keyPair['publicKey']!,
      privateKey: keyPair['privateKey']!,
      parent: (
        parent: (
          expirationDate: DateTime.now().add(Duration(hours: 1)),
          expirationTimes: null,
        ),
      ),
    ),
  ));
  
  final data = 'Hello RSA!';
  final encrypted = await rsa.encrypt(data.codeUnits);
  final decrypted = await rsa.decrypt(encrypted);
  print('  RSA: ${String.fromCharCodes(decrypted) == data ? '✅' : '❌'}');
}

Future<void> testSignatures() async {
  print('✍️  Testing Digital Signatures...');
  
  // HMAC Test
  final hmacKey = HMACSign.generateKey();
  final hmac = HMACSign((
    parent: (
      key: hmacKey,
      parent: (
        parent: (
          expirationDate: DateTime.now().add(Duration(hours: 1)),
          expirationTimes: null,
        ),
      ),
    ),
  ));
  
  final data = 'Sign this document';
  final signature = hmac.sign(data.codeUnits);
  final verified = hmac.verify(data.codeUnits, signature);
  print('  HMAC: ${verified ? '✅' : '❌'}');
  
  // RSA Signature Test
  final rsaKeys = await RSASignatureCipher.generateKeyPair();
  final rsaSig = RSASignatureCipher((
    parent: (
      publicKey: rsaKeys['publicKey']!,
      privateKey: rsaKeys['privateKey']!,
      parent: (
        parent: (
          expirationDate: DateTime.now().add(Duration(hours: 1)),
          expirationTimes: null,
        ),
      ),
    ),
  ));
  
  final rsaSignature = rsaSig.sign(data.codeUnits);
  final rsaVerified = rsaSig.verify(data.codeUnits, rsaSignature);
  print('  RSA Signature: ${rsaVerified ? '✅' : '❌'}');
}

Future<void> testECDH() async {
  print('🔄 Testing ECDH Key Exchange...');
  
  // Alice
  final aliceKeys = await ECDHKeyExchange.generateKeyPair();
  final alice = ECDHKeyExchange((
    parent: (
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(hours: 1)),
      expirationTimes: null,
    ),
    publicKey: aliceKeys['publicKey']!,
    privateKey: aliceKeys['privateKey']!,
    curve: ECCKeyUtils.secp256r1,
  ));
  
  // Bob
  final bobKeys = await ECDHKeyExchange.generateKeyPair();
  final bob = ECDHKeyExchange((
    parent: (
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(hours: 1)),
      expirationTimes: null,
    ),
    publicKey: bobKeys['publicKey']!,
    privateKey: bobKeys['privateKey']!,
    curve: ECCKeyUtils.secp256r1,
  ));
  
  final aliceSecret = await alice.generateSharedSecret(bob.publicKey);
  final bobSecret = await bob.generateSharedSecret(alice.publicKey);
  print('  ECDH: ${aliceSecret == bobSecret ? '✅' : '❌'}');
}

Future<void> testSecureSessions() async {
  print('🌐 Testing Secure Sessions...');
  
  final session = await SecureCommunicationFactory.initiateSecureSession(
    localPeerId: 'test-alice',
    supportedAsymmetric: [AsymmetricCipherAlgorithm.rsa],
    supportedSymmetric: [SymmetricCipherAlgorithm.chacha20],
    sendToRemote: (initMessage) async {
      final bobResult = await SecureCommunicationFactory.respondToSecureSession(
        localPeerId: 'test-bob',
        initiationMessage: initMessage,
        supportedAsymmetric: [AsymmetricCipherAlgorithm.rsa],
        supportedSymmetric: [SymmetricCipherAlgorithm.chacha20],
      );
      return bobResult.responseMessage;
    },
  );
  
  final testData = 'Secure message test';
  final encrypted = session.encryptData(utf8.encode(testData));
  final decrypted = session.decryptData(encrypted);
  final result = utf8.decode(decrypted);
  print('  Secure Session: ${result == testData ? '✅' : '❌'}');
}