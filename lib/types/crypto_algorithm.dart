import 'package:barrel_files_annotation/barrel_files_annotation.dart';

/// Supported cryptographic algorithms.
@includeInBarrelFile
enum CryptoAlgorithm {
  aes,
  des,
  chacha20,
  rsa,
  hmac,
  rsaSignature,
  ecdsa,
  // Add new algorithms here
}
