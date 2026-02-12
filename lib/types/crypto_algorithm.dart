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
      return cipherAlgorithms.firstWhere((e) => (e as dynamic).name == name);
    } catch (e) {
      try {
        // Then try signature algorithms
        return signAlgorithms.firstWhere((e) => (e as dynamic).name == name);
      } catch (e) {
        return null;
      }
    }
  }
}

/// Symmetric cipher algorithms.
@includeInBarrelFile
enum SymmetricCipherAlgorithm implements CryptoAlgorithm {
  aes,
  des,
  chacha20,
}

/// Asymmetric cipher algorithms.
@includeInBarrelFile
enum AsymmetricCipherAlgorithm implements CryptoAlgorithm {
  rsa,
  ecdsa,
}

/// Symmetric signature algorithms.
@includeInBarrelFile
enum SymmetricSignAlgorithm implements CryptoAlgorithm {
  hmac,
}

/// Asymmetric signature algorithms.
@includeInBarrelFile
enum AsymmetricSignAlgorithm implements CryptoAlgorithm {
  rsaSignature,
  ecdsa,
}
