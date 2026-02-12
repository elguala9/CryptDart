# Factory Methods Implementation

## Overview
Created a cohesive factory method system for all concrete cryptography classes. Factories call each other to minimize code duplication.

## Pattern Applied

### For each concrete class:

1. **generateKey/generateKeyPair** (already existed)
   - Static method that generates primitive key material
   - Returns `String` or `Map<String, String>`

2. **create()** 
   - Creates instance with newly generated keys
   - Calls `generateKey()/generateKeyPair()`
   - Accepts optional expiration parameters

3. **createWithKey()/createWithKeyPair()**
   - Creates instance with existing keys
   - Allows reusing keys or importing external keys
   - Calls themselves from `create()` to avoid duplication

## Files Modified

### Symmetric Ciphers
- ✅ `lib/implementations/symmetric/aes_cipher.dart` - AESCipher.create() / createWithKey()
- ✅ `lib/implementations/symmetric/chacha20_cipher.dart` - ChaCha20Cipher.create() / createWithKey() + generateNonce()
- ✅ `lib/implementations/symmetric/des_cipher.dart` - DESCipher.create() / createWithKey()

### Asymmetric Ciphers
- ✅ `lib/implementations/asymmetric/prime_based/rsa_cipher.dart` - RSACipher.create() / createWithKeyPair()
- ⏭️ `lib/implementations/asymmetric/non_prime_based/ecdsa_cipher.dart` - (not implemented, throws UnimplementedError)

### Signatures
- ✅ `lib/implementations/signed_based/hmac_sign.dart` - HMACSign.create() / createWithKey()
- ✅ `lib/implementations/signed_based/rsa_signature_cipher.dart` - RSASignatureCipher.create() / createWithKeyPair()
- ✅ `lib/implementations/signed_based/ecdsa_sign.dart` - ECDSASign.create() / createWithKeyPair()

### Key Exchange
- ✅ `lib/implementations/key_exchange/ecdh_key_exchange.dart` - ECDHKeyExchange.create() / createWithKeyPair()

## Usage Examples

```dart
// Symmetric - with auto key generation
final aes = AESCipher.create();
final chacha = ChaCha20Cipher.create(expirationDate: DateTime.now().add(Duration(days: 30)));

// Symmetric - with existing key
final aes = AESCipher.createWithKey(existingKeyHex);

// Asymmetric - with auto key generation (async)
final rsa = await RSACipher.create(bitLength: 2048);
final ecdsa = await ECDSASign.create(curve: 'prime256v1');

// Asymmetric - with existing keys
final rsa = RSACipher.createWithKeyPair(pubKeyPem, privKeyPem);
```

## Benefits

1. **Reduced Duplication**: `create()` calls `createWithKey()` with generated key
2. **Consistent API**: All factories follow same pattern
3. **Flexible**: Supports both auto-generation and existing key reuse
4. **Expiration Handling**: All factories accept expiration parameters
5. **Easy Maintenance**: New classes can copy the same pattern
