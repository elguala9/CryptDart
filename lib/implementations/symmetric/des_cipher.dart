// DES/TripleDES: symmetric algorithm not based on prime numbers
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/implementations/partial/symmetric_cipher_impl.dart';
import 'package:cryptdart/types/crypto_algorithm.dart';
import 'package:cryptdart/utils/crypto_utils.dart';
import 'package:meta/meta.dart';

/// Input parameters for [DESCipher] constructor.
@immutable
class InputDESCipher {
  final InputSymmetricCipher parent;

  const InputDESCipher({
    required this.parent,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputDESCipher &&
          runtimeType == other.runtimeType &&
          parent == other.parent;

  @override
  int get hashCode => parent.hashCode;

  @override
  String toString() => 'InputDESCipher(parent: $parent)';
}

/// TripleDES symmetric cipher implementation.
/// Extends [SymmetricCipher] and provides TripleDES encryption/decryption.
@includeInBarrelFile
class DESCipher extends SymmetricCipher {
  /// Constructs a [DESCipher] with the given input parameters.
  DESCipher(InputDESCipher input) : super(input.parent);

  /// Generates a random 192-bit TripleDES key as a hex string.
  static String generateKey() {
    return SymmetricKeyUtils.generateKey(bitLength: 192);
  }

  /// Creates a [DESCipher] with full control over all parameters.
  ///
  /// Accepts the complete [InputDESCipher] record, allowing complete customization
  /// of all nested parameters. This factory automatically adapts to any changes
  /// in the input structure without requiring modifications.
  static DESCipher createFull(InputDESCipher input) => DESCipher(input);

  /// Encrypts data using TripleDES with PKCS7 padding.
  @override
  List<int> encrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.hexToBytes(key);
    final cipher = PaddedBlockCipherImpl(PKCS7Padding(), DESedeEngine());
    cipher.init(true, PaddedBlockCipherParameters(KeyParameter(keyBytes), null));
    return cipher.process(Uint8List.fromList(data));
  }

  /// Decrypts data using TripleDES with PKCS7 padding.
  @override
  List<int> decrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.hexToBytes(key);
    final cipher = PaddedBlockCipherImpl(PKCS7Padding(), DESedeEngine());
    cipher.init(false, PaddedBlockCipherParameters(KeyParameter(keyBytes), null));
    return cipher.process(Uint8List.fromList(data));
  }

  @override
  CryptoAlgorithm get algorithm => CryptoAlgorithm.des;
}
