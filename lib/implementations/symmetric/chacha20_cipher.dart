// ChaCha20: symmetric algorithm not based on prime numbers
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:cryptdart/implementations/partial/symmetric_cipher_impl.dart';
import 'package:cryptdart/utils/crypto_utils.dart';

/// Input parameters for [ChaCha20Cipher] constructor.
typedef InputChaCha20Cipher = ({
  InputSymmetricCipher parent,
  Uint8List nonce,
});

/// ChaCha20 symmetric cipher implementation.
/// Extends [SymmetricCipher] and provides ChaCha20 encryption/decryption.
class ChaCha20Cipher extends SymmetricCipher {
  /// Nonce used for ChaCha20 encryption/decryption.
  final Uint8List nonce;

  /// Constructs a [ChaCha20Cipher] with the given input parameters.
  ChaCha20Cipher(InputChaCha20Cipher input)
      : nonce = input.nonce,
        super(input.parent);

  /// Generates a random 256-bit ChaCha20 key as a hex string.
  static String generateKey() {
    return SymmetricKeyUtils.generateKey(bitLength: 256);
  }

  /// Encrypts data using ChaCha20.
  @override
  List<int> encrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.stringKeyToBytes(key);
    final params = ParametersWithIV(KeyParameter(keyBytes), nonce);
    final cipher = ChaCha20Engine();
    cipher.init(true, params);
    return cipher.process(Uint8List.fromList(data));
  }

  /// Decrypts data using ChaCha20.
  @override
  List<int> decrypt(List<int> data) {
    final keyBytes = KeyEncodingUtils.stringKeyToBytes(key);
    final params = ParametersWithIV(KeyParameter(keyBytes), nonce);
    final cipher = ChaCha20Engine();
    cipher.init(false, params);
    return cipher.process(Uint8List.fromList(data));
  }
}