# CryptDart AI Agent Instructions

## Project Overview
CryptDart is a Dart cryptography library (LGPL-3.0) providing unified interfaces for symmetric/asymmetric encryption, digital signatures, and key management. Built on PointyCastle and BasicUtils.

## Architecture

### Three-Layer Design
1. **Interfaces** (`interfaces/`) - Abstract contracts defining cryptographic operations
2. **Partial Implementations** (`implementations/partial/`) - Base classes with shared logic
3. **Concrete Implementations** (`implementations/`) - Algorithm-specific cipher/signature classes

### Key Interfaces
- `ICipher` - Base for all encryption/decryption (extends `IExpiration`)
- `ISymmetric` / `IAsymmetric` - Key management contracts with static `generateKey()`/`generateKeyPair()`
- `ISign` - Base for signing/verification operations
- Composed interfaces: `ISymmetricCipher`, `IAsymmetricCipher`, `ISymmetricSign`, `IAsymmetricSign`

### Directory Structure
```
implementations/
  partial/           # Base classes (Cipher, SymmetricCipher, AsymmetricCipher, etc.)
  symmetric/         # AES, DES, ChaCha20 implementations
  asymmetric/
    prime_based/     # RSA (prime-based algorithms)
    non_prime_based/ # ECC (currently empty - future work)
  signed_based/      # HMAC, RSA signatures, ECDSA/EdDSA (placeholders)
utils/
  crypto_utils.dart  # Centralized utilities (key generation, encoding, RSA operations)
```

## Centralized Utilities

**All implementations MUST use utilities from `utils/crypto_utils.dart`** to avoid code duplication:

- `SecureRandomUtils.createSeeded()` - Create seeded SecureRandom instance
- `SecureRandomUtils.generateRandomBytes(length)` - Generate random bytes
- `KeyEncodingUtils.bytesToHex(bytes)` - Convert bytes to hex string
- `KeyEncodingUtils.hexToBytes(hex)` - Convert hex to bytes
- `KeyEncodingUtils.stringKeyToBytes(key)` - Convert string key to bytes
- `RSAKeyUtils.generateKeyPair({bitLength})` - Generate RSA key pair (PEM)
- `RSAKeyUtils.parseKeyPair({publicKey, privateKey})` - Parse RSA keys from PEM
- `SymmetricKeyUtils.generateKey({bitLength})` - Generate symmetric key (hex)

## Critical Patterns

### 1. Named Record Input Pattern
**All implementations use named records for constructors**:
```dart
typedef InputAESCipher = ({
  String key,
  DateTime? expirationDate,
});

class AESCipher extends SymmetricCipher {
  AESCipher(InputAESCipher input) : super((...));
}
```
**Always define a typedef for input parameters before the class.**

### 2. Static Key Generation
Key generation is **static** on concrete classes using centralized utilities:
```dart
// Symmetric - use SymmetricKeyUtils
static String generateKey() {
  return SymmetricKeyUtils.generateKey(bitLength: 256);
}

// Asymmetric - use RSAKeyUtils
static Future<Map<String, String>> generateKeyPair({int bitLength = 2048}) async {
  return RSAKeyUtils.generateKeyPair(bitLength: bitLength);
}
```

**NEVER duplicate key generation logic - always use utils/crypto_utils.dart**

### 3. Expiration Handling
All ciphers inherit `isExpired()` from `IExpiration`. When `expirationDate` is `null`, `isExpired()` returns `true` (see `Cipher.isExpired()` in `cipher_impl.dart`).

### 4. Signature Verification Asymmetry
Signing operations have non-standard verification:
- `ISign.verify(data)` is abstract but **often throws `UnimplementedError`**
- Actual verification: `verifySignature(data, signature)` or `verifyHMAC(data, signature)`
- See `RSASignatureCipher` and `HMACSign` for examples

### 5. Algorithm Enum
All implementations must set their `CryptoAlgorithm` enum value from `types/crypto_algorithm.dart` in the super call.

## Development Workflow

### Setup
```powershell
dart pub get
```

### Testing
```powershell
dart test                                    # Run all tests
dart test test/symmetric_cipher_test.dart    # Specific test file
```

### Analysis
```powershell
dart analyze
```

### Test Patterns
- Block cipher tests use `padToBlockSize(data, blockSize)` and `unpad()` helpers (see `symmetric_cipher_test.dart`)
- Asymmetric tests use pre-generated PEM keys (note: SonarQube flags hardcoded keys)
- Test both with and without `expirationDate` to verify expiration logic

## Adding New Algorithms

### Symmetric Cipher Checklist
1. Create file in `implementations/symmetric/`
2. Define `Input<Name>Cipher` typedef with `key` and `expirationDate`
3. Extend `SymmetricCipher` from `implementations/partial/symmetric_cipher_impl.dart`
4. Implement `encrypt()` and `decrypt()` using PointyCastle engines
5. Add static `generateKey()` returning hex string (256-bit recommended)
6. Add algorithm to `CryptoAlgorithm` enum
7. Add tests with padding helpers for block ciphers

### Asymmetric Cipher Checklist
1. Create file in `implementations/asymmetric/prime_based/` or `non_prime_based/`
2. Define `Input<Name>Cipher` typedef with `publicKey`, `privateKey`, `expirationDate`
3. Extend `AsymmetricCipher` from `implementations/partial/asymmetric_cipher_impl.dart`
4. Parse keys in constructor (use `CryptoUtils` from `basic_utils`)
5. Implement async static `generateKeyPair()` returning `Map<String, String>`
6. Add algorithm to `CryptoAlgorithm` enum
7. Add tests with key generation

## Dependencies
- **pointycastle** (^3.7.3) - Core crypto primitives
- **basic_utils** (^5.6.0) - PEM key parsing/encoding
- **test** (^1.24.0) - Testing framework

## Current Limitations
- `lib/` directory is empty (no public API exports yet)
- ECDSA/EdDSA are placeholder imports in tests (files don't exist)
- ECC implementation folder exists but is empty
- No documentation on which PointyCastle modes to use (e.g., CTR vs CBC for AES)
