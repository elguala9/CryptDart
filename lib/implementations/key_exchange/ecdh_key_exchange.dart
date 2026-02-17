import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import 'package:meta/meta.dart';
import '../../interfaces/key_exchange/i_key_exchange.dart';
import '../../implementations/partial/key_exchange_base.dart';
import '../../types/key_exchange_algorithm.dart';
import '../../utils/crypto_utils.dart';

/// Input parameters for [ECDHKeyExchange] constructor.
@immutable
class InputECDHKeyExchange {
  final InputKeyExchangeBase parent;
  final String publicKey;
  final String privateKey;
  final String curve;

  const InputECDHKeyExchange({
    required this.parent,
    required this.publicKey,
    required this.privateKey,
    required this.curve,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputECDHKeyExchange &&
          runtimeType == other.runtimeType &&
          parent == other.parent &&
          publicKey == other.publicKey &&
          privateKey == other.privateKey &&
          curve == other.curve;

  @override
  int get hashCode =>
      parent.hashCode ^
      publicKey.hashCode ^
      privateKey.hashCode ^
      curve.hashCode;

  @override
  String toString() =>
      'InputECDHKeyExchange(parent: $parent, publicKey: $publicKey, privateKey: $privateKey, curve: $curve)';
}

/// ECDH key exchange implementation
@includeInBarrelFile
class ECDHKeyExchange extends KeyExchangeBase implements IKeyExchange {
  final String _publicKey;
  final String _privateKey;
  final String _curve;

  ECDHKeyExchange(InputECDHKeyExchange input)
      : _publicKey = input.publicKey,
        _privateKey = input.privateKey,
        _curve = input.curve,
        super(InputKeyExchangeBase(
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
  String generateSharedSecret(String otherPublicKey) {
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

  /// Creates an [ECDHKeyExchange] with full control over all parameters.
  ///
  /// Accepts the complete [InputECDHKeyExchange] record, allowing complete customization
  /// of all nested parameters. This factory automatically adapts to any changes
  /// in the input structure without requiring modifications.
  static ECDHKeyExchange createFull(InputECDHKeyExchange input) =>
      ECDHKeyExchange(input);
}