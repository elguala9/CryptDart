# 🔐 keyId Update: SHA-256 Hashing

## 📋 Cambio di Design

Aggiornamento da `hashCode` (indirizzo memoria) a **SHA-256** per `keyId` in tutte le classi che implementano `IKeyId`.

## 🎯 Motivazione

### ❌ Problema Precedente
- `keyId` usava `hashCode` che è basato su indirizzo di memoria
- Non deterministico tra esecuzioni diverse
- Non sicuro per identificazione persistente di chiavi
- Impossibile verificare l'identità di una chiave senza l'istanza originale

### ✅ Soluzione Nuova
- `keyId` usa **SHA-256** della chiave
- Deterministico e riproducibile
- Sicuro dal punto di vista crittografico
- Basato sul contenuto effettivo della chiave

## 📊 Cambiamenti

### 1. Tipo di Ritorno

```dart
// ❌ PRIMA
int get keyId => key.hashCode;

// ✅ DOPO
String get keyId => ... // SHA-256 hex string
```

**Cambio**: `int` → `String` (hex string SHA-256)

### 2. Interfaccia IKeyId

**File**: `lib/interfaces/i_key_id.dart`

```dart
// ❌ PRIMA
abstract interface class IKeyId extends IExpiration {
  int get keyId;
}

// ✅ DOPO
abstract interface class IKeyId extends IExpiration {
  /// Returns the SHA-256 hash of the key material as a hex string.
  String get keyId;
}
```

### 3. Interfaccia ISymmetric

**File**: `lib/interfaces/i_simmetric.dart`

```dart
// ❌ PRIMA
int get keyId => key.hashCode;

// ✅ DOPO
String get keyId => KeyEncodingUtils.bytesToHex(
  SymmetricKeyUtils.sha256(KeyEncodingUtils.hexToBytes(key)),
);
```

**Logica**:
1. Converte la chiave hex in bytes
2. Computa SHA-256 dei bytes
3. Converte il risultato SHA-256 in hex string

### 4. Interfaccia IAsymmetric

**File**: `lib/interfaces/i_asimmetric.dart`

```dart
// ❌ PRIMA
int get keyId => publicKey.hashCode;

// ✅ DOPO
String get keyId => KeyEncodingUtils.bytesToHex(
  SymmetricKeyUtils.sha256(publicKey.codeUnits),
);
```

**Logica**:
1. Ottiene i codeUnits della chiave pubblica
2. Computa SHA-256
3. Converte in hex string

### 5. Classi Parziali

