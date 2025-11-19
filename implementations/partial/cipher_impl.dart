import '../../interfaces/i_cipher.dart';
import 'expiration_base.dart';

typedef InputCipher = ({
  InputExpirationBase parent
});

abstract class Cipher extends ExpirationBase implements ICipher {
  Cipher(InputCipher input) : super(input.parent);
}
