// ignore_for_file: library_private_types_in_public_api
import 'package:barrel_files_annotation/barrel_files_annotation.dart';

// Interfaces
import 'package:cryptdart/interfaces/i_simmetric.dart';
import 'package:cryptdart/interfaces/i_asimmetric.dart';
import 'package:cryptdart/interfaces/key_exchange/i_key_exchange.dart';

// Types
import 'package:cryptdart/types/crypto_algorithm.dart';

// Implementations - Symmetric Ciphers
import 'package:cryptdart/implementations/symmetric/aes_cipher.dart';
import 'package:cryptdart/implementations/symmetric/des_cipher.dart';
import 'package:cryptdart/implementations/symmetric/chacha20_cipher.dart';

// Implementations - Asymmetric Ciphers
import 'package:cryptdart/implementations/asymmetric/prime_based/rsa_cipher.dart';

// Implementations - Signatures
import 'package:cryptdart/implementations/signed_based/hmac_sign.dart';
import 'package:cryptdart/implementations/signed_based/rsa_signature_cipher.dart';
import 'package:cryptdart/implementations/signed_based/ecdsa_sign.dart';

// Implementations - Key Exchange
import 'package:cryptdart/implementations/key_exchange/ecdh_key_exchange.dart';

// Input types
import 'package:cryptdart/implementations/partial/symmetric_cipher_impl.dart';
import 'package:cryptdart/implementations/partial/asymmetric_cipher_impl.dart';
import 'package:cryptdart/implementations/partial/symmetric_sign_impl.dart';
import 'package:cryptdart/implementations/partial/asymmetric_sign_impl.dart';

/// Central factory for creating cipher, signature, and key exchange instances.
///
/// This factory provides a centralized way to instantiate cryptographic objects
/// based on algorithm enums. It eliminates the need to remember specific class names
/// and provides a consistent API across all cipher types.
///
/// ## Usage
///
/// ```dart
/// // Create symmetric cipher
/// final aes = CipherFactory.symmetric(
///   SymmetricCipherAlgorithmEnum.aes,
///   InputSymmetricCipher(
///     parent: (...),
///     key: AESCipher.generateKey(),
///   ),
/// );
///
/// // Create asymmetric cipher
/// final rsa = CipherFactory.asymmetric(
///   AsymmetricCipherAlgorithmEnum.rsa,
///   InputAsymmetricCipher(
///     parent: (...),
///     publicKey: '...',
///     privateKey: '...',
///   ),
/// );
///
/// // Create signature
/// final hmac = CipherFactory.symmetricSign(
///   SymmetricSignAlgorithmEnum.hmac,
///   InputSymmetricSign(
///     parent: (...),
///     key: HMACSign.generateKey(),
///   ),
/// );
/// ```
@includeInBarrelFile
class CipherFactory {
  /// Creates a symmetric cipher based on the given algorithm.
  ///
  /// [algorithm]: The symmetric cipher algorithm (AES, DES)
  /// [input]: The complete input record with configuration
  ///
  /// Returns: An instance of the specified symmetric cipher
  ///
  /// Throws: [ArgumentError] if algorithm is not supported
  ///
  /// Note: For ChaCha20, use the [chacha20] factory method instead.
  static ISymmetricCipher symmetric(
    CryptoAlgorithm algorithm,
    InputSymmetricCipher input,
  ) {
    return switch (algorithm) {
      CryptoAlgorithm.aes => AESCipher.createFull(InputAESCipher(parent: input)),
      CryptoAlgorithm.des => DESCipher.createFull(InputDESCipher(parent: input)),
      CryptoAlgorithm.chacha20 => throw ArgumentError(
        'Use chacha20() factory method for ChaCha20 cipher',
      ),
      _ => throw ArgumentError('Not a symmetric cipher algorithm: $algorithm'),
    };
  }

  /// Creates a ChaCha20 cipher with a nonce.
  ///
  /// [input]: The complete [InputChaCha20Cipher] record with configuration
  ///
  /// Returns: A [ChaCha20Cipher] instance
  static ISymmetricCipher chacha20(InputChaCha20Cipher input) {
    return ChaCha20Cipher.createFull(input);
  }

