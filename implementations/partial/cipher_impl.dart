import '../../interfaces/i_cipher.dart';
import 'expiration_base.dart';
import '../../types/crypto_algorithm.dart';

typedef InputCipher = ({
  InputExpirationBase parent
});

abstract class Cipher extends ExpirationBase implements ICipher {
  Cipher(InputCipher input) : super(input.parent);
}
