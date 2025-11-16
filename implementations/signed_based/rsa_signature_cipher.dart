// RSA Signature: algoritmo di firma digitale basato su RSA
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../../types/crypto_algorithm.dart';
import '../partial/asymmetric_sign_impl.dart';
import '../../utils/crypto_utils.dart';

typedef InputRSASignatureCipher = ({
  String publicKey,
  String? privateKey,
  DateTime? expirationDate,
});

class RSASignatureCipher extends AsymmetricSign {
  late final RSAPublicKey _pubKey;
  late final RSAPrivateKey? _privKey;

  RSASignatureCipher(InputRSASignatureCipher input)
      : super((
          algorithm: CryptoAlgorithm.RSA_SIGNATURE,
          expirationDate: input.expirationDate,
          publicKey: input.publicKey,
          privateKey: input.privateKey,
        )) {
    final keys = RSAKeyUtils.parseKeyPair(
      publicKey: input.publicKey,
      privateKey: input.privateKey,
    );
    _pubKey = keys.publicKey;
    _privKey = keys.privateKey;
  }


  /// Generates an RSA key pair (PEM format) for signature
  static Future<Map<String, String>> generateKeyPair({int bitLength = 2048}) async {
    return RSAKeyUtils.generateKeyPair(bitLength: bitLength);
  }

  @override
  List<int> sign(List<int> data) {
    if (_privKey == null) {
      throw StateError('Private key is required for signing');
    }
    // In RSA signature, "sign" represents signing the data with private key
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(_privKey!));
    final signature = signer.generateSignature(Uint8List.fromList(data));
    return signature.bytes;
  }

  @override
  bool verify(List<int> data) {
    // For signature verification, you need both data and signature
    // This method should accept signature as parameter
    throw UnimplementedError('Use verifySignature(data, signature) instead');
  }

  /// Verify a signature against the original data
  bool verifySignature(List<int> data, List<int> signature) {
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(false, PublicKeyParameter<RSAPublicKey>(_pubKey));
    final rsaSignature = RSASignature(Uint8List.fromList(signature));
    return signer.verifySignature(Uint8List.fromList(data), rsaSignature);
  }
}
