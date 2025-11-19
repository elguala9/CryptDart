import 'package:cryptdart/interfaces/i_asimmetric.dart';
import 'package:cryptdart/implementations/partial/cipher_impl.dart';

typedef InputAsymmetricCipher = ({
  InputCipher parent,
  String publicKey,
  String? privateKey,
});

abstract class AsymmetricCipher extends Cipher implements IAsymmetricCipher {
  final String publicKey;
  final String? privateKey;

  AsymmetricCipher(InputAsymmetricCipher input)
      : publicKey = input.publicKey,
        privateKey = input.privateKey,
        super(input.parent);
}
