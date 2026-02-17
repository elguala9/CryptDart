import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_cipher.dart';
import 'package:cryptdart/implementations/partial/expiration_base.dart';
import 'package:meta/meta.dart';

/// Input parameters for [Cipher] constructor.
@immutable
class InputCipher {
  final InputExpirationBase parent;

  const InputCipher({
    required this.parent,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputCipher &&
          runtimeType == other.runtimeType &&
          parent == other.parent;

  @override
  int get hashCode => parent.hashCode;

  @override
  String toString() => 'InputCipher(parent: $parent)';
}

/// Base class for all cipher implementations.
/// Extends [ExpirationBase] and implements [ICipher].
@includeInBarrelFile
abstract class Cipher extends ExpirationBase implements ICipher {
  /// Constructs a [Cipher] with the given input parameters.
  Cipher(InputCipher input) : super(input.parent);
}
