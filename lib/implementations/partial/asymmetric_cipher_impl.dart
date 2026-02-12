import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_asimmetric.dart';
import 'package:cryptdart/implementations/partial/cipher_impl.dart';

typedef InputAsymmetricCipher = ({
  InputCipher parent,
  String publicKey,
  String? privateKey,
});

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
