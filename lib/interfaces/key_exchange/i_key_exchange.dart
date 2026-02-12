import 'package:barrel_files_annotation/barrel_files_annotation.dart';
import '../i_base_expiration.dart';
import '../../types/key_exchange_algorithm.dart';

/// Interface for key exchange protocols like ECDH.
@includeInBarrelFile
abstract class IKeyExchange implements IBaseExpiration {
  /// The key exchange algorithm used by this implementation.
  KeyExchangeAlgorithm get algorithm;

  /// The public key that can be shared with the other party.
  String get publicKey;

  /// The private key used for generating shared secrets.
  String get privateKey;

  /// Generates a shared secret using the other party's public key.
  /// Returns the shared secret as hex string.
  Future<String> generateSharedSecret(String otherPublicKey);

  /// Returns the public key for sharing with the other party.
  String getPublicKey();
}