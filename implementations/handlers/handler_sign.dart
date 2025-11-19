import '../../interfaces/i_sign.dart';
import '../../interfaces/i_handler.dart';
import '../../interfaces/i_simmetric.dart';
import '../../interfaces/i_asimmetric.dart';
import 'handler.dart';
import 'handler_symmetric.dart';
import 'handler_asymmetric.dart';

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
