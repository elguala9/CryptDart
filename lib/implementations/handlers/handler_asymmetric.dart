import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_asimmetric.dart';
import 'package:cryptdart/interfaces/i_handler.dart';
import 'handler.dart';

@includeInBarrelFile
mixin HandlerAsymmetric<T extends IAsymmetric> on Handler<T>
    implements IHandlerAsymmetric<T> {
  @override
  void deleteCrypt(String key) {
    crypts.removeWhere((c) => c.publicKey == key);
    expiredCrypts.removeWhere((c) => c.publicKey == key);
  }

  @override
  String? get privateKey => currentCrypt.privateKey;

  @override
  String get publicKey => currentCrypt.publicKey;
}
