# 🏭 Factory Methods - Complete Implementation

## Overview

Implementazione finale e pulita di factory methods per tutte le 8 classi concrete di CryptDart. **Single Responsibility**: ogni factory fa una cosa sola e la fa bene.

## Architecture

```
generateKey/generateKeyPair()  →  generateKey/generateKeyPair() static methods
                                  (genera chiavi/keypair grezzi)
                                            ↓
createFull(Input)              →  createFull() factory method
                                  (accetta record Input completo)
                                            ↓
Instance                       →  Istanza fully configurata
```

## Usage Pattern

### Simple: Generate + Create
```dart
// 1. Genera chiave
final key = AESCipher.generateKey();

// 2. Crea istanza con configurazione completa
final cipher = AESCipher.createFull((
  parent: (
    key: key,
    parent: (
      parent: (
        algorithm: CryptoAlgorithm.aes,
        expirationDate: DateTime.now().add(Duration(days: 30)),
        expirationTimes: 1000,
      ),
    ),
  ),
));
```

### Asymmetric: Generate KeyPair + Create
```dart
// 1. Genera keypair (async)
final keyPair = await RSACipher.generateKeyPair(bitLength: 2048);

// 2. Crea istanza
final rsa = RSACipher.createFull((
  parent: (
    publicKey: keyPair['publicKey']!,
    privateKey: keyPair['privateKey']!,
    parent: (
      parent: (
        algorithm: CryptoAlgorithm.rsa,
        expirationDate: DateTime.now().add(Duration(days: 365)),
        expirationTimes: null,
      ),
    ),
  ),
));
```

### Key Exchange: Generate + Create
```dart
// 1. Genera keypair per ECDH
final keyPair = await ECDHKeyExchange.generateKeyPair(
  curve: ECCKeyUtils.secp256r1,
);

// 2. Crea istanza
final ecdh = ECDHKeyExchange.createFull((
  parent: (
    algorithm: KeyExchangeAlgorithm.ecdh,
    expirationDate: DateTime.now().add(Duration(hours: 1)),
    expirationTimes: null,
  ),
  publicKey: keyPair['publicKey']!,
  privateKey: keyPair['privateKey']!,
  curve: ECCKeyUtils.secp256r1,
));
```

## All Classes Implemented

| Class | Location | Factory Method |
|-------|----------|---|
| **AESCipher** | `lib/implementations/symmetric/aes_cipher.dart` | `createFull(InputAESCipher)` |
| **ChaCha20Cipher** | `lib/implementations/symmetric/chacha20_cipher.dart` | `createFull(InputChaCha20Cipher)` |
| **DESCipher** | `lib/implementations/symmetric/des_cipher.dart` | `createFull(InputDESCipher)` |
| **RSACipher** | `lib/implementations/asymmetric/prime_based/rsa_cipher.dart` | `createFull(InputRSACipher)` |
| **HMACSign** | `lib/implementations/signed_based/hmac_sign.dart` | `createFull(InputHMACSign)` |
| **RSASignatureCipher** | `lib/implementations/signed_based/rsa_signature_cipher.dart` | `createFull(InputRSASignatureCipher)` |
| **ECDSASign** | `lib/implementations/signed_based/ecdsa_sign.dart` | `createFull(InputECDSASign)` |
| **ECDHKeyExchange** | `lib/implementations/key_exchange/ecdh_key_exchange.dart` | `createFull(InputECDHKeyExchange)` |

## Benefits

✅ **Completamente Dinamico** - Se cambiano i parametri annidati, il factory non richiede modifiche

✅ **Zero Duplicazione** - Solo `generateKey()` e `createFull()` per classe

✅ **Type-Safe** - Accetta direttamente il record Input, Dart fa la validazione

✅ **Flessibile** - Controllo completo su tutti i parametri

✅ **Documentato** - Ogni factory ha docstring esplicativo

## Removed (Cleaned Up)

❌ `create()` - factory generico che annidava parametri
❌ `createWithKey()` / `createWithKeyPair()` - factory intermedi con logica duplicata

## Migration Guide

### Before
```dart
final aes = AESCipher.create(
  expirationDate: DateTime.now().add(Duration(days: 30)),
);
```

### After
```dart
final aes = AESCipher.createFull((
  parent: (
    key: AESCipher.generateKey(),
    parent: (
      parent: (
        algorithm: CryptoAlgorithm.aes,
        expirationDate: DateTime.now().add(Duration(days: 30)),
        expirationTimes: null,
      ),
    ),
  ),
));
```

## Why This Design?

1. **Single Source of Truth** - Il record Input è l'unica fonte di configurazione
2. **No Hidden Logic** - Tutto è visibile e configurabile
3. **Easy to Extend** - Nuovi parametri vengono automaticamente supportati
4. **Testable** - Facile creare test con diversi Input records

---

**Implementazione completata e testata** ✅
