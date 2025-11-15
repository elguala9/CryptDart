// HMAC: Hash-based Message Authentication Code (firma simmetrica)
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../../types/crypto_algorithm.dart';
import '../partial/symmetric_sign_impl.dart';

typedef InputHMACSign = ({
  String key,
  DateTime? expirationDate,
});

class HMACSign extends SymmetricSign {
  HMACSign(InputHMACSign input)
      : super((
          algorithm: CryptoAlgorithm.HMAC,
          expirationDate: input.expirationDate,
          key: input.key,
        ));

  @override
  List<int> sign(List<int> data) {
    final keyBytes = Uint8List.fromList(key.codeUnits);
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
    final rnd = SecureRandom('AES/CTR/AUTO-SEED-PRNG');
    rnd.seed(KeyParameter(Uint8List.fromList(List.generate(32, (_) => DateTime.now().microsecond % 256))));
    final key = rnd.nextBytes(32); // 256 bit
    return key.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
