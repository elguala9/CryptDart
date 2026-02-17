import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_asimmetric.dart';
import 'package:cryptdart/implementations/partial/sign_impl.dart';
import 'package:meta/meta.dart';

/// Input parameters for [AsymmetricSign] constructor.
@immutable
class InputAsymmetricSign {
  final InputSign parent;
  final String publicKey;
  final String? privateKey;

  const InputAsymmetricSign({
    required this.parent,
    required this.publicKey,
    this.privateKey,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputAsymmetricSign &&
          runtimeType == other.runtimeType &&
          parent == other.parent &&
          publicKey == other.publicKey &&
          privateKey == other.privateKey;

  @override
  int get hashCode =>
      parent.hashCode ^ publicKey.hashCode ^ privateKey.hashCode;

  @override
  String toString() =>
      'InputAsymmetricSign(parent: $parent, publicKey: $publicKey, privateKey: $privateKey)';
}

/// Base class for asymmetric signature implementations.
/// Extends [Sign], mixes in [IAsymmetric] for keyId implementation, and implements [IAsymmetricSign].
@includeInBarrelFile
abstract class AsymmetricSign extends Sign with IAsymmetric
    implements IAsymmetricSign {
  final String publicKey;
  final String? privateKey;

  AsymmetricSign(InputAsymmetricSign input)
      : publicKey = input.publicKey,
        privateKey = input.privateKey,
        super(input.parent);
}
