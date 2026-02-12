/// Example demonstrating the new factory methods for all concrete cryptography classes.
///
/// Factory methods follow a consistent pattern:
/// - create() - auto-generates keys and returns an instance
/// - createWithKey()/createWithKeyPair() - uses existing keys and returns an instance
///
/// This design minimizes code duplication as create() internally calls createWithKey().

import 'package:cryptdart/cryptdart.dart';

void main() async {
  print('🔧 CryptDart Factory Methods Examples\n');

  // ============== SYMMETRIC CIPHERS ==============
  print('📦 SYMMETRIC CIPHERS');
  print('─' * 50);

  // AES: Auto-generate key
  final aesAuto = AESCipher.create();
  print('✅ AES with auto-generated key created');

  // AES: With specific key
  final aesKey = AESCipher.generateKey();
  final aesCustom = AESCipher.createWithKey(aesKey);
  print('✅ AES with custom key created');

  // AES: With expiration
  final aesExpiring = AESCipher.create(
    expirationDate: DateTime.now().add(Duration(days: 7)),
    expirationTimes: 1000,
  );
  print('✅ AES with expiration (7 days, 1000 uses) created');

  // ChaCha20: Auto-generate key and nonce
  final chachaAuto = ChaCha20Cipher.create();
  print('✅ ChaCha20 with auto-generated key and nonce created');

  // ChaCha20: With specific key and nonce
  final chachaKey = ChaCha20Cipher.generateKey();
  final chachaNonce = ChaCha20Cipher.generateNonce();
  final chachaCustom = ChaCha20Cipher.createWithKey(
    chachaKey,
    nonce: chachaNonce,
  );
  print('✅ ChaCha20 with custom key and nonce created');

  // DES: Auto-generate key
  final desAuto = DESCipher.create();
  print('✅ DES with auto-generated key created');

  print('');

  // ============== ASYMMETRIC CIPHERS ==============
  print('🔑 ASYMMETRIC CIPHERS');
  print('─' * 50);

  // RSA: Auto-generate key pair
  final rsaAuto = await RSACipher.create();
  print('✅ RSA (2048-bit) with auto-generated key pair created');

  // RSA: Auto-generate with custom bit length
  final rsa4096 = await RSACipher.create(bitLength: 4096);
  print('✅ RSA (4096-bit) with auto-generated key pair created');

  // RSA: With specific key pair
  final rsaKeyPair = await RSACipher.generateKeyPair(bitLength: 2048);
  final rsaCustom = RSACipher.createWithKeyPair(
    rsaKeyPair['publicKey']!,
    rsaKeyPair['privateKey']!,
  );
  print('✅ RSA with custom key pair created');

  print('');

  // ============== DIGITAL SIGNATURES ==============
  print('✍️  DIGITAL SIGNATURES');
  print('─' * 50);

  // HMAC: Auto-generate key
  final hmacAuto = HMACSign.create();
  print('✅ HMAC with auto-generated key created');

  // HMAC: With specific key
  final hmacKey = HMACSign.generateKey();
  final hmacCustom = HMACSign.createWithKey(hmacKey);
  print('✅ HMAC with custom key created');

  // RSA Signature: Auto-generate key pair
  final rsaSigAuto = await RSASignatureCipher.create();
  print('✅ RSA Signature (2048-bit) with auto-generated key pair created');

  // RSA Signature: With specific key pair
  final rsaSigKeyPair = await RSASignatureCipher.generateKeyPair();
  final rsaSigCustom = RSASignatureCipher.createWithKeyPair(
    rsaSigKeyPair['publicKey']!,
    rsaSigKeyPair['privateKey']!,
  );
  print('✅ RSA Signature with custom key pair created');

  // ECDSA: Auto-generate key pair with secp256r1 curve
  final ecdsaAuto = await ECDSASign.create();
  print('✅ ECDSA (secp256r1) with auto-generated key pair created');

  // ECDSA: With custom curve
  final ecdsa384 = await ECDSASign.create(curve: 'prime384v1');
  print('✅ ECDSA (prime384v1) with auto-generated key pair created');

  // ECDSA: With specific key pair
  final ecdsaKeyPair = await ECDSASign.generateKeyPair();
  final ecdsaCustom = ECDSASign.createWithKeyPair(
    ecdsaKeyPair['publicKey']!,
    ecdsaKeyPair['privateKey']!,
  );
  print('✅ ECDSA with custom key pair created');

  print('');

  // ============== KEY EXCHANGE ==============
  print('🔄 KEY EXCHANGE');
  print('─' * 50);

  // ECDH: Auto-generate key pair with secp256r1 curve
  final ecdhAuto = await ECDHKeyExchange.create();
  print('✅ ECDH (secp256r1) with auto-generated key pair created');

  // ECDH: With custom curve
  final ecdh384 = await ECDHKeyExchange.create(
    curve: ECCKeyUtils.secp384r1,
  );
  print('✅ ECDH (secp384r1) with auto-generated key pair created');

  // ECDH: With specific key pair
  final ecdhKeyPair = await ECDHKeyExchange.generateKeyPair();
  final ecdhCustom = ECDHKeyExchange.createWithKeyPair(
    ecdhKeyPair['publicKey']!,
    ecdhKeyPair['privateKey']!,
  );
  print('✅ ECDH with custom key pair created');

  print('');

  // ============== PRACTICAL EXAMPLE ==============
  print('🔐 PRACTICAL EXAMPLE: Encrypt & Decrypt');
  print('─' * 50);

  // Create cipher with expiration
  final cipher = AESCipher.create(
    expirationDate: DateTime.now().add(Duration(hours: 24)),
  );

  final plaintext = 'Secret message! 🤫';
  final encrypted = cipher.encrypt(plaintext.codeUnits);
  final decrypted = cipher.decrypt(encrypted);
  final result = String.fromCharCodes(decrypted);

  print('Plaintext:  $plaintext');
  print('Encrypted:  ${encrypted.take(32).toList()}... (truncated)');
  print('Decrypted:  $result');
  print('Match:      ${plaintext == result ? '✅' : '❌'}');
  print('Expires:    ${cipher.expirationDate}');

  print('');
  print('✨ All factory methods working correctly!');
}
