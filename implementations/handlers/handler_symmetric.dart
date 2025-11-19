import '../../interfaces/i_handler.dart';
import '../../interfaces/i_simmetric.dart';
import 'handler.dart';

mixin HandlerSymmetric<T extends ISymmetric> on Handler<T> implements IHandlerSymmetric<T> {
  @override
  void deleteCrypt(String key) {
    crypts.removeWhere((c) => c.key == key);
    expiredCrypts.removeWhere((c) => c.key == key);
  }

  @override
  String get key => currentCrypt.key;
}

