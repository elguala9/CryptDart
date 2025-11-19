// DES/TripleDES: symmetric algorithm not based on prime numbers
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:cryptdart/implementations/partial/symmetric_cipher_impl.dart';
import 'package:cryptdart/utils/crypto_utils.dart';

/// Input parameters for [DESCipher] constructor.
typedef InputDESCipher = ({
  InputSymmetricCipher parent,
});

/// TripleDES symmetric cipher implementation.
/// Extends [SymmetricCipher] and provides TripleDES encryption/decryption.
class DESCipher extends SymmetricCipher {
  /// Constructs a [DESCipher] with the given input parameters.
  DESCipher(InputDESCipher input)
      : super(input.parent);

  /// Generates a random 192-bit TripleDES key as a hex string.
  static String generateKey() {
    return SymmetricKeyUtils.generateKey(bitLength: 192);
  }

  /// Encrypts data using TripleDES.
  @override
  List<int> encrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.stringKeyToBytes(key);
    final cipher = DESedeEngine();
    cipher.init(true, KeyParameter(keyBytes));
    return cipher.process(Uint8List.fromList(data));
  }

  /// Decrypts data using TripleDES.
  @override
  List<int> decrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.stringKeyToBytes(key);
    final cipher = DESedeEngine();
    cipher.init(false, KeyParameter(keyBytes));
    return cipher.process(Uint8List.fromList(data));
  }
}