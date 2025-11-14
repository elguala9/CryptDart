import '../../interfaces/i_shsp_asimmetric_enc.dart';
import '../../types/crypto_algorithm.dart';
import 'encryption_impl.dart';

abstract class AsymmetricEncryption extends Encryption implements IAsymmetricEncryption {
  final String _publicKey;
  final String? _privateKey;

  AsymmetricEncryption({
    required CryptoAlgorithm algorithm,
    required DateTime expirationDate,
    required String publicKey,
    required String privateKey,
  }) : _publicKey = publicKey,
       _privateKey = privateKey,
       super(algorithm: algorithm, expirationDate: expirationDate);

  @override
  String get publicKey => _publicKey;

  @override
  String get privateKey {
    if(_privateKey == null)
      throw UnimplementedError();
    return _privateKey!;
    }
}
