import 'package:barrel_files_annotation/barrel_files_annotation.dart';

/// Base sealed class for all cryptographic algorithms.
/// Used as a common type for cipher and signature algorithms.
@includeInBarrelFile
sealed class CryptoAlgorithm {
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

  /// Get all symmetric cipher algorithms
  static List<CryptoAlgorithm> get symmetricAlgorithms {
    return [
      ...SymmetricCipherAlgorithm.values,
      ...SymmetricSignAlgorithm.values,
    ];
  }

  /// Get all asymmetric algorithms
  static List<CryptoAlgorithm> get asymmetricAlgorithms {
    return [
      ...AsymmetricCipherAlgorithm.values,
      ...AsymmetricSignAlgorithm.values,
    ];
  }

  /// Find an algorithm by name across all types
  static CryptoAlgorithm? findByName(String name) {
    try {
      // Try cipher algorithms first
      return cipherAlgorithms.firstWhere((e) => _extractAlgorithmName(e) == name);
    } catch (e) {
      try {
        // Then try signature algorithms
        return signAlgorithms.firstWhere((e) => _extractAlgorithmName(e) == name);
      } catch (e) {
        return null;
      }
    }
  }

  /// Helper to extract algorithm name from toString representation
  static String _extractAlgorithmName(CryptoAlgorithm algo) {
    final str = algo.toString();
    final parts = str.split('.');
    return parts.length > 1 ? parts[1] : str;
  }

  /// Find an algorithm by its numeric code
  static CryptoAlgorithm? findByCode(int code) {
    try {
      return allAlgorithms.firstWhere((algo) {
        if (algo is SymmetricCipherAlgorithm) return algo.code == code;
        if (algo is AsymmetricCipherAlgorithm) return algo.code == code;
        if (algo is SymmetricSignAlgorithm) return algo.code == code;
        if (algo is AsymmetricSignAlgorithm) return algo.code == code;
        return false;
      });
    } catch (e) {
      return null;
    }
  }
}

/// Symmetric cipher algorithms.
@includeInBarrelFile
enum SymmetricCipherAlgorithm implements CryptoAlgorithm {
  aes(1),
  des(2),
  chacha20(3);

  final int code;
  const SymmetricCipherAlgorithm(this.code);
}

/// Asymmetric cipher algorithms.
@includeInBarrelFile
enum AsymmetricCipherAlgorithm implements CryptoAlgorithm {
  rsa(11),
  ecdsa(12);

  final int code;
  const AsymmetricCipherAlgorithm(this.code);
}

/// Symmetric signature algorithms.
@includeInBarrelFile
enum SymmetricSignAlgorithm implements CryptoAlgorithm {
  hmac(21);

  final int code;
  const SymmetricSignAlgorithm(this.code);
}

/// Asymmetric signature algorithms.
@includeInBarrelFile
enum AsymmetricSignAlgorithm implements CryptoAlgorithm {
  rsaSignature(31),
  ecdsa(32);

  final int code;
  const AsymmetricSignAlgorithm(this.code);
}

/// All symmetric algorithms (both ciphers and signatures).
@includeInBarrelFile
enum SymmetricAlgorithm implements CryptoAlgorithm {
  aes(1),
  des(2),
  chacha20(3),
  hmac(21);

  final int code;
  const SymmetricAlgorithm(this.code);
}

/// All asymmetric algorithms (both ciphers and signatures).
/// Note: ECDSA has different codes for cipher (12) and signature (32).
@includeInBarrelFile
enum AsymmetricAlgorithm implements CryptoAlgorithm {
  rsa(11),
  ecdsaCipher(12),
  rsaSignature(31),
  ecdsaSign(32);

  final int code;
  const AsymmetricAlgorithm(this.code);
}
