import '../../interfaces/i_asimmetric.dart';
import '../../interfaces/i_cipher.dart';
import '../../interfaces/i_handler.dart';
import '../../interfaces/i_simmetric.dart';
import 'handler.dart';
import 'handler_asymmetric.dart';
import 'handler_symmetric.dart';

mixin HandlerCipher<T extends ICipher> on Handler<T> implements IHandlerCipher<T> {
  @override
  List<int> decrypt(List<int> data) {
    cleanCrypts();
    return currentCrypt.decrypt(data);
  }

  @override
  List<int> encrypt(List<int> data) {
    cleanCrypts();
    return currentCrypt.encrypt(data);
  }
}



class HandlerCipherSymmetric<T extends ISymmetricCipher>
    extends Handler<T>
    with HandlerCipher<T>, HandlerSymmetric<T> {
  HandlerCipherSymmetric(InputHandler<T> input) : super(input);
}



class HandlerCipherAsymmetric<T extends IAsymmetricCipher>
    extends Handler<T>
    with HandlerCipher<T>, HandlerAsymmetric<T> {
  HandlerCipherAsymmetric(InputHandler<T> input) : super(input);
}