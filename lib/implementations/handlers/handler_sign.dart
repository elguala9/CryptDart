import 'package:cryptdart/interfaces/i_sign.dart';
import 'package:cryptdart/interfaces/i_handler.dart';
import 'package:cryptdart/interfaces/i_simmetric.dart';
import 'package:cryptdart/interfaces/i_asimmetric.dart';
import 'package:cryptdart/implementations/handlers/handler.dart';
import 'package:cryptdart/implementations/handlers/handler_symmetric.dart';
import 'package:cryptdart/implementations/handlers/handler_asymmetric.dart';

mixin HandlerSign<T extends ISign> on Handler<T> implements IHandlerSign<T> {
  @override
  List<int> sign(List<int> data) {
    cleanCrypts();
    return currentCrypt.sign(data);
  }

  @override
  bool verify(List<int> data) {
    cleanCrypts();
    return currentCrypt.verify(data);
  }
}

class HandlerSignSymmetric<T extends ISymmetricSign>
    extends Handler<T>
    with HandlerSign<T>, HandlerSymmetric<T> {
  HandlerSignSymmetric(InputHandler<T> input) : super(input);
}

class HandlerSignAsymmetric<T extends IAsymmetricSign>
    extends Handler<T>
    with HandlerSign<T>, HandlerAsymmetric<T> {
  HandlerSignAsymmetric(InputHandler<T> input) : super(input);
}
