# 🔄 ISymmetric & IAsymmetric: Da Interfaccia a Mixin

## 📋 Cambio di Design

Trasformazione da `abstract interface class` a `mixin` per **ISymmetric** e **IAsymmetric**, permettendo la corretta ereditarietà dell'implementazione di `keyId`.

## 🎯 Motivazione

### ❌ Problema Precedente
- ISymmetric e IAsymmetric come interfacce richiedevano override espliciti di `keyId` in ogni classe
- La Diamond problem in Dart richiedeva override aggiuntivi per ereditare l'implementazione
- Duplicazione di codice per `keyId` in ogni classe concrete

### ✅ Soluzione Nuova
- ISymmetric e IAsymmetric come **mixin** forniscono l'implementazione direttamente
- `with ISymmetric` / `with IAsymmetric` nelle classi concrete eredita automaticamente `keyId`
- Single Source of Truth per l'implementazione di `keyId`

## 📊 Cambio di Design

### ISymmetric

```dart
// ❌ PRIMA: Abstract Interface Class
abstract interface class ISymmetric extends IExpiration implements IKeyId {
  String get key;
  @override
  Digest get keyId => SymmetricKeyUtils.sha256From(key);
}

// ✅ DOPO: Mixin
mixin ISymmetric on IExpiration implements IKeyId {
  String get key;
  @override
  Digest get keyId => SymmetricKeyUtils.sha256From(key);
}
```

### IAsymmetric

```dart
// ❌ PRIMA: Abstract Interface Class
abstract interface class IAsymmetric extends IExpiration implements IKeyId {
  String get publicKey;
  String? get privateKey;
  @override
  Digest get keyId => SymmetricKeyUtils.sha256From(publicKey);
}

// ✅ DOPO: Mixin
mixin IAsymmetric on IExpiration implements IKeyId {
  String get publicKey;
  String? get privateKey;
  @override
  Digest get keyId => SymmetricKeyUtils.sha256From(publicKey);
}
```

## 🔧 Cambio nelle Classi Concrete

### SymmetricCipher

```dart
// ❌ PRIMA
abstract class SymmetricCipher extends Cipher implements ISymmetricCipher {
  // Richiedeva override di keyId
  @override
  int get keyId => key.hashCode;
}

// ✅ DOPO
abstract class SymmetricCipher extends Cipher with ISymmetric
    implements ISymmetricCipher {
  // keyId è ereditato dal mixin ISymmetric automaticamente ✅
}
```

### AsymmetricCipher

```dart
// ❌ PRIMA
abstract class AsymmetricCipher extends Cipher implements IAsymmetricCipher {
  // Richiedeva override di keyId
  @override
  int get keyId => publicKey.hashCode;
}

// ✅ DOPO
abstract class AsymmetricCipher extends Cipher with IAsymmetric
    implements IAsymmetricCipher {
  // keyId è ereditato dal mixin IAsymmetric automaticamente ✅
}
```

## 📝 Pattern di Utilizzo

### Classe Concreta (AESCipher)

```dart
class AESCipher extends SymmetricCipher {
  // Eredita:
  // 1. encrypt/decrypt da Cipher
  // 2. expiration logic da ExpirationBase
  // 3. keyId (SHA-256) dal mixin ISymmetric

  AESCipher(InputAESCipher input) : super(input.parent);
}
```

### Utilizzo

```dart
final aes = AESCipher.createFull((...));
final keyId = aes.keyId; // ✅ SHA-256 della chiave, automaticamente disponibile
```

## 🔗 Gerarchia di Ereditarietà

### Prima (Interfaccia)

```
IExpiration
    ↑
    |
IKeyId
    ↑
    |
ISymmetric (interface)
    ↑
    |
ISymmetricCipher (interface)
    ↑
    |
Cipher
    ↑
    |
SymmetricCipher (class) ← Richiedeva override di keyId
    ↑
    |
AESCipher (class concrete)
```

### Dopo (Mixin)