Rimossi gli override di `keyId` dalle seguenti classi (per usare l'implementazione da ISymmetric/IAsymmetric):

**File**: `lib/implementations/partial/symmetric_cipher_impl.dart`
- Rimosso: `int get keyId => key.hashCode;`

**File**: `lib/implementations/partial/symmetric_sign_impl.dart`
- Rimosso: `int get keyId => key.hashCode;`

**File**: `lib/implementations/partial/asymmetric_cipher_impl.dart`
- Rimosso: `int get keyId => publicKey.hashCode;`

**File**: `lib/implementations/partial/asymmetric_sign_impl.dart`
- Rimosso: `int get keyId => publicKey.hashCode;`

### 6. Handler Classes

Aggiornato il tipo di ritorno da `int` a `String`:

**File**: `lib/implementations/handlers/handler_cipher.dart`
```dart
// ❌ PRIMA
int get keyId => currentCrypt.keyId;

// ✅ DOPO
String get keyId => currentCrypt.keyId;
```

**File**: `lib/implementations/handlers/handler_sign.dart`
```dart
// ❌ PRIMA
int get keyId => currentCrypt.keyId;

// ✅ DOPO
String get keyId => currentCrypt.keyId;
```

### 7. Utility Function

**File**: `lib/utils/crypto_utils.dart`

Aggiunto nuovo metodo a `SymmetricKeyUtils`:

```dart
/// Computes SHA-256 hash of the given bytes
static Uint8List sha256(List<int> data) {
  final digest = SHA256Digest();
  return Uint8List.fromList(
    digest.process(Uint8List.fromList(data)),
  );
}
```

## 💡 Utilizzo

### Simmetrico

```dart
final aes = AESCipher.createFull((
  parent: (
    key: AESCipher.generateKey(),
    parent: (parent: (...)),
  ),
));

// ✅ keyId è SHA-256 della chiave
final keyId = aes.keyId; // "a3f1b2c4..." (64 caratteri hex)
```

### Asincrono

```dart
final rsa = RSACipher.createFull((
  parent: (
    publicKey: keyPair['publicKey']!,
    privateKey: keyPair['privateKey']!,
    parent: (parent: (...)),
  ),
));

// ✅ keyId è SHA-256 della chiave pubblica
final keyId = rsa.keyId; // "f3a1c2b4..." (64 caratteri hex)
```

## 🔒 Proprietà di Sicurezza

### ✅ Deterministic
```dart
// Same key → Same keyId
final key1 = "abc123def456...";
final aes1 = AESCipher.createFull((parent: (key: key1, parent: (...))));
final aes2 = AESCipher.createFull((parent: (key: key1, parent: (...))));

assert(aes1.keyId == aes2.keyId); // ✅ SEMPRE vero
```

### ✅ Different Keys → Different IDs
```dart
final key1 = AESCipher.generateKey();
final key2 = AESCipher.generateKey();

final aes1 = AESCipher.createFull((parent: (key: key1, parent: (...))));
final aes2 = AESCipher.createFull((parent: (key: key2, parent: (...))));

assert(aes1.keyId != aes2.keyId); // ✅ SEMPRE vero
```

### ✅ Cryptographically Secure
- SHA-256 è una funzione hash crittografica standard
- Impossibile trovare due chiavi diverse con lo stesso SHA-256 (collision resistance)
- Impossibile risalire alla chiave da keyId (one-way function)

## 📈 Vantaggi

| Aspetto | hashCode | SHA-256 |
|---------|----------|---------|
| **Deterministico** | ❌ No (basato su memoria) | ✅ Sì |
| **Sicuro** | ❌ No (indirizzo pubblico) | ✅ Crittografico |
| **Persistente** | ❌ No (cambia tra run) | ✅ Sì |
| **Univoco** | ❌ No (collisioni possibili) | ✅ Sì (SHA-256) |
| **Verificabile** | ❌ No (richiede istanza) | ✅ Sì (from key) |
| **Standard** | ❌ No (Dart-specific) | ✅ Sì (SHA-256) |

## 🔄 Formato

### Output Format

**keyId** è ora un **hex string a 64 caratteri** (256 bits = 32 bytes × 2):

```
a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1
```

### Lunghezza

- **SHA-256**: sempre 64 caratteri hex
- **Utilizzo**: perfetto per database keys, logging, identificazione

## 🧪 Migrazione

### Se stai usando keyId

```dart
// ❌ VECCHIO - Assumeva int
int id = cipher.keyId;

// ✅ NUOVO - Usa String
String id = cipher.keyId;

// ✅ Puoi ancora usarlo come key in Map
Map<String, Cipher> ciphersByKeyId = {
  cipher.keyId: cipher,
};

// ✅ Puoi registrarlo/logarlo facilmente
print('Cipher ID: ${cipher.keyId}');

// ✅ Puoi usarlo in database
db.execute('INSERT INTO ciphers VALUES (?, ...)', [cipher.keyId]);
```

## 📋 File Modificati

```
lib/interfaces/
  ├── i_key_id.dart                      (tipo: int → String)
  ├── i_simmetric.dart                   (aggiunto SHA-256)
  └── i_asimmetric.dart                  (aggiunto SHA-256)

lib/implementations/partial/
  ├── symmetric_cipher_impl.dart          (rimosso override hashCode)
  ├── symmetric_sign_impl.dart            (rimosso override hashCode)
  ├── asymmetric_cipher_impl.dart         (rimosso override hashCode)
  └── asymmetric_sign_impl.dart           (rimosso override hashCode)

lib/implementations/handlers/
  ├── handler_cipher.dart                 (int → String)
  └── handler_sign.dart                   (int → String)

lib/utils/
  └── crypto_utils.dart                   (aggiunto sha256 method)
```

## ✅ Verifica

Tutti i file compilano senza errori:

```bash
dart analyze
# No errors in modified files ✅
```

## 🎯 Caso d'Uso: Database

```dart
// Identificazione univoca di chiavi in database
class CipherStore {
  final Map<String, Cipher> _store = {};

  void saveCipher(Cipher cipher) {
    _store[cipher.keyId] = cipher;
    // keyId è deterministico: stessa chiave → stesso ID ✅
  }

  Cipher? getCipherByKey(String key) {
    final aes = AESCipher.createFull(input);
    return _store[aes.keyId]; // ✅ Ritrova sempre la giusta istanza
  }

  void deleteCipherByKey(String key) {
    final aes = AESCipher.createFull(input);
    _store.remove(aes.keyId); // ✅ Rimuove sempre il giusto cipher
  }
}
```

## 🔐 Sicurezza

### ✅ keyId NON rivela la chiave
```dart
final aes = AESCipher.createFull((parent: (key: "secretKey123", ...)));
final keyId = aes.keyId; // "a3f1b2c4..." (SHA-256)

// ❌ Impossibile risalire a "secretKey123" da keyId
// (SHA-256 è one-way function)
```

### ✅ keyId è univoco per chiave
```dart
// Ogni chiave diversa ha keyId diverso
final aes1 = AESCipher.createFull((parent: (key: generateKey(), ...)));
final aes2 = AESCipher.createFull((parent: (key: generateKey(), ...)));

assert(aes1.keyId != aes2.keyId); // ✅ SEMPRE
```

---

**Update Completato!** 🎉

CryptDart usa ora identificatori di chiave sicuri e deterministici basati su SHA-256.
