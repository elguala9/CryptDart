/// Example demonstrating createFull factory method pattern for all cryptography classes.
///
/// createFull() accepts the complete input structure, allowing full customization
/// of all nested parameters for each cipher/signature/key-exchange type.

import 'dart:typed_data';
import 'package:cryptdart/cryptdart.dart';

void main() async {
  print('🔧 CryptDart Factory Methods Examples\n');

  // ============== SYMMETRIC CIPHERS ==============
  print('📦 SYMMETRIC CIPHERS');
  print('─' * 50);

  // AES with createFull
  {
    // ignore: unused_local_variable
    final _ = AESCipher.createFull(InputAESCipher(
      parent: InputSymmetricCipher(
        key: AESCipher.generateKey(),
        parent: InputCipher(
          parent: InputExpirationBase(
            expirationDate: DateTime.now().add(Duration(days: 7)),
            expirationTimes: null,
          ),
        ),
      ),
    ));
    print('✅ AES with createFull created');
  }

  // ChaCha20 with createFull
  {
    // ignore: unused_local_variable
    final _ = ChaCha20Cipher.createFull(InputChaCha20Cipher(
      nonce: Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]),
      parent: InputSymmetricCipher(
        key: ChaCha20Cipher.generateKey(),
        parent: InputCipher(
          parent: InputExpirationBase(
            expirationDate: DateTime.now().add(Duration(hours: 12)),
            expirationTimes: null,
          ),
        ),
      ),
    ));
    print('✅ ChaCha20 with createFull created');
  }

  // DES with createFull
  {
    // ignore: unused_local_variable
    final _ = DESCipher.createFull(InputDESCipher(
      parent: InputSymmetricCipher(
        key: DESCipher.generateKey(),
        parent: InputCipher(
          parent: InputExpirationBase(
            expirationDate: DateTime.now().add(Duration(hours: 1)),
            expirationTimes: null,
          ),
        ),
      ),
    ));
    print('✅ DES with createFull created');
  }

  print('');

  // ============== ASYMMETRIC CIPHERS ==============
  print('🔑 ASYMMETRIC CIPHERS');
  print('─' * 50);

  // RSA with createFull
  {
    final rsaKeyPair = await RSACipher.generateKeyPair(bitLength: 2048);
    // ignore: unused_local_variable
    final _ = RSACipher.createFull(InputRSACipher(
      parent: InputAsymmetricCipher(
        publicKey: rsaKeyPair['publicKey']!,
        privateKey: rsaKeyPair['privateKey']!,
        parent: InputCipher(
          parent: InputExpirationBase(
            expirationDate: DateTime.now().add(Duration(days: 30)),
            expirationTimes: null,
          ),
        ),
      ),
    ));
    print('✅ RSA (2048-bit) with createFull created');
  }

  print('');

  // ============== DIGITAL SIGNATURES ==============
  print('✍️  DIGITAL SIGNATURES');
  print('─' * 50);

  // HMAC with createFull
  {
    // ignore: unused_local_variable
    final _ = HMACSign.createFull(InputHMACSign(
      parent: InputSymmetricSign(
        key: HMACSign.generateKey(),
        parent: InputSign(
          parent: InputExpirationBase(
            expirationDate: DateTime.now().add(Duration(hours: 6)),
            expirationTimes: null,
          ),
        ),
      ),
    ));
    print('✅ HMAC with createFull created');
  }

  // RSA Signature with createFull
  {
    final rsaSigKeyPair = await RSASignatureCipher.generateKeyPair();
    // ignore: unused_local_variable
    final _ = RSASignatureCipher.createFull(InputRSASignatureCipher(
      parent: InputAsymmetricSign(
        publicKey: rsaSigKeyPair['publicKey']!,
        privateKey: rsaSigKeyPair['privateKey']!,
        parent: InputSign(
          parent: InputExpirationBase(
            expirationDate: DateTime.now().add(Duration(days: 365)),
            expirationTimes: null,
          ),
        ),
      ),
    ));
    print('✅ RSA Signature with createFull created');
  }

  // ECDSA with createFull
  {
    final ecdsaKeyPair = await ECDSASign.generateKeyPair();
    // ignore: unused_local_variable
    final _ = ECDSASign.createFull(InputECDSASign(
      parent: InputAsymmetricSign(
        publicKey: ecdsaKeyPair['publicKey']!,
        privateKey: ecdsaKeyPair['privateKey']!,
        parent: InputSign(
          parent: InputExpirationBase(
            expirationDate: DateTime.now().add(Duration(days: 90)),
            expirationTimes: null,
          ),
        ),
      ),
    ));
    print('✅ ECDSA with createFull created');
  }

  print('');

  // ============== KEY EXCHANGE ==============
  print('🔄 KEY EXCHANGE');
  print('─' * 50);

  // ECDH with createFull
  {
    final ecdhKeyPair = await ECDHKeyExchange.generateKeyPair();
    // ignore: unused_local_variable
    final _ = ECDHKeyExchange.createFull(InputECDHKeyExchange(
      parent: InputKeyExchangeBase(
        algorithm: KeyExchangeAlgorithm.ecdh,
        expirationDate: DateTime.now().add(Duration(minutes: 30)),
        expirationTimes: null,
      ),
      publicKey: ecdhKeyPair['publicKey']!,
      privateKey: ecdhKeyPair['privateKey']!,
      curve: ECCKeyUtils.secp256r1,
    ));
    print('✅ ECDH with createFull created');
  }

  print('');

  // ============== PRACTICAL EXAMPLE ==============
  print('🔐 PRACTICAL EXAMPLE: Encrypt & Decrypt');
  print('─' * 50);

  // Create cipher with expiration using createFull
  final cipher = AESCipher.createFull(InputAESCipher(
    parent: InputSymmetricCipher(
      key: AESCipher.generateKey(),
      parent: InputCipher(
        parent: InputExpirationBase(
          expirationDate: DateTime.now().add(Duration(hours: 24)),
          expirationTimes: null,
        ),
      ),
    ),
  ));

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
  print('✨ All factory methods (createFull) working correctly!');
}
