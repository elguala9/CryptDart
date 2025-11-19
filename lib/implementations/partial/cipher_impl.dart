import 'package:cryptdart/interfaces/i_cipher.dart';
import 'package:cryptdart/implementations/partial/expiration_base.dart';

/// Input parameters for [Cipher] constructor.
typedef InputCipher = ({
  InputExpirationBase parent
});

/// Base class for all cipher implementations.
/// Extends [ExpirationBase] and implements [ICipher].
abstract class Cipher extends ExpirationBase implements ICipher {
  /// Constructs a [Cipher] with the given input parameters.
  Cipher(InputCipher input) : super(input.parent);
}
