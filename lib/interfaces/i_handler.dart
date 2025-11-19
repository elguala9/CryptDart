import 'i_asimmetric.dart';
import 'i_cipher.dart';
import 'i_expiration.dart';
import 'i_sign.dart';
import 'i_simmetric.dart';

/// Generic handler interface for cryptographic objects.
/// Manages a chain of crypts and expiration logic.
abstract class IHandler<T extends IExpiration> implements IExpiration {
  /// Sets the next crypt object in the chain.
  void setNextCrypt(T obj);

  /// List of active crypt objects.
  List<T> get crypts;

  /// List of expired crypt objects.
  List<T> get expiredCrypts;

  /// Deletes a crypt object by key.
  void deleteCrypt(String key);

  /// Advances to the next crypt object.
  void nextCrypt();

  /// The current active crypt object.
  T get currentCrypt;
}

/// Handler for asymmetric cryptographic objects.
abstract class IHandlerAsymmetric<T extends IAsymmetric> implements IAsymmetric, IHandler<T> {
  @override
  T get currentCrypt;
}

/// Handler for symmetric cryptographic objects.
abstract class IHandlerSymmetric<T extends ISymmetric> implements ISymmetric, IHandler<T> {
  @override
  T get currentCrypt;
}

/// Handler for cipher objects.
abstract class IHandlerCipher<T extends ICipher> implements ICipher, IHandler<T> {
  @override
  T get currentCrypt;
}

/// Handler for signature objects.
abstract class IHandlerSign<T extends ISign> implements ISign, IHandler<T> {
  @override
  T get currentCrypt;
}

