// RSA: algoritmo asimmetrico basato su numeri primi
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../../../types/crypto_algorithm.dart';
import '../../partial/asymmetric_cipher_impl.dart';
import '../../../utils/crypto_utils.dart';

typedef InputRSACipher = ({
  String publicKey,
  String? privateKey,
  DateTime? expirationDate,
});

class RSACipher extends AsymmetricCipher {
  late final RSAPublicKey _pubKey;
  late final RSAPrivateKey? _privKey;

  RSACipher(InputRSACipher input)
      : super((
          algorithm: CryptoAlgorithm.RSA,
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


  /// Generates an RSA key pair (PEM format)
  static Future<Map<String, String>> generateKeyPair({int bitLength = 2048}) async {
    return RSAKeyUtils.generateKeyPair(bitLength: bitLength);
  }

  @override
  List<int> encrypt(List<int> data) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(_pubKey));
    return encryptor.process(Uint8List.fromList(data));
  }

  @override
  List<int> decrypt(List<int> data) {
    if (_privKey == null) {
      throw StateError('Private key is required for decryption');
    }
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(_privKey!));
    return decryptor.process(Uint8List.fromList(data));
  }
}