  /// Creates an asymmetric cipher based on the given algorithm.
  ///
  /// [algorithm]: The asymmetric cipher algorithm (RSA, ECDSA)
  /// [input]: The complete input record with configuration
  ///
  /// Returns: An instance of the specified asymmetric cipher
  ///
  /// Throws: [ArgumentError] if algorithm is not supported
  ///
  /// Note: ECDSA is supported only as signature, not as cipher.
  static IAsymmetricCipher asymmetric(
    CryptoAlgorithm algorithm,
    InputAsymmetricCipher input,
  ) {
    return switch (algorithm) {
      CryptoAlgorithm.rsa => RSACipher.createFull(InputRSACipher(parent: input)),
      CryptoAlgorithm.ecdsa => throw ArgumentError(
        'ECDSA is not supported as a cipher. Use asymmetricSign() for signature operations.',
      ),
      _ => throw ArgumentError('Not an asymmetric cipher algorithm: $algorithm'),
    };
  }

  /// Creates a symmetric signature instance based on the given algorithm.
  ///
  /// [algorithm]: The symmetric signature algorithm (HMAC)
  /// [input]: The complete input record with configuration
  ///
  /// Returns: An instance of the specified signature handler
  ///
  /// Throws: [ArgumentError] if algorithm is not supported
  static ISymmetricSign symmetricSign(
    CryptoAlgorithm algorithm,
    InputSymmetricSign input,
  ) {
    return switch (algorithm) {
      CryptoAlgorithm.hmac => HMACSign.createFull(InputHMACSign(parent: input)),
      _ => throw ArgumentError('Not a symmetric signature algorithm: $algorithm'),
    };
  }

  /// Creates an asymmetric signature instance based on the given algorithm.
  ///
  /// [algorithm]: The asymmetric signature algorithm (RSA Signature, ECDSA)
  /// [input]: The complete input record with configuration
  ///
  /// Returns: An instance of the specified signature handler
  ///
  /// Throws: [ArgumentError] if algorithm is not supported
  static IAsymmetricSign asymmetricSign(
    CryptoAlgorithm algorithm,
    InputAsymmetricSign input,
  ) {
    return switch (algorithm) {
      CryptoAlgorithm.rsaSignature =>
        RSASignatureCipher.createFull(InputRSASignatureCipher(parent: input)),
      CryptoAlgorithm.ecdsaSign =>
        ECDSASign.createFull(InputECDSASign(parent: input)),
      _ => throw ArgumentError('Not an asymmetric signature algorithm: $algorithm'),
    };
  }

  /// Creates an ECDH key exchange instance.
  ///
  /// [input]: The complete [InputECDHKeyExchange] record with configuration
  ///
  /// Returns: An [ECDHKeyExchange] instance
  static IKeyExchange ecdh(dynamic input) {
    return ECDHKeyExchange.createFull(input as dynamic);
  }

  /// Creates a cipher/signature instance from a generic algorithm type.
  ///
  /// This is a convenience method that dispatches to the appropriate
  /// factory method based on the algorithm enum value.
  ///
  /// Note: For asymmetric operations, ensure you pass the correct Input type
  /// that matches your algorithm.
  static dynamic fromAlgorithm(
    CryptoAlgorithm algorithm,
    dynamic input,
  ) {
    if (SymmetricCipherAlgorithmEnum.values.contains(algorithm)) {
      return symmetric(algorithm, input as InputSymmetricCipher);
    } else if (AsymmetricCipherAlgorithmEnum.values.contains(algorithm)) {
      return asymmetric(algorithm, input as InputAsymmetricCipher);
    } else if (SymmetricSignAlgorithmEnum.values.contains(algorithm)) {
      return symmetricSign(algorithm, input as InputSymmetricSign);
    } else if (AsymmetricSignAlgorithmEnum.values.contains(algorithm)) {
      return asymmetricSign(algorithm, input as InputAsymmetricSign);
    } else {
      throw ArgumentError('Unsupported algorithm type: $algorithm');
    }
  }
}
