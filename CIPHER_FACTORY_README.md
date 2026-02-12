# 🏭 CipherFactory - Centralized Cipher Creation

Una **factory class centralizzata** che fornisce un'API uniforme per la creazione di tutti i tipi di cipher, signature e key exchange basandosi su enum di algoritmi.

## 📚 Panoramica

`CipherFactory` elimina la necessità di ricordare nomi di classi specifiche. Basta passare un enum del tipo di algoritmo e i parametri, e la factory ritorna l'implementazione corretta dell'interfaccia.

## 🎯 Vantaggi

✅ **Interfaccia Unificata** - API consistente per tutti i tipi di crypto
✅ **Type-Safe** - Completo supporto per i record typizzati di Dart
✅ **Facile da Estendere** - Aggiungere nuovi algoritmi è immediato
✅ **Documentato** - Docstring espliciti per ogni metodo
✅ **Enum-Based** - Sfrutta gli enum di `CryptoAlgorithm`

## 🚀 Utilizzo

### 1️⃣ Symmetric Ciphers

```dart
import 'package:cryptdart/cryptdart.dart';

// AES Cipher
final aesKey = AESCipher.generateKey();
final aes = CipherFactory.symmetric(
  SymmetricCipherAlgorithm.aes,
  (
    key: aesKey,
    parent: (
      parent: (
        expirationDate: DateTime.now().add(Duration(days: 30)),
        expirationTimes: 1000,
      ),
    ),
  ),
);

// DES Cipher
final desKey = DESCipher.generateKey();
final des = CipherFactory.symmetric(
  SymmetricCipherAlgorithm.des,
  (
    key: desKey,
    parent: (
      parent: (
        expirationDate: DateTime.now().add(Duration(days: 7)),
        expirationTimes: null,
      ),
    ),
  ),
);
```

### 2️⃣ ChaCha20 Cipher (con Nonce)

ChaCha20 richiede un **nonce** aggiuntivo, quindi usa il metodo specializzato:

```dart
final chachaKey = ChaCha20Cipher.generateKey();
final chachaNonce = ChaCha20Cipher.generateNonce();

final chacha = CipherFactory.chacha20(
  (
    parent: (
      key: chachaKey,
      parent: (
        parent: (
          expirationDate: null,
          expirationTimes: 500,
        ),
      ),
    ),
    nonce: chachaNonce,
  ),
);
```

### 3️⃣ Asymmetric Ciphers (RSA)

```dart
// Genera keypair
final keyPair = await RSACipher.generateKeyPair(bitLength: 2048);

// Crea cipher tramite factory
final rsa = CipherFactory.asymmetric(
  AsymmetricCipherAlgorithm.rsa,
  (
    publicKey: keyPair['publicKey']!,
    privateKey: keyPair['privateKey']!,
    parent: (
      parent: (
        expirationDate: DateTime.now().add(Duration(days: 365)),
        expirationTimes: null,
      ),
    ),
  ),
);
```

### 4️⃣ Symmetric Signatures (HMAC)

```dart
final hmacKey = HMACSign.generateKey();

final hmac = CipherFactory.symmetricSign(
  SymmetricSignAlgorithm.hmac,
  (
    key: hmacKey,
    parent: (
      parent: (
        expirationDate: DateTime.now().add(Duration(hours: 24)),
        expirationTimes: 5000,
      ),
    ),
  ),
);

// Uso
final data = [72, 101, 108, 108, 111]; // "Hello"
final signature = hmac.sign(data);
final isValid = hmac.verify(data, signature);
```

### 5️⃣ Asymmetric Signatures

```dart
// RSA Signature
final rsaSigKeyPair = await RSASignatureCipher.generateKeyPair(bitLength: 2048);

final rsaSig = CipherFactory.asymmetricSign(
  AsymmetricSignAlgorithm.rsaSignature,
  (
    publicKey: rsaSigKeyPair['publicKey']!,
    privateKey: rsaSigKeyPair['privateKey']!,
    parent: (
      parent: (
        expirationDate: DateTime.now().add(Duration(days: 365)),
        expirationTimes: null,
      ),
    ),
  ),
);

// ECDSA Signature
final ecdsaSigKeyPair = await ECDSASign.generateKeyPair();

final ecdsaSig = CipherFactory.asymmetricSign(
  AsymmetricSignAlgorithm.ecdsa,
  (
    publicKey: ecdsaSigKeyPair['publicKey']!,
    privateKey: ecdsaSigKeyPair['privateKey']!,
    parent: (
      parent: (
        expirationDate: DateTime.now().add(Duration(days: 30)),
        expirationTimes: null,
      ),
    ),
  ),
);
```

