import '../../interfaces/key_exchange/i_key_exchange.dart';
import '../../implementations/partial/key_exchange_base.dart';
import '../../types/key_exchange_algorithm.dart';
import '../../utils/crypto_utils.dart';

typedef InputECDHKeyExchange = ({
  InputKeyExchangeBase parent,
  String publicKey,
  String privateKey,
  String curve,
});

/// ECDH key exchange implementation
class ECDHKeyExchange extends KeyExchangeBase implements IKeyExchange {
  final String _publicKey;
  final String _privateKey;
  final String _curve;

  ECDHKeyExchange(InputECDHKeyExchange input)
      : _publicKey = input.publicKey,
        _privateKey = input.privateKey,
        _curve = input.curve,
        super((
          algorithm: KeyExchangeAlgorithm.ecdh,
          expirationDate: input.parent.expirationDate,
          expirationTimes: input.parent.expirationTimes,
        ));

  @override
  String get publicKey => _publicKey;

  @override
  String get privateKey => _privateKey;

  /// The curve used for this key exchange
  String get curve => _curve;

  @override
  Future<String> generateSharedSecret(String otherPublicKey) async {
    if (isExpired()) {
      throw StateError('ECDH key exchange has expired');
    }

    final keyPair = ECCKeyUtils.parseKeyPair(
      publicKey: _publicKey,
      privateKey: _privateKey,
    );

    final otherPubKey = ECCKeyUtils.parsePublicKey(otherPublicKey);
    
    final sharedSecretBytes = ECCKeyUtils.performECDH(
      keyPair.privateKey!,
      otherPubKey,
    );

    return KeyEncodingUtils.bytesToHex(sharedSecretBytes);
  }

  @override
  String getPublicKey() => _publicKey;

  /// Generates a new ECDH key pair for the specified curve
  static Future<Map<String, String>> generateKeyPair({
    String curve = ECCKeyUtils.secp256r1,
  }) async {
    return ECCKeyUtils.generateKeyPair(curve: curve);
  }
}