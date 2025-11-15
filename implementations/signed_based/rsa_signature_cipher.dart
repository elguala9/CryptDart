// RSA Signature: algoritmo di firma digitale basato su RSA
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:basic_utils/basic_utils.dart';
import '../../types/crypto_algorithm.dart';
import '../partial/asymmetric_sign_impl.dart';

typedef InputRSASignatureCipher = ({
  String publicKey,
  String privateKey,
  DateTime? expirationDate,
});

class RSASignatureCipher extends AsymmetricSign {
  late final RSAPublicKey _pubKey;
  late final RSAPrivateKey _privKey;

  RSASignatureCipher(InputRSASignatureCipher input)
      : super((
          algorithm: CryptoAlgorithm.RSA_SIGNATURE,
          expirationDate: input.expirationDate,
          publicKey: input.publicKey,
          privateKey: input.privateKey,
        )) {
    _pubKey = CryptoUtils.rsaPublicKeyFromPem(input.publicKey);
    _privKey = CryptoUtils.rsaPrivateKeyFromPem(input.privateKey);
  }

  /// Generates an RSA key pair (PEM format) for signature
  static Future<Map<String, String>> generateKeyPair({int bitLength = 2048}) async {
    final keyParams = RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64);
    final secureRandom = SecureRandom('AES/CTR/AUTO-SEED-PRNG');
    secureRandom.seed(KeyParameter(Uint8List.fromList(List.generate(32, (_) => DateTime.now().microsecond % 256))));
    final rngParams = ParametersWithRandom(keyParams, secureRandom);
    final generator = RSAKeyGenerator();
    generator.init(rngParams);
    final pair = generator.generateKeyPair();
    final pub = pair.publicKey as RSAPublicKey;
    final priv = pair.privateKey as RSAPrivateKey;
    final pubPem = CryptoUtils.encodeRSAPublicKeyToPem(pub);
    final privPem = CryptoUtils.encodeRSAPrivateKeyToPem(priv);
    return {'publicKey': pubPem, 'privateKey': privPem};
  }

  @override
  List<int> sign(List<int> data) {
    // In RSA signature, "sign" represents signing the data with private key
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(_privKey));
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
