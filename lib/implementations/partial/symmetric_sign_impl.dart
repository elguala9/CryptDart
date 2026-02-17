import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_simmetric.dart';
import 'package:cryptdart/implementations/partial/sign_impl.dart';
import 'package:meta/meta.dart';

/// Input parameters for [SymmetricSign] constructor.
@immutable
class InputSymmetricSign {
  final InputSign parent;
  final String key;

  const InputSymmetricSign({
    required this.parent,
    required this.key,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputSymmetricSign &&
          runtimeType == other.runtimeType &&
          parent == other.parent &&
          key == other.key;

  @override
  int get hashCode => parent.hashCode ^ key.hashCode;

  @override
  String toString() =>
      'InputSymmetricSign(parent: $parent, key: $key)';
}

/// Base class for symmetric signature implementations.
/// Extends [Sign], mixes in [ISymmetric] for keyId implementation, and implements [ISymmetricSign].
@includeInBarrelFile
abstract class SymmetricSign extends Sign with ISymmetric
    implements ISymmetricSign {
  final String _key;

  /// Constructs a [SymmetricSign] with the given input parameters.
  SymmetricSign(InputSymmetricSign input)
      : _key = input.key,
        super(input.parent);

  @override
  String get key => _key;
}
