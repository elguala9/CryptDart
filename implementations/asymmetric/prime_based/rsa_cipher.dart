// RSA: algoritmo asimmetrico basato su numeri primi
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:basic_utils/basic_utils.dart';
import '../../../types/crypto_algorithm.dart';
import '../../partial/asymmetric_cipher_impl.dart';

typedef InputRSACipher = ({
  String publicKey,
  String privateKey,
  DateTime? expirationDate,
});

class RSACipher extends AsymmetricCipher {
  late final RSAPublicKey _pubKey;
  late final RSAPrivateKey _privKey;

  RSACipher(InputRSACipher input)
      : super((
          algorithm: CryptoAlgorithm.RSA,
          expirationDate: input.expirationDate,
          publicKey: input.publicKey,
          privateKey: input.privateKey,
        )) {
    _pubKey = CryptoUtils.rsaPublicKeyFromPem(input.publicKey);
    _privKey = CryptoUtils.rsaPrivateKeyFromPem(input.privateKey);
  }

  /// Generates an RSA key pair (PEM format)
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
  List<int> encrypt(List<int> data) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(_pubKey));
    return encryptor.process(Uint8List.fromList(data));
  }

  @override
  List<int> decrypt(List<int> data) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(_privKey));
    return decryptor.process(Uint8List.fromList(data));
  }
}