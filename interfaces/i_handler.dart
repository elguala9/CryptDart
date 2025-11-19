import 'i_asimmetric.dart';
import 'i_cipher.dart';
import 'i_expiration.dart';
import 'i_sign.dart';
import 'i_simmetric.dart';

// IExpritaion work on the actual (kind of [0])
abstract class IHandler<T extends IExpiration> implements IExpiration {
  void setNextCrypt(T obj);
  List<T> get crypts;
  List<T> get expiredCrypts;
  void deleteCrypt(String key);
  // currentCrypt began the next crypt
  void nextCrypt();
  T get currentCrypt;
}

abstract class IHandlerAsymmetric<T extends IAsymmetric> implements IAsymmetric, IHandler<T> {
  @override
  T get currentCrypt;
}

abstract class IHandlerSymmetric<T extends ISymmetric> implements ISymmetric, IHandler<T> {
  @override
  T get currentCrypt;
}

abstract class IHandlerCipher<T extends ICipher> implements ICipher, IHandler<T> {
  @override
  T get currentCrypt;
}

abstract class IHandlerSign<T extends ISign> implements ISign, IHandler<T> {
  @override
  T get currentCrypt;
}

