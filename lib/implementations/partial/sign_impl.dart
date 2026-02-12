import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_sign.dart';
import 'package:cryptdart/implementations/partial/expiration_base.dart';

/// Input parameters for [Sign] constructor.
typedef InputSign = ({InputExpirationBase parent});

/// Base class for signature implementations.
/// Extends [ExpirationBase] and implements [ISign].
@includeInBarrelFile
abstract class Sign extends ExpirationBase implements ISign {
  /// Constructs a [Sign] with the given input parameters.
  Sign(InputSign input) : super(input.parent);
}
