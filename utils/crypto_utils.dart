// Centralized cryptographic utilities to avoid code duplication
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:basic_utils/basic_utils.dart' as BasicUtils;

/// Utilities for SecureRandom generation
class SecureRandomUtils {
  /// Creates and seeds a SecureRandom instance
  static SecureRandom createSeeded({int seedLength = 32}) {
    final rnd = SecureRandom('AES/CTR/AUTO-SEED-PRNG');
    final seed = Uint8List.fromList(
      List.generate(seedLength, (_) => DateTime.now().microsecondsSinceEpoch % 256)
    );
    rnd.seed(KeyParameter(seed));
    return rnd;
  }

  /// Generates random bytes of specified length
  static Uint8List generateRandomBytes(int length) {
    final rnd = createSeeded();
    return rnd.nextBytes(length);
  }
}

/// Utilities for key encoding and conversion
class KeyEncodingUtils {
  /// Converts bytes to hex string
  static String bytesToHex(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Converts hex string to bytes
  static Uint8List hexToBytes(String hex) {
    if (hex.length % 2 != 0) {
      throw ArgumentError('Hex string must have even length');
    }
    return Uint8List.fromList(
      List.generate(
        hex.length ~/ 2,
        (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16),
      ),
    );
  }

  /// Converts string key to bytes (for symmetric keys stored as strings)
  static Uint8List stringKeyToBytes(String key) {
    return Uint8List.fromList(key.codeUnits);
  }
}

/// Utilities for RSA key operations
class RSAKeyUtils {
  /// Generates an RSA key pair in PEM format
  static Future<Map<String, String>> generateKeyPair({int bitLength = 2048}) async {
    final keyParams = RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64);
    final secureRandom = SecureRandomUtils.createSeeded();
    final rngParams = ParametersWithRandom(keyParams, secureRandom);
    final generator = RSAKeyGenerator();
    generator.init(rngParams);
    final pair = generator.generateKeyPair();
    
    final pub = pair.publicKey as RSAPublicKey;
    final priv = pair.privateKey as RSAPrivateKey;
    final pubPem = BasicUtils.CryptoUtils.encodeRSAPublicKeyToPem(pub);
    final privPem = BasicUtils.CryptoUtils.encodeRSAPrivateKeyToPem(priv);
    
    return {'publicKey': pubPem, 'privateKey': privPem};
  }

  /// Parses RSA public key from PEM string
  static RSAPublicKey parsePublicKey(String pemKey) {
    return BasicUtils.CryptoUtils.rsaPublicKeyFromPem(pemKey);
  }

  /// Parses RSA private key from PEM string
  static RSAPrivateKey parsePrivateKey(String pemKey) {
    return BasicUtils.CryptoUtils.rsaPrivateKeyFromPem(pemKey);
  }

  /// Parses both public and private keys (if provided)
  static ({RSAPublicKey publicKey, RSAPrivateKey? privateKey}) parseKeyPair({
    required String publicKey,
    String? privateKey,
  }) {
    final pubKey = parsePublicKey(publicKey);
    final privKey = privateKey != null ? parsePrivateKey(privateKey) : null;
    return (publicKey: pubKey, privateKey: privKey);
  }
}

/// Utilities for symmetric key generation
class SymmetricKeyUtils {
  /// Generates a symmetric key as hex string
  static String generateKey({int bitLength = 256}) {
    final byteLength = bitLength ~/ 8;
    final keyBytes = SecureRandomUtils.generateRandomBytes(byteLength);
    return KeyEncodingUtils.bytesToHex(keyBytes);
  }
}
