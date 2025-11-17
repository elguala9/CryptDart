import '../../interfaces/i_asimmetric.dart';
import 'sign_impl.dart';

typedef InputAsymmetricSign = ({
  InputSign parent,
  String publicKey,
  String? privateKey,
});

abstract class AsymmetricSign extends Sign implements IAsymmetricSign {
  final String publicKey;
  final String? privateKey;

  AsymmetricSign(InputAsymmetricSign input)
      : publicKey = input.publicKey,
        privateKey = input.privateKey,
        super(input.parent);
}
