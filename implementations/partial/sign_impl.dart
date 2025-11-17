import '../../interfaces/i_sign.dart';
import 'expiration_base.dart';
import '../../types/crypto_algorithm.dart';

typedef InputSign = ({
  InputExpirationBase parent
});

abstract class Sign extends ExpirationBase implements ISign {
  Sign(InputSign input) : super(input.parent);
}
