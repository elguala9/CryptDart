import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_asimmetric.dart';
import 'package:cryptdart/implementations/partial/sign_impl.dart';

typedef InputAsymmetricSign = ({
  InputSign parent,
  String publicKey,
  String? privateKey,
});

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
