import '../../interfaces/i_simmetric.dart';
import '../../types/crypto_algorithm.dart';
import 'cipher_impl.dart';

typedef InputSymmetricCipher = ({
  CryptoAlgorithm algorithm,
  DateTime? expirationDate,
  String key,
});

abstract class SymmetricCipher extends Cipher implements ISymmetricCipher {
  final String _key;

  SymmetricCipher(InputSymmetricCipher input)
      : _key = input.key,
        super((algorithm: input.algorithm, expirationDate: input.expirationDate));

  @override
  String get key => _key;
}
