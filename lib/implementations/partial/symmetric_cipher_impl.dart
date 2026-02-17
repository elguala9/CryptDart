import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_simmetric.dart';
import 'package:cryptdart/implementations/partial/cipher_impl.dart';
import 'package:meta/meta.dart';

/// Input parameters for [SymmetricCipher] constructor.
@immutable
class InputSymmetricCipher {
  final InputCipher parent;
  final String key;

  const InputSymmetricCipher({
    required this.parent,
    required this.key,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputSymmetricCipher &&
          runtimeType == other.runtimeType &&
          parent == other.parent &&
          key == other.key;

  @override
  int get hashCode => parent.hashCode ^ key.hashCode;

  @override
  String toString() =>
      'InputSymmetricCipher(parent: $parent, key: $key)';
}

/// Base class for symmetric cipher implementations.
/// Extends [Cipher], mixes in [ISymmetric] for keyId implementation, and implements [ISymmetricCipher].
@includeInBarrelFile
abstract class SymmetricCipher extends Cipher with ISymmetric
    implements ISymmetricCipher {
  final String _key;

  /// Constructs a [SymmetricCipher] with the given input parameters.
  SymmetricCipher(InputSymmetricCipher input)
      : _key = input.key,
        super(input.parent);

  @override
  String get key => _key;
}
