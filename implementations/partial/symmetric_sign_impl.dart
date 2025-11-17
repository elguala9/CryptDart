import '../../interfaces/i_simmetric.dart';
import 'sign_impl.dart';

typedef InputSymmetricSign = ({
  InputSign parent,
  String key,
});

abstract class SymmetricSign extends Sign implements ISymmetricSign {
  final String _key;

  SymmetricSign(InputSymmetricSign input)
      : _key = input.key,
        super(input.parent);

  @override
  String get key => _key;
}
