// RSA: algoritmo asimmetrico basato su numeri primi
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

import '../../../utils/crypto_utils.dart';
import '../../partial/asymmetric_cipher_impl.dart';

typedef InputRSACipher = ({
  InputAsymmetricCipher parent,
});

class RSACipher extends AsymmetricCipher {
  late final RSAPublicKey _pubKey;
  late final RSAPrivateKey? _privKey;

    RSACipher(InputRSACipher input)
        : super(input.parent) {
      final keys = RSAKeyUtils.parseKeyPair(
        publicKey: input.parent.publicKey,
        privateKey: input.parent.privateKey,
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