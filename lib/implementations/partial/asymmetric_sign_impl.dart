import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:cryptdart/interfaces/i_asimmetric.dart';
import 'package:cryptdart/implementations/partial/sign_impl.dart';

typedef InputAsymmetricSign = ({
  InputSign parent,
  String publicKey,
  String? privateKey,
});

@includeInBarrelFile
abstract class AsymmetricSign extends Sign implements IAsymmetricSign {
  final String publicKey;
  final String? privateKey;

  AsymmetricSign(InputAsymmetricSign input)
      : publicKey = input.publicKey,
        privateKey = input.privateKey,
        super(input.parent);

  @override
  int get keyId => publicKey.hashCode;
}
