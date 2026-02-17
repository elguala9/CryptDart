import 'package:barrel_files_annotation/barrel_files_annotation.dart';

/// Base sealed class for all cryptographic algorithms.
/// Used as a common type for cipher and signature algorithms.
@includeInBarrelFile
sealed class CryptoAlgorithm {
  /// Numeric code identifying this algorithm
  final int code;

  /// Name of this algorithm
  final String name;

  const CryptoAlgorithm(this.code, this.name);

  /// All available cipher algorithms (symmetric and asymmetric)
  static List<CryptoAlgorithm> get cipherAlgorithms {
    return [
      ...SymmetricCipherAlgorithm.values,
      ...AsymmetricCipherAlgorithm.values,
    ];
  }

  /// All available signature algorithms (symmetric and asymmetric)
  static List<CryptoAlgorithm> get signAlgorithms {
    return [
      ...SymmetricSignAlgorithm.values,
      ...AsymmetricSignAlgorithm.values,
    ];
  }

  /// All available algorithms
  static List<CryptoAlgorithm> get allAlgorithms {
    return [
      ...cipherAlgorithms,
      ...signAlgorithms,
    ];
  }

  /// Get all symmetric algorithms (both ciphers and signatures)
  static List<CryptoAlgorithm> get symmetricAlgorithms {
    return [
      ...SymmetricCipherAlgorithm.values,
      ...SymmetricSignAlgorithm.values,
    ];
  }

  /// Get all asymmetric algorithms (both ciphers and signatures)
  static List<CryptoAlgorithm> get asymmetricAlgorithms {
    return [
      ...AsymmetricCipherAlgorithm.values,
      ...AsymmetricSignAlgorithm.values,
    ];
  }

  /// Find an algorithm by name across all types
  static CryptoAlgorithm? findByName(String name) {
    try {
      return allAlgorithms.firstWhere((algo) => algo.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Find an algorithm by its numeric code
  static CryptoAlgorithm? findByCode(int code) {
    try {
      return allAlgorithms.firstWhere((algo) => algo.code == code);
    } catch (e) {
      return null;
    }
  }
}

/// Symmetric cipher algorithms.
@includeInBarrelFile
sealed class SymmetricCipherAlgorithm extends CryptoAlgorithm {
  const SymmetricCipherAlgorithm(super.code, super.name);

  /// Static getters for enum-like access
  static AESAlgorithm get aes => AESAlgorithm.instance;
  static DESAlgorithm get des => DESAlgorithm.instance;
  static ChaCha20Algorithm get chacha20 => ChaCha20Algorithm.instance;

  static const List<SymmetricCipherAlgorithm> values = [
    AESAlgorithm.instance,
    DESAlgorithm.instance,
    ChaCha20Algorithm.instance,
  ];

  @override
  String toString() => 'SymmetricCipherAlgorithm.$name';
}

/// AES cipher algorithm
@includeInBarrelFile
final class AESAlgorithm extends SymmetricCipherAlgorithm {
  const AESAlgorithm._() : super(1, 'aes');

  /// The singleton instance
  static const instance = AESAlgorithm._();

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => code;
}

/// DES cipher algorithm
@includeInBarrelFile
final class DESAlgorithm extends SymmetricCipherAlgorithm {
  const DESAlgorithm._() : super(2, 'des');

  /// The singleton instance
  static const instance = DESAlgorithm._();

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => code;
}

/// ChaCha20 cipher algorithm
@includeInBarrelFile
final class ChaCha20Algorithm extends SymmetricCipherAlgorithm {
  const ChaCha20Algorithm._() : super(3, 'chacha20');

  /// The singleton instance
  static const instance = ChaCha20Algorithm._();

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => code;
}

/// Asymmetric cipher algorithms.
@includeInBarrelFile
sealed class AsymmetricCipherAlgorithm extends CryptoAlgorithm {
  const AsymmetricCipherAlgorithm(super.code, super.name);

  /// Static getters for enum-like access
  static RSAAlgorithm get rsa => RSAAlgorithm.instance;
  static ECDSACipherAlgorithm get ecdsa => ECDSACipherAlgorithm.instance;

  static const List<AsymmetricCipherAlgorithm> values = [
    RSAAlgorithm.instance,
    ECDSACipherAlgorithm.instance,
  ];

  @override
  String toString() => 'AsymmetricCipherAlgorithm.$name';
}

/// RSA cipher algorithm
@includeInBarrelFile
final class RSAAlgorithm extends AsymmetricCipherAlgorithm {
  const RSAAlgorithm._() : super(11, 'rsa');

  /// The singleton instance
  static const instance = RSAAlgorithm._();

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => code;
}

/// ECDSA cipher algorithm
@includeInBarrelFile
final class ECDSACipherAlgorithm extends AsymmetricCipherAlgorithm {
  const ECDSACipherAlgorithm._() : super(12, 'ecdsa');

  /// The singleton instance
  static const instance = ECDSACipherAlgorithm._();

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => code;
}

/// Symmetric signature algorithms.
@includeInBarrelFile
sealed class SymmetricSignAlgorithm extends CryptoAlgorithm {
  const SymmetricSignAlgorithm(super.code, super.name);

  /// Static getters for enum-like access
  static HMACAlgorithm get hmac => HMACAlgorithm.instance;

  static const List<SymmetricSignAlgorithm> values = [
    HMACAlgorithm.instance,
  ];

  @override
  String toString() => 'SymmetricSignAlgorithm.$name';
}

/// HMAC signature algorithm
@includeInBarrelFile
final class HMACAlgorithm extends SymmetricSignAlgorithm {
  const HMACAlgorithm._() : super(21, 'hmac');

  /// The singleton instance
  static const instance = HMACAlgorithm._();

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => code;
}

/// Asymmetric signature algorithms.
@includeInBarrelFile
sealed class AsymmetricSignAlgorithm extends CryptoAlgorithm {
  const AsymmetricSignAlgorithm(super.code, super.name);

  /// Static getters for enum-like access
  static RSASignatureAlgorithm get rsaSignature => RSASignatureAlgorithm.instance;
  static ECDSASignAlgorithm get ecdsa => ECDSASignAlgorithm.instance;

  static const List<AsymmetricSignAlgorithm> values = [
    RSASignatureAlgorithm.instance,
    ECDSASignAlgorithm.instance,
  ];

  @override
  String toString() => 'AsymmetricSignAlgorithm.$name';
}

/// RSA signature algorithm
@includeInBarrelFile
final class RSASignatureAlgorithm extends AsymmetricSignAlgorithm {
  const RSASignatureAlgorithm._() : super(31, 'rsaSignature');

  /// The singleton instance
  static const instance = RSASignatureAlgorithm._();

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => code;
}

/// ECDSA signature algorithm
@includeInBarrelFile
final class ECDSASignAlgorithm extends AsymmetricSignAlgorithm {
  const ECDSASignAlgorithm._() : super(32, 'ecdsa');

  /// The singleton instance
  static const instance = ECDSASignAlgorithm._();

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => code;
}
