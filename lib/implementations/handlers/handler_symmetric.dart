import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_handler.dart';
import 'package:cryptdart/interfaces/i_simmetric.dart';
import 'package:cryptdart/implementations/handlers/handler.dart';

@includeInBarrelFile
mixin HandlerSymmetric<T extends ISymmetric> on Handler<T>
    implements IHandlerSymmetric<T> {
  @override
  void deleteCrypt(String key) {
    crypts.removeWhere((c) => c.key == key);
    expiredCrypts.removeWhere((c) => c.key == key);
  }

  @override
  String get key => currentCrypt.key;
}
