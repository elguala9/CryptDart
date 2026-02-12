import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_simmetric.dart';
import 'package:cryptdart/implementations/partial/cipher_impl.dart';

/// Input parameters for [SymmetricCipher] constructor.
typedef InputSymmetricCipher = ({
  InputCipher parent,
  String key,
});

/// Base class for symmetric cipher implementations.
/// Extends [Cipher] and implements [ISymmetricCipher].
@includeInBarrelFile
abstract class SymmetricCipher extends Cipher implements ISymmetricCipher {
  final String _key;

  /// Constructs a [SymmetricCipher] with the given input parameters.
  SymmetricCipher(InputSymmetricCipher input)
      : _key = input.key,
        super(input.parent);

  @override
  String get key => _key;

  @override
  int get keyId => key.hashCode;
}
