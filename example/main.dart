/// Comprehensive CryptDart Example
/// 
/// This example demonstrates all the features of the CryptDart library:
/// - Symmetric encryption (AES, ChaCha20, DES)
/// - Asymmetric encryption (RSA)
/// - Digital signatures (HMAC, RSA signatures)
/// - ECDH key exchange
/// - Secure communication sessions
/// 
/// Run with: dart run example/main.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptdart/cryptdart.dart';

void main() async {
  print('🔒 CryptDart - Comprehensive Cryptography Example\n');
  
  await demonstrateSymmetricEncryption();
  await demonstrateAsymmetricEncryption();
  await demonstrateDigitalSignatures();
  await demonstrateECDHKeyExchange();
  await demonstrateSecureSessions();
  
  print('\n🎉 All cryptographic operations completed successfully!');
}

/// Demonstrates symmetric encryption with AES, ChaCha20, and DES
Future<void> demonstrateSymmetricEncryption() async {
  print('🔐 === SYMMETRIC ENCRYPTION DEMO ===');
  
  // AES Example
  print('\n📝 AES-256 Encryption:');
  final aesKey = AESCipher.generateKey();
  print('   Generated key: ${aesKey.substring(0, 16)}...');
  
  final aes = AESCipher((
    parent: (
      key: aesKey,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.aes,
          expirationDate: DateTime.now().add(Duration(hours: 24)),
          expirationTimes: null,
        ),
      ),
    ),
  ));
  
  final message = 'Confidential AES message';
  final aesEncrypted = aes.encrypt(utf8.encode(message));
  final aesDecrypted = utf8.decode(aes.decrypt(aesEncrypted));
  print('   Original: $message');
  print('   Encrypted: ${aesEncrypted.length} bytes');
  print('   Decrypted: $aesDecrypted');
  print('   ✅ AES encryption successful');
  
  // ChaCha20 Example
  print('\n🚀 ChaCha20 Encryption:');
  final chachaKey = ChaCha20Cipher.generateKey();
  final nonce = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
  print('   Generated key: ${chachaKey.substring(0, 16)}...');
  
  final chacha = ChaCha20Cipher((
    nonce: nonce,
    parent: (
      key: chachaKey,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.chacha20,
          expirationDate: DateTime.now().add(Duration(hours: 12)),
          expirationTimes: null,
        ),
      ),
    ),
  ));
  
  final chachaMessage = 'High-performance ChaCha20 message';
  final chachaEncrypted = chacha.encrypt(utf8.encode(chachaMessage));
  final chachaDecrypted = utf8.decode(chacha.decrypt(chachaEncrypted));
  print('   Original: $chachaMessage');
  print('   Encrypted: ${chachaEncrypted.length} bytes');
  print('   Decrypted: $chachaDecrypted');
  print('   ✅ ChaCha20 encryption successful');
  
  // DES Example
  print('\n🔧 DES Encryption (Legacy):');
  final desKey = DESCipher.generateKey();
  print('   Generated key: ${desKey.substring(0, 16)}...');
  
  final des = DESCipher((
    parent: (
      key: desKey,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.des,
          expirationDate: DateTime.now().add(Duration(hours: 1)),
          expirationTimes: null,
        ),
      ),
    ),
  ));
  
  final desMessage = 'Legacy DES message';
  final desEncrypted = des.encrypt(utf8.encode(desMessage));
  final desDecrypted = utf8.decode(des.decrypt(desEncrypted));
  print('   Original: $desMessage');
  print('   Encrypted: ${desEncrypted.length} bytes');
  print('   Decrypted: $desDecrypted');
  print('   ✅ DES encryption successful');
}

/// Demonstrates asymmetric encryption with RSA
Future<void> demonstrateAsymmetricEncryption() async {
  print('\n🔑 === ASYMMETRIC ENCRYPTION DEMO ===');
  
  print('\n🔒 RSA-2048 Encryption:');
  final rsaKeys = await RSACipher.generateKeyPair(bitLength: 2048);
  print('   Generated RSA key pair (2048-bit)');
  
  final rsa = RSACipher((
    parent: (
      publicKey: rsaKeys['publicKey']!,
      privateKey: rsaKeys['privateKey']!,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.rsa,
          expirationDate: DateTime.now().add(Duration(days: 30)),
          expirationTimes: null,
        ),
      ),
    ),
  ));
  
  final rsaMessage = 'Secret RSA message';
  final rsaEncrypted = await rsa.encrypt(utf8.encode(rsaMessage));
  final rsaDecrypted = utf8.decode(await rsa.decrypt(rsaEncrypted));
  print('   Original: $rsaMessage');
  print('   Encrypted: ${rsaEncrypted.length} bytes');
  print('   Decrypted: $rsaDecrypted');
  print('   ✅ RSA encryption successful');
}

