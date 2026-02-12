/// Example demonstrating the CipherFactory for creating cryptographic instances.
///
/// This example shows how to use the centralized CipherFactory to instantiate
/// different types of ciphers, signatures, and key exchange objects based on
/// algorithm enums.

import 'package:cryptdart/cryptdart.dart';

void main() async {
  print('🏭 CipherFactory Example\n');

  // ============================================================================
  // SYMMETRIC CIPHERS
  // ============================================================================
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('1. SYMMETRIC CIPHERS');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // Create AES cipher
  print('Creating AES cipher...');
  final aesKey = AESCipher.generateKey();
  final aes = CipherFactory.symmetric(
    SymmetricCipherAlgorithm.aes,
    (
      key: aesKey,
      parent: (
        parent: (
          expirationDate: DateTime.now().add(Duration(days: 30)),
          expirationTimes: 1000,
        ),
      ),
    ),
  );
  print('✅ AES cipher created: ${aes.runtimeType}');
  print('   Key ID: ${aes.keyId}\n');

  // Create DES cipher
  print('Creating DES cipher...');
  final desKey = DESCipher.generateKey();
  final des = CipherFactory.symmetric(
    SymmetricCipherAlgorithm.des,
    (
      key: desKey,
      parent: (
        parent: (
          expirationDate: DateTime.now().add(Duration(days: 7)),
          expirationTimes: null,
        ),
      ),
    ),
  );
  print('✅ DES cipher created: ${des.runtimeType}\n');

  // Create ChaCha20 cipher
  print('Creating ChaCha20 cipher...');
  final chachaKey = ChaCha20Cipher.generateKey();
  final chachaNonce = ChaCha20Cipher.generateNonce();
  final chacha = CipherFactory.chacha20(
    (
      parent: (
        key: chachaKey,
        parent: (
          parent: (
            expirationDate: null,
            expirationTimes: 500,
          ),
        ),
      ),
      nonce: chachaNonce,
    ),
  );
  print('✅ ChaCha20 cipher created: ${chacha.runtimeType}\n');

  // ============================================================================
  // SYMMETRIC SIGNATURES
  // ============================================================================
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('2. SYMMETRIC SIGNATURES');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // Create HMAC signature
  print('Creating HMAC signature...');
  final hmacKey = HMACSign.generateKey();
  final hmac = CipherFactory.symmetricSign(
    SymmetricSignAlgorithm.hmac,
    (
      key: hmacKey,
      parent: (
        parent: (
          expirationDate: DateTime.now().add(Duration(hours: 24)),
          expirationTimes: 5000,
        ),
      ),
    ),
  );
  print('✅ HMAC signature created: ${hmac.runtimeType}');

  // Test HMAC signing
  final data = [72, 101, 108, 108, 111]; // "Hello"
  final signature = hmac.sign(data);
  final isValid = hmac.verify(data, signature);
  print('   Signed "Hello" -> Signature length: ${signature.length}');
  print('   Verification: $isValid\n');

  // ============================================================================
  // ASYMMETRIC CIPHERS
  // ============================================================================
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('3. ASYMMETRIC CIPHERS');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // Create RSA cipher
  print('Creating RSA cipher (2048-bit)...');
  final rsaKeyPair = await RSACipher.generateKeyPair(bitLength: 2048);
  final rsa = CipherFactory.asymmetric(
    AsymmetricCipherAlgorithm.rsa,
    (
      publicKey: rsaKeyPair['publicKey']!,
      privateKey: rsaKeyPair['privateKey']!,
      parent: (
        parent: (
          expirationDate: DateTime.now().add(Duration(days: 365)),
          expirationTimes: null,
        ),
      ),
    ),
  );
  print('✅ RSA cipher created: ${rsa.runtimeType}');
  print('   Key ID: ${rsa.keyId}\n');


  // ============================================================================
  // ASYMMETRIC SIGNATURES
  // ============================================================================
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('4. ASYMMETRIC SIGNATURES');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // Create RSA Signature
  print('Creating RSA Signature...');
  final rsaSigKeyPair = await RSASignatureCipher.generateKeyPair(
    bitLength: 2048,
  );
  final rsaSig = CipherFactory.asymmetricSign(
    AsymmetricSignAlgorithm.rsaSignature,
    (
      publicKey: rsaSigKeyPair['publicKey']!,
      privateKey: rsaSigKeyPair['privateKey']!,
      parent: (
        parent: (
          expirationDate: DateTime.now().add(Duration(days: 365)),
          expirationTimes: null,
        ),
      ),
    ),
  );
  print('✅ RSA Signature created: ${rsaSig.runtimeType}');

  // Test RSA Signature
  final rsaSigData = [84, 101, 115, 116]; // "Test"
  final rsaSigSignature = rsaSig.sign(rsaSigData);
  final rsaSigValid = rsaSig.verify(rsaSigData, rsaSigSignature);
  print('   Signed "Test" -> Signature length: ${rsaSigSignature.length}');
  print('   Verification: $rsaSigValid\n');

  // Create ECDSA Signature
  print('Creating ECDSA Signature...');
  final ecdsaSigKeyPair = await ECDSASign.generateKeyPair();
  final ecdsaSig = CipherFactory.asymmetricSign(
    AsymmetricSignAlgorithm.ecdsa,
    (
      publicKey: ecdsaSigKeyPair['publicKey']!,
      privateKey: ecdsaSigKeyPair['privateKey']!,
      parent: (
        parent: (
          expirationDate: DateTime.now().add(Duration(days: 30)),
          expirationTimes: null,
        ),
      ),
    ),
  );
  print('✅ ECDSA Signature created: ${ecdsaSig.runtimeType}\n');

  // ============================================================================
  // KEY EXCHANGE
  // ============================================================================
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('5. KEY EXCHANGE (ECDH)');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // Create ECDH Key Exchange
  print('Creating ECDH Key Exchange...');
  final ecdhKeyPair = await ECDHKeyExchange.generateKeyPair();
  final ecdh = ECDHKeyExchange.createFull((
    parent: (
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(hours: 1)),
      expirationTimes: null,
    ),
    publicKey: ecdhKeyPair['publicKey']!,
    privateKey: ecdhKeyPair['privateKey']!,
    curve: '', // Default curve will be used if empty
  ));
  print('✅ ECDH Key Exchange created: ${ecdh.runtimeType}\n');

  // ============================================================================
  // SUMMARY
  // ============================================================================
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('✅ FACTORY SUMMARY');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('''
✅ Symmetric Ciphers: AES, DES, ChaCha20
✅ Symmetric Signatures: HMAC
✅ Asymmetric Ciphers: RSA (ECDSA is signature-only)
✅ Asymmetric Signatures: RSA Signature, ECDSA Signature
✅ Key Exchange: ECDH

All instances created successfully through CipherFactory!
''');
}
