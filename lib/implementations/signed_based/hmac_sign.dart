// HMAC: Hash-based Message Authentication Code (symmetric signature)
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
// ...existing code...
import 'package:cryptdart/implementations/partial/symmetric_sign_impl.dart';
// ...existing code...
import 'package:cryptdart/utils/crypto_utils.dart';

/// Input parameters for [HMACSign] constructor.
typedef InputHMACSign = ({
  InputSymmetricSign parent,
});

/// HMAC (Hash-based Message Authentication Code) signature implementation.
/// Extends [SymmetricSign] and provides HMAC signing and verification.
class HMACSign extends SymmetricSign {
  /// Constructs an [HMACSign] with the given input parameters.
  HMACSign(InputHMACSign input)
      : super(input.parent);

  /// Signs data using HMAC-SHA256.
  @override
  List<int> sign(List<int> data) {
    final keyBytes = KeyEncodingUtils.stringKeyToBytes(key);
    final hmac = HMac(SHA256Digest(), 64);
    hmac.init(KeyParameter(keyBytes));
    return hmac.process(Uint8List.fromList(data));
  }

  /// Throws UnimplementedError. Use [verifyHMAC] instead.
  @override
  bool verify(List<int> data) {
    throw UnimplementedError('Use verifyHMAC(data, signature) instead');
  }

  /// Verifies HMAC signature against the original data.
  bool verifyHMAC(List<int> data, List<int> signature) {
    final expected = sign(data);
    if (expected.length != signature.length) return false;
    for (int i = 0; i < expected.length; i++) {
      if (expected[i] != signature[i]) return false;
    }
    return true;
  }

  /// Generates a random 256-bit HMAC key as a hex string.
  static String generateKey() {
    return SymmetricKeyUtils.generateKey(bitLength: 256);
  }
}
