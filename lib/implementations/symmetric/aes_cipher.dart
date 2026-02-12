// AES: symmetric algorithm not based on prime numbers
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/implementations/partial/symmetric_cipher_impl.dart';
import 'package:cryptdart/types/crypto_algorithm.dart';
import 'package:cryptdart/utils/crypto_utils.dart';

/// Input parameters for [AESCipher] constructor.
typedef InputAESCipher = ({
  InputSymmetricCipher parent,
});

/// AES symmetric cipher implementation.
/// Extends [SymmetricCipher] and provides AES encryption/decryption.
@includeInBarrelFile
class AESCipher extends SymmetricCipher {
  /// Constructs an [AESCipher] with the given input parameters.
  AESCipher(InputAESCipher input) : super(input.parent);

  /// Generates a random 256-bit AES key as a hex string.
  static String generateKey() {
    return SymmetricKeyUtils.generateKey(bitLength: 256);
  }

  /// Creates an [AESCipher] with full control over all parameters.
  ///
  /// Accepts the complete [InputAESCipher] record, allowing complete customization
  /// of all nested parameters. This factory automatically adapts to any changes
  /// in the input structure without requiring modifications.
  static AESCipher createFull(InputAESCipher input) => AESCipher(input);

  /// Encrypts data using AES with PKCS7 padding.
  @override
  List<int> encrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.hexToBytes(key);
    final cipher = PaddedBlockCipherImpl(PKCS7Padding(), AESEngine());
    cipher.init(true, PaddedBlockCipherParameters(KeyParameter(keyBytes), null));
    return cipher.process(Uint8List.fromList(data));
  }

  /// Decrypts data using AES with PKCS7 padding.
  @override
  List<int> decrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.hexToBytes(key);
    final cipher = PaddedBlockCipherImpl(PKCS7Padding(), AESEngine());
    cipher.init(false, PaddedBlockCipherParameters(KeyParameter(keyBytes), null));
    return cipher.process(Uint8List.fromList(data));
  }

  @override
  CryptoAlgorithm get algorithm => SymmetricCipherAlgorithm.aes;
}
