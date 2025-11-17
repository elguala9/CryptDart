// HMAC: Hash-based Message Authentication Code (firma simmetrica)
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../../types/crypto_algorithm.dart';
import '../partial/symmetric_sign_impl.dart';
import '../partial/sign_impl.dart';
import '../../utils/crypto_utils.dart';

typedef InputHMACSign = ({
  InputSymmetricSign parent,
});

class HMACSign extends SymmetricSign {
    HMACSign(InputHMACSign input)
      : super(input.parent);


  @override
  List<int> sign(List<int> data) {
    final keyBytes = KeyEncodingUtils.stringKeyToBytes(key);
    final hmac = HMac(SHA256Digest(), 64);
    hmac.init(KeyParameter(keyBytes));
    return hmac.process(Uint8List.fromList(data));
  }

  @override
  bool verify(List<int> data) {
    throw UnimplementedError('Use verifyHMAC(data, signature) instead');
  }

  /// Verifica la firma HMAC
  bool verifyHMAC(List<int> data, List<int> signature) {
    final expected = sign(data);
    if (expected.length != signature.length) return false;
    for (int i = 0; i < expected.length; i++) {
      if (expected[i] != signature[i]) return false;
    }
    return true;
  }

  /// Genera una chiave HMAC casuale (256 bit)
  static String generateKey() {
    return SymmetricKeyUtils.generateKey(bitLength: 256);
  }
}