/// Demonstrates digital signatures with HMAC and RSA
Future<void> demonstrateDigitalSignatures() async {
  print('\n✍️  === DIGITAL SIGNATURES DEMO ===');
  
  // HMAC Signatures
  print('\n🔐 HMAC Signature:');
  final hmacKey = HMACSign.generateKey();
  print('   Generated HMAC key: ${hmacKey.substring(0, 16)}...');
  
  final hmac = HMACSign((
    parent: (
      key: hmacKey,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.hmac,
          expirationDate: DateTime.now().add(Duration(hours: 6)),
          expirationTimes: null,
        ),
      ),
    ),
  ));
  
  final contract = 'Important contract to sign';
  final hmacSignature = hmac.sign(utf8.encode(contract));
  final hmacVerified = hmac.verify(utf8.encode(contract), hmacSignature);
  print('   Document: $contract');
  print('   Signature: ${hmacSignature.sublist(0, 8)}... (${hmacSignature.length} bytes)');
  print('   Verified: $hmacVerified');
  print('   ✅ HMAC signature successful');
  
  // RSA Signatures
  print('\n🔒 RSA Signature:');
  final rsaSigKeys = await RSASignatureCipher.generateKeyPair(bitLength: 2048);
  print('   Generated RSA signature key pair (2048-bit)');
  
  final rsaSign = RSASignatureCipher((
    parent: (
      publicKey: rsaSigKeys['publicKey']!,
      privateKey: rsaSigKeys['privateKey']!,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.rsaSignature,
          expirationDate: DateTime.now().add(Duration(days: 365)),
          expirationTimes: null,
        ),
      ),
    ),
  ));
  
  final certificate = 'Digital certificate content';
  final rsaSignature = rsaSign.sign(utf8.encode(certificate));
  final rsaVerified = rsaSign.verify(utf8.encode(certificate), rsaSignature);
  print('   Certificate: $certificate');
  print('   Signature: ${rsaSignature.sublist(0, 8)}... (${rsaSignature.length} bytes)');
  print('   Verified: $rsaVerified');
  print('   ✅ RSA signature successful');
}

/// Demonstrates ECDH key exchange
Future<void> demonstrateECDHKeyExchange() async {
  print('\n🔄 === ECDH KEY EXCHANGE DEMO ===');
  
  print('\n👥 Alice and Bob ECDH Exchange:');
  
  // Alice generates her key pair
  final aliceKeys = await ECDHKeyExchange.generateKeyPair(curve: ECCKeyUtils.secp256r1);
  final alice = ECDHKeyExchange((
    parent: (
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(minutes: 30)),
      expirationTimes: null,
    ),
    publicKey: aliceKeys['publicKey']!,
    privateKey: aliceKeys['privateKey']!,
    curve: ECCKeyUtils.secp256r1,
  ));
  print('   👩 Alice generated secp256r1 key pair');
  
  // Bob generates his key pair
  final bobKeys = await ECDHKeyExchange.generateKeyPair(curve: ECCKeyUtils.secp256r1);
  final bob = ECDHKeyExchange((
    parent: (
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(minutes: 30)),
      expirationTimes: null,
    ),
    publicKey: bobKeys['publicKey']!,
    privateKey: bobKeys['privateKey']!,
    curve: ECCKeyUtils.secp256r1,
  ));
  print('   👨 Bob generated secp256r1 key pair');
  
  // Both compute the same shared secret
  final aliceSharedSecret = await alice.generateSharedSecret(bob.publicKey);
  final bobSharedSecret = await bob.generateSharedSecret(alice.publicKey);
  
  print('   🔐 Alice computed shared secret: ${aliceSharedSecret.substring(0, 16)}...');
  print('   🔐 Bob computed shared secret: ${bobSharedSecret.substring(0, 16)}...');
  print('   🤝 Shared secrets match: ${aliceSharedSecret == bobSharedSecret}');
  print('   ✅ ECDH key exchange successful');
}

/// Demonstrates secure communication sessions
Future<void> demonstrateSecureSessions() async {
  print('\n🌐 === SECURE COMMUNICATION DEMO ===');
  
  print('\n🤝 Establishing secure session between Alice and Bob...');
  
  // Alice initiates a secure session with Bob
  final aliceSession = await SecureCommunicationFactory.initiateSecureSession(
    localPeerId: 'alice@example.com',
    supportedAsymmetric: [CryptoAlgorithm.rsa],
    supportedSymmetric: [CryptoAlgorithm.chacha20, CryptoAlgorithm.aes],
    sendToRemote: (initiationMessage) async {
      // Simulate Bob receiving Alice's message and responding
      print('   📨 Alice sent initiation message to Bob');
      
      final bobResponse = await SecureCommunicationFactory.respondToSecureSession(
        localPeerId: 'bob@example.com',
        initiationMessage: initiationMessage,
        supportedAsymmetric: [CryptoAlgorithm.rsa],
        supportedSymmetric: [CryptoAlgorithm.aes, CryptoAlgorithm.chacha20],
      );
      
      print('   📬 Bob responded with negotiated parameters');
      return bobResponse.responseMessage;
    },
  );
  
  print('   🔒 Secure session established!');
  print('   🆔 Local peer: ${aliceSession.negotiationResult.localPeerId}');
  print('   🆔 Remote peer: ${aliceSession.negotiationResult.remotePeerId}');
  print('   🔐 Key exchange: ${aliceSession.negotiationResult.keyExchange}');
  print('   🔐 Asymmetric: ${aliceSession.negotiationResult.asymmetric}');
  print('   🔐 Symmetric: ${aliceSession.negotiationResult.symmetric}');
  print('   🕒 Established: ${aliceSession.establishedAt}');
  
  // Test secure communication
  final secretMessage = 'This is a confidential message sent through secure session';
  final encryptedMessage = aliceSession.encryptData(utf8.encode(secretMessage));
  final decryptedMessage = utf8.decode(aliceSession.decryptData(encryptedMessage));
  
  print('   📝 Original: $secretMessage');
  print('   🔒 Encrypted: ${encryptedMessage.length} bytes');
  print('   📖 Decrypted: $decryptedMessage');
  print('   🔍 Messages match: ${secretMessage == decryptedMessage}');
  print('   ✅ Secure communication successful');
}
