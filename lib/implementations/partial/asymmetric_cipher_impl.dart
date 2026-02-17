import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_asimmetric.dart';
import 'package:cryptdart/implementations/partial/cipher_impl.dart';
import 'package:meta/meta.dart';

/// Input parameters for [AsymmetricCipher] constructor.
@immutable
class InputAsymmetricCipher {
  final InputCipher parent;
  final String publicKey;
  final String? privateKey;

  const InputAsymmetricCipher({
    required this.parent,
    required this.publicKey,
    this.privateKey,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputAsymmetricCipher &&
          runtimeType == other.runtimeType &&
          parent == other.parent &&
          publicKey == other.publicKey &&
          privateKey == other.privateKey;

  @override
  int get hashCode =>
      parent.hashCode ^ publicKey.hashCode ^ privateKey.hashCode;

  @override
  String toString() =>
      'InputAsymmetricCipher(parent: $parent, publicKey: $publicKey, privateKey: $privateKey)';
}

/// Base class for asymmetric cipher implementations.
/// Extends [Cipher], mixes in [IAsymmetric] for keyId implementation, and implements [IAsymmetricCipher].
@includeInBarrelFile
abstract class AsymmetricCipher extends Cipher with IAsymmetric
    implements IAsymmetricCipher {
  final String publicKey;
  final String? privateKey;

  AsymmetricCipher(InputAsymmetricCipher input)
      : publicKey = input.publicKey,
        privateKey = input.privateKey,
        super(input.parent);
}
