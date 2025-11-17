import '../../interfaces/i_simmetric.dart';
import 'cipher_impl.dart';

typedef InputSymmetricCipher = ({
  InputCipher parent,
  String key,
});

abstract class SymmetricCipher extends Cipher implements ISymmetricCipher {
  final String _key;

  SymmetricCipher(InputSymmetricCipher input)
      : _key = input.key,
        super(input.parent);

  @override
  String get key => _key;
}
