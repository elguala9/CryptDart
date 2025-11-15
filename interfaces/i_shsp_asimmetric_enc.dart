import 'i_shsp_enc.dart';

abstract interface class IAsymmetricCipher extends ICipher{
  String get publicKey;
  String get privateKey;
  static KeyPair generateKeyPair() {
    throw UnimplementedError('generateKeyPair needs to be implemented');
  }
}

typedef KeyPair = ({
  String publicKey,
  String privateKey,
});