### 6️⃣ Key Exchange (ECDH)

```dart
final ecdhKeyPair = await ECDHKeyExchange.generateKeyPair();

final ecdh = ECDHKeyExchange.createFull((
  parent: (
    algorithm: KeyExchangeAlgorithm.ecdh,
    expirationDate: DateTime.now().add(Duration(hours: 1)),
    expirationTimes: null,
  ),
  publicKey: ecdhKeyPair['publicKey']!,
  privateKey: ecdhKeyPair['privateKey']!,
  curve: '', // Empty string per default curve
));
```

## 📋 Metodi Disponibili

| Metodo | Parametri | Ritorno |
|--------|-----------|---------|
| `symmetric()` | `SymmetricCipherAlgorithm`, `InputSymmetricCipher` | `ISymmetricCipher` |
| `chacha20()` | `InputChaCha20Cipher` | `ISymmetricCipher` |
| `asymmetric()` | `AsymmetricCipherAlgorithm`, `InputAsymmetricCipher` | `IAsymmetricCipher` |
| `symmetricSign()` | `SymmetricSignAlgorithm`, `InputSymmetricSign` | `ISymmetricSign` |
| `asymmetricSign()` | `AsymmetricSignAlgorithm`, `InputAsymmetricSign` | `IAsymmetricSign` |
| `ecdh()` | Input record ECDH | `IKeyExchange` |

## 🔐 Algoritmi Supportati

### Symmetric Ciphers
- ✅ **AES** - Advanced Encryption Standard
- ✅ **DES** - Data Encryption Standard
- ✅ **ChaCha20** - Stream cipher (richiede nonce)

### Asymmetric Ciphers
- ✅ **RSA** - Rivest-Shamir-Adleman
- ❌ **ECDSA** - (Solo per signature, non cipher)

### Symmetric Signatures
- ✅ **HMAC** - Hash-based Message Authentication Code

### Asymmetric Signatures
- ✅ **RSA Signature** - Firma digitale RSA
- ✅ **ECDSA** - Elliptic Curve Digital Signature Algorithm

### Key Exchange
- ✅ **ECDH** - Elliptic Curve Diffie-Hellman

## 📝 Struttura dei Record Input

Ogni cipher accetta un record `Input` nidificato che segue questa struttura:

```
InputXXXCipher = ({
  InputSymmetricCipher parent,
})

InputSymmetricCipher = ({
  InputCipher parent,
  String key,
})

InputCipher = ({
  InputExpirationBase parent,
})

InputExpirationBase = ({
  DateTime? expirationDate,
  int? expirationTimes,
})
```

## 🎁 Esempi Completi

Vedi [example/cipher_factory_example.dart](example/cipher_factory_example.dart) per un esempio completo che dimostra:
- Creazione di tutti i tipi di cipher
- Generazione di chiavi
- Firma e verifica
- Gestione della scadenza

## 🔄 Migrazione

Se stai usando i metodi `createFull()` direttamente sulle classi, la factory fornisce lo stesso risultato con un'API più consistente:

### Before (Specifico per classe)
```dart
final aes = AESCipher.createFull((
  parent: (
    key: key,
    parent: (parent: (expirationDate: ..., expirationTimes: ...)),
  ),
));
```

### After (Generico tramite factory)
```dart
final aes = CipherFactory.symmetric(
  SymmetricCipherAlgorithm.aes,
  (
    key: key,
    parent: (parent: (expirationDate: ..., expirationTimes: ...)),
  ),
);
```

## 📄 File

- **Implementazione**: `lib/factories/cipher_factory.dart`
- **Esempio Completo**: `example/cipher_factory_example.dart`
- **Documentazione Factory Methods**: `FACTORY_METHODS_FULL.md`

## ✨ Note Importanti

1. **Expiration Management**: Tutti i cipher supportano scadenza per data e numero di utilizzi
2. **Key Generation**: Usa i metodi `generateKey()` e `generateKeyPair()` delle singole classi
3. **Type Safety**: I record sono fully typizzati, Dart valida i parametri
4. **Nonce per ChaCha20**: Deve essere generato separatamente con `ChaCha20Cipher.generateNonce()`
5. **ECDSA**: Solo per signature, non per cipher asincroni

---

**Pronto a usare la factory!** 🚀
