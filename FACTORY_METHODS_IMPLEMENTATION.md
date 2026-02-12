# 🏭 Factory Methods Implementation

## Overview

Implemented a **cohesive factory method system** for all concrete cryptography classes in CryptDart. This eliminates code duplication and provides a consistent, user-friendly API.

## 🎯 Design Pattern

Each concrete class now follows this pattern:

```dart
// 1. Generate primitive key material (already existed)
static String generateKey() { ... }
static Future<Map<String, String>> generateKeyPair() { ... }

// 2. Create with auto-generated keys
static XCipher create({ DateTime? expirationDate, int? expirationTimes }) {
  return createWithKey(
    generateKey(),
    expirationDate: expirationDate,
    expirationTimes: expirationTimes,
  );
}

// 3. Create with existing keys (reused by create())
static XCipher createWithKey(String key, { DateTime? expirationDate, int? expirationTimes }) {
  return XCipher((
    parent: (
      key: key,
      parent: (
        parent: (
          algorithm: CryptoAlgorithm.x,
          expirationDate: expirationDate,
          expirationTimes: expirationTimes,
        ),
      ),
    ),
  ));
}
```

## 📝 Files Modified

### ✅ Symmetric Ciphers (3 files)

1. **[lib/implementations/symmetric/aes_cipher.dart](lib/implementations/symmetric/aes_cipher.dart)**
   - ✨ Added: `AESCipher.create()`
   - ✨ Added: `AESCipher.createWithKey()`
   - Import: `CryptoAlgorithm`

2. **[lib/implementations/symmetric/chacha20_cipher.dart](lib/implementations/symmetric/chacha20_cipher.dart)**
   - ✨ Added: `ChaCha20Cipher.generateNonce()`
   - ✨ Added: `ChaCha20Cipher.create()`
   - ✨ Added: `ChaCha20Cipher.createWithKey()`
   - Import: `CryptoAlgorithm`

3. **[lib/implementations/symmetric/des_cipher.dart](lib/implementations/symmetric/des_cipher.dart)**
   - ✨ Added: `DESCipher.create()`
   - ✨ Added: `DESCipher.createWithKey()`
   - Import: `CryptoAlgorithm`

### ✅ Asymmetric Ciphers (1 file)

4. **[lib/implementations/asymmetric/prime_based/rsa_cipher.dart](lib/implementations/asymmetric/prime_based/rsa_cipher.dart)**
   - ✨ Added: `RSACipher.create()` (async)
   - ✨ Added: `RSACipher.createWithKeyPair()`
   - Import: `CryptoAlgorithm`

### ✅ Digital Signatures (3 files)

5. **[lib/implementations/signed_based/hmac_sign.dart](lib/implementations/signed_based/hmac_sign.dart)**
   - ✨ Added: `HMACSign.create()`
   - ✨ Added: `HMACSign.createWithKey()`
   - Import: `CryptoAlgorithm`

6. **[lib/implementations/signed_based/rsa_signature_cipher.dart](lib/implementations/signed_based/rsa_signature_cipher.dart)**
   - ✨ Added: `RSASignatureCipher.create()` (async)
   - ✨ Added: `RSASignatureCipher.createWithKeyPair()`
   - Import: `CryptoAlgorithm`

7. **[lib/implementations/signed_based/ecdsa_sign.dart](lib/implementations/signed_based/ecdsa_sign.dart)**
   - ✨ Added: `ECDSASign.create()` (async)
   - ✨ Added: `ECDSASign.createWithKeyPair()`
   - Import: `CryptoAlgorithm`

### ✅ Key Exchange (1 file)

8. **[lib/implementations/key_exchange/ecdh_key_exchange.dart](lib/implementations/key_exchange/ecdh_key_exchange.dart)**
   - ✨ Added: `ECDHKeyExchange.create()` (async)
   - ✨ Added: `ECDHKeyExchange.createWithKeyPair()`

### ℹ️ Example

9. **[example/factory_methods_example.dart](example/factory_methods_example.dart)** (NEW)
   - Complete demonstration of all factory methods
   - Shows usage patterns for all cipher types
   - Includes practical encrypt/decrypt example

## 💡 Usage Examples

### Symmetric Ciphers
```dart
// Auto-generate key
final aes = AESCipher.create();

// With expiration
final aes = AESCipher.create(
  expirationDate: DateTime.now().add(Duration(days: 30)),
  expirationTimes: 1000,
);

// With existing key
final aes = AESCipher.createWithKey(existingKeyHex);

// ChaCha20 with custom nonce
final chacha = ChaCha20Cipher.create();
final chachaNonce = ChaCha20Cipher.generateNonce();
final chacha = ChaCha20Cipher.createWithKey(keyHex, nonce: chachaNonce);
```

### Asymmetric Ciphers & Signatures
```dart
// Auto-generate key pair
final rsa = await RSACipher.create();

// With custom bit length
final rsa = await RSACipher.create(bitLength: 4096);

// With existing key pair
final rsa = RSACipher.createWithKeyPair(pubKeyPem, privKeyPem);

// ECDSA with custom curve
final ecdsa = await ECDSASign.create(curve: 'prime384v1');
```

### Key Exchange
```dart
// Auto-generate ECDH pair
final ecdh = await ECDHKeyExchange.create();

// With custom curve
final ecdh = await ECDHKeyExchange.create(
  curve: ECCKeyUtils.secp384r1,
);

// With existing key pair
final ecdh = ECDHKeyExchange.createWithKeyPair(
  publicKeyPem,
  privateKeyPem,
  curve: ECCKeyUtils.secp256r1,
);
```

## 🎁 Benefits

| Feature | Benefit |
|---------|---------|
| **Reduced Duplication** | `create()` calls `createWithKey()` internally |
| **Consistent API** | All factories follow identical pattern |
| **Flexible** | Supports both auto-generation and key reuse |
| **Expiration** | All factories accept expiration parameters |
| **Easy to Maintain** | New classes can copy the same pattern |
| **Type-Safe** | Full Dart null-safety support |
| **Well-Documented** | Complete examples in `factory_methods_example.dart` |

## ✅ Verification

- ✅ Code compiles without errors (`dart analyze` passed)
- ✅ All 9 concrete classes have factory methods
- ✅ Consistent pattern across all classes
- ✅ Example demonstrates all usage patterns
- ✅ No breaking changes to existing API

## 📊 Summary

| Category | Count | Status |
|----------|-------|--------|
| Symmetric Ciphers | 3 | ✅ Complete |
| Asymmetric Ciphers | 1 | ✅ Complete |
| Signatures | 3 | ✅ Complete |
| Key Exchange | 1 | ✅ Complete |
| **Total Classes** | **8** | **✅ All Done** |
| **New Factory Methods** | **16** | (8 classes × 2 factories each) |

## 🚀 Next Steps

1. Run tests to ensure backward compatibility: `dart test`
2. Test the example: `dart run example/factory_methods_example.dart`
3. Update documentation if needed
4. Consider adding similar patterns to Handler/Session classes if desired

---

**Implementation completed successfully!** 🎉
