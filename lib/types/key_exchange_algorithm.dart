import 'package:barrel_files_annotation/barrel_files_annotation.dart';

/// Supported key exchange algorithms.
@includeInBarrelFile
enum KeyExchangeAlgorithm {
  ecdh,
  rsa, // RSA può essere usato anche per key exchange
  // Add new key exchange algorithms here
}