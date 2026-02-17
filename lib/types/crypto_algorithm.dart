import 'package:barrel_files_annotation/barrel_files_annotation.dart';

/// Enum with all available cryptographic algorithms.
@includeInBarrelFile
enum CryptoAlgorithm {
  aes,
  des,
  chacha20,
  rsa,
  ecdsa,
  hmac,
  rsaSignature,
  ecdsaSign,
}

/// Static class providing access to all symmetric algorithms as enums.
/// Cannot be instantiated.
@includeInBarrelFile
class SymmetricAlgorithm {
  SymmetricAlgorithm._();

  static CryptoAlgorithm get aes => CryptoAlgorithm.aes;
  static CryptoAlgorithm get des => CryptoAlgorithm.des;
  static CryptoAlgorithm get chacha20 => CryptoAlgorithm.chacha20;
  static CryptoAlgorithm get hmac => CryptoAlgorithm.hmac;

  static const List<CryptoAlgorithm> values = [
    CryptoAlgorithm.aes,
    CryptoAlgorithm.des,
    CryptoAlgorithm.chacha20,
    CryptoAlgorithm.hmac,
  ];
}

/// Static class providing access to all asymmetric algorithms as enums.
/// Cannot be instantiated.
@includeInBarrelFile
class AsymmetricAlgorithm {
  AsymmetricAlgorithm._();

  static CryptoAlgorithm get rsa => CryptoAlgorithm.rsa;
  static CryptoAlgorithm get ecdsa => CryptoAlgorithm.ecdsa;
  static CryptoAlgorithm get rsaSignature => CryptoAlgorithm.rsaSignature;
  static CryptoAlgorithm get ecdsaSign => CryptoAlgorithm.ecdsaSign;

  static const List<CryptoAlgorithm> values = [
    CryptoAlgorithm.rsa,
    CryptoAlgorithm.ecdsa,
    CryptoAlgorithm.rsaSignature,
    CryptoAlgorithm.ecdsaSign,
  ];
}

/// Static class providing access to symmetric signature algorithms as enums.
/// Cannot be instantiated.
@includeInBarrelFile
class SymmetricSignAlgorithmEnum {
  SymmetricSignAlgorithmEnum._();

  static CryptoAlgorithm get hmac => CryptoAlgorithm.hmac;

  static const List<CryptoAlgorithm> values = [
    CryptoAlgorithm.hmac,
  ];
}

/// Static class providing access to symmetric cipher algorithms as enums.
/// Cannot be instantiated.
@includeInBarrelFile
class SymmetricCipherAlgorithmEnum {
  SymmetricCipherAlgorithmEnum._();

  static CryptoAlgorithm get aes => CryptoAlgorithm.aes;
  static CryptoAlgorithm get des => CryptoAlgorithm.des;
  static CryptoAlgorithm get chacha20 => CryptoAlgorithm.chacha20;

  static const List<CryptoAlgorithm> values = [
    CryptoAlgorithm.aes,
    CryptoAlgorithm.des,
    CryptoAlgorithm.chacha20,
  ];
}

/// Static class providing access to asymmetric cipher algorithms as enums.
/// Cannot be instantiated.
@includeInBarrelFile
class AsymmetricCipherAlgorithmEnum {
  AsymmetricCipherAlgorithmEnum._();

  static CryptoAlgorithm get rsa => CryptoAlgorithm.rsa;
  static CryptoAlgorithm get ecdsa => CryptoAlgorithm.ecdsa;

  static const List<CryptoAlgorithm> values = [
    CryptoAlgorithm.rsa,
    CryptoAlgorithm.ecdsa,
  ];
}

/// Static class providing access to asymmetric signature algorithms as enums.
/// Cannot be instantiated.
@includeInBarrelFile
class AsymmetricSignAlgorithmEnum {
  AsymmetricSignAlgorithmEnum._();

  static CryptoAlgorithm get rsaSignature => CryptoAlgorithm.rsaSignature;
  static CryptoAlgorithm get ecdsaSign => CryptoAlgorithm.ecdsaSign;

  static const List<CryptoAlgorithm> values = [
    CryptoAlgorithm.rsaSignature,
    CryptoAlgorithm.ecdsaSign,
  ];
}
