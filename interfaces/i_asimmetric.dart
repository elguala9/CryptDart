import 'i_cipher.dart';
import 'i_expiration.dart';
import 'i_sign.dart';

abstract interface class IAsymmetric extends IExpiration{
  String get publicKey;
  String? get privateKey;
  static KeyPair generateKeyPair() {
    throw UnimplementedError('generateKeyPair needs to be implemented');
  }
}

abstract interface class IAsymmetricCipher extends IAsymmetric implements ICipher{
  // publicKey, privateKey, generateKeyPair già definiti in IAsymmetric
}

abstract interface class IAsymmetricSign extends IAsymmetric implements ISign{
  // publicKey, privateKey, generateKeyPair già definiti in IAsymmetric
}

typedef KeyPair = ({
  String publicKey,
  String privateKey,
});