```
IExpiration
    ↑
    |
IKeyId
    ↑
    |
ISymmetric (mixin) ← Fornisce l'implementazione di keyId
    ↑ (with)
    |
SymmetricCipher extends Cipher with ISymmetric
    ↑
    |
AESCipher (class concrete) ← Eredita keyId automaticamente ✅
```

## ✨ Vantaggi

| Aspetto | Interfaccia | Mixin |
|---------|-------------|-------|
| **Implementazione keyId** | Ogni classe la deve override | Fornita dal mixin |
| **Ereditarietà** | Verticale (extends) | Orizzontale (with) |
| **Duplicazione** | Sì (override in ogni classe) | No (single source of truth) |
| **Chiarezza** | Quale classe fornisce keyId? | Chiaro: il mixin |
| **Composizione** | Complessa | Semplice |
| **Maintainability** | Difficile | Facile |

## 📋 File Modificati

### Interfacce (trasformate in mixin)

```
lib/interfaces/
  ├── i_simmetric.dart              (interface → mixin)
  └── i_asimmetric.dart             (interface → mixin)
```

### Classi Concrete (aggiunto `with`)

```
lib/implementations/partial/
  ├── symmetric_cipher_impl.dart     (implements → with ISymmetric)
  ├── symmetric_sign_impl.dart       (implements → with ISymmetric)
  ├── asymmetric_cipher_impl.dart    (implements → with IAsymmetric)
  └── asymmetric_sign_impl.dart      (implements → with IAsymmetric)
```

## 🔑 Punti Chiave

### 1. Mixin `on` Constraint

```dart
mixin ISymmetric on IExpiration implements IKeyId {
  // Richiede che la classe che usa il mixin estenda IExpiration
  // Garantisce accesso ai metodi di IExpiration (isExpired, etc.)
}
```

### 2. Ordine di Applicazione

```dart
abstract class SymmetricCipher extends Cipher with ISymmetric
    implements ISymmetricCipher {
  // Ordine:
  // 1. Estende Cipher
  // 2. Mescola ISymmetric (fornisce keyId)
  // 3. Implementa ISymmetricCipher (interfaccia pubblica)
}
```

### 3. Accesso ai Getter del Mixin

```dart
class AESCipher extends SymmetricCipher {
  @override
  String get key => _key; // Dal mixin ISymmetric

  // Non serve override di keyId:
  // Viene da ISymmetric automaticamente
}
```

## 🎯 Scenario: Two-Peer Communication

```dart
// Alice crea una chiave AES
final aes = AESCipher.createFull((
  parent: (key: AESCipher.generateKey(), parent: (...)),
));

// Ottiene il keyId (SHA-256 della chiave)
final keyId = aes.keyId; // "a3f1b2c4..." ← dal mixin ISymmetric ✅

// Bob fa lo stesso e ottiene lo stesso keyId per la stessa chiave
final aes2 = AESCipher.createFull((
  parent: (key: key, parent: (...)),
));

assert(aes.keyId == aes2.keyId); // ✅ VERO - implementazione del mixin
```

## 🔒 Proprietà Preservate

✅ **SHA-256 hashing** - Mantenuto dal mixin
✅ **Deterministic** - Stesso valore ogni volta
✅ **Sicuro** - Funzione crittografica
✅ **Type-safe** - Ritorna `Digest`

## 📚 Benefici per il Codebase

### Before (Interfaccia)
- Ogni classe concreta doveva implementare `keyId`
- Rischio di inconsistenza nell'implementazione
- Duplicazione di codice
- Difficile manutenzione

### After (Mixin)
- Implementazione centralizzata nel mixin
- Garantita coerenza
- Nessuna duplicazione
- Facile da mantenere e estendere

## 🧪 Verifica

```bash
dart analyze lib/interfaces/ lib/implementations/partial/
# ✅ No issues found!
```

---

**Update Completato!** 🎉

ISymmetric e IAsymmetric sono ora mixin che forniscono automaticamente
l'implementazione di `keyId` a tutte le classi che li usano.
