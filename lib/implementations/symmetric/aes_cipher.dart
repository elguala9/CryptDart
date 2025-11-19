// AES: symmetric algorithm not based on prime numbers
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:cryptdart/implementations/partial/symmetric_cipher_impl.dart';
import 'package:cryptdart/utils/crypto_utils.dart';

/// Input parameters for [AESCipher] constructor.
typedef InputAESCipher = ({
  InputSymmetricCipher parent,
});

/// AES symmetric cipher implementation.
/// Extends [SymmetricCipher] and provides AES encryption/decryption.
class AESCipher extends SymmetricCipher {
  /// Constructs an [AESCipher] with the given input parameters.
  AESCipher(InputAESCipher input)
      : super(input.parent);

  /// Generates a random 256-bit AES key as a hex string.
  static String generateKey() {
    return SymmetricKeyUtils.generateKey(bitLength: 256);
  }

  /// Encrypts data using AES.
  @override
  List<int> encrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.stringKeyToBytes(key);
    final cipher = AESEngine();
    cipher.init(true, KeyParameter(keyBytes));
    return cipher.process(Uint8List.fromList(data));
  }

  /// Decrypts data using AES.
  @override
  List<int> decrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.stringKeyToBytes(key);
    final cipher = AESEngine();
    cipher.init(false, KeyParameter(keyBytes));
    return cipher.process(Uint8List.fromList(data));
  }
}