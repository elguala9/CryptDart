// RSA: algoritmo asimmetrico basato su numeri primi
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:basic_utils/basic_utils.dart';
import '../../../types/crypto_algorithm.dart';
import '../../partial/asymmetric_encryption_impl.dart';

class RSACipher extends AsymmetricCipher {
  late final RSAPublicKey _pubKey;
  late final RSAPrivateKey _privKey;

  RSACipher({
    required String publicKey,
    required String privateKey,
    DateTime? expirationDate,
  }) : super(
          algorithm: CryptoAlgorithm.RSA,
          expirationDate: expirationDate,
          publicKey: publicKey,
          privateKey: privateKey,
        ) {
    _pubKey = CryptoUtils.rsaPublicKeyFromPem(publicKey);
    _privKey = CryptoUtils.rsaPrivateKeyFromPem(privateKey);
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