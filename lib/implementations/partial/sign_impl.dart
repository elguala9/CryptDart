import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_sign.dart';
import 'package:cryptdart/implementations/partial/expiration_base.dart';
import 'package:meta/meta.dart';

/// Input parameters for [Sign] constructor.
@immutable
class InputSign {
  final InputExpirationBase parent;

  const InputSign({
    required this.parent,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputSign &&
          runtimeType == other.runtimeType &&
          parent == other.parent;

  @override
  int get hashCode => parent.hashCode;

  @override
  String toString() => 'InputSign(parent: $parent)';
}

/// Base class for signature implementations.
/// Extends [ExpirationBase] and implements [ISign].
@includeInBarrelFile
abstract class Sign extends ExpirationBase implements ISign {
  /// Constructs a [Sign] with the given input parameters.
  Sign(InputSign input) : super(input.parent);
}
