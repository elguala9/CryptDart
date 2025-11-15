import '../../interfaces/i_simmetric.dart';
import '../../types/crypto_algorithm.dart';
import 'sign_impl.dart';

typedef InputSymmetricSign = ({
  CryptoAlgorithm algorithm,
  DateTime? expirationDate,
  String key,
});

abstract class SymmetricSign extends Sign implements ISymmetricSign {
  final String _key;

  SymmetricSign(InputSymmetricSign input)
      : _key = input.key,
        super((algorithm: input.algorithm, expirationDate: input.expirationDate));

  @override
  String get key => _key;
}
