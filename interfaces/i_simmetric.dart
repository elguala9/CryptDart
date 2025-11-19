
import 'i_cipher.dart';
import 'i_expiration.dart';
import 'i_sign.dart';

abstract interface class ISymmetric extends IExpiration{
  String get key;
  static String generateKey() {
    throw UnimplementedError('generateKey needs to be implemented');
  }
}

abstract interface class ISymmetricCipher extends ICipher implements ISymmetric{
}

abstract interface class ISymmetricSign extends ISymmetric implements ISign{
}