# 📚 CryptDart Guides Index

Guida completa a tutti i documenti e gli esempi di CryptDart per factory methods, cipher creation, e key exchange.

## 🎯 Indice Principale

### 🏭 **Factory Methods & Cipher Creation**

#### 📖 Documentazione
1. **[CIPHER_FACTORY_README.md](CIPHER_FACTORY_README.md)** ⭐ **START HERE**
   - Panoramica della CipherFactory
   - Vantaggi e utilizzo
   - Tutti i tipi di cipher supportati
   - Esempi di base per ogni algoritmo

2. **[CIPHER_FACTORY_IMPLEMENTATION.md](CIPHER_FACTORY_IMPLEMENTATION.md)**
   - Dettagli tecnici dell'implementazione
   - Architettura completa
   - Record Input nidificati
   - Copertura algoritmi

3. **[FACTORY_METHODS_FULL.md](FACTORY_METHODS_FULL.md)**
   - Design pattern dei factory methods
   - `createFull()` pattern
   - Benefici dell'approccio
   - Migrazione guide

#### 💻 Codice di Esempio
1. **[example/cipher_factory_example.dart](example/cipher_factory_example.dart)**
   - Esempio completo della CipherFactory
   - Dimostrazione di:
     - Symmetric ciphers (AES, DES, ChaCha20)
     - Asymmetric ciphers (RSA)
     - Signatures (HMAC, RSA, ECDSA)
     - Key Exchange (ECDH)

#### 📝 Implementazione
- **[lib/factories/cipher_factory.dart](lib/factories/cipher_factory.dart)** - Factory class

---

### 🔐 **Key Exchange (ECDH)**

#### 📖 Documentazione
1. **[KEY_EXCHANGE_GUIDE.md](KEY_EXCHANGE_GUIDE.md)** ⭐ **START HERE FOR KEY EXCHANGE**
   - Spiegazione ECDH
   - Flusso di base tra due peer
   - Metodi disponibili
   - Parametri curve
   - Considerazioni di sicurezza
   - Casi d'uso reali

#### 💻 Codice di Esempio
1. **[example/key_exchange_two_peers_example.dart](example/key_exchange_two_peers_example.dart)**
   - **Esempio COMPLETO tra Alice e Bob**
   - Tutte le 8 fasi del key exchange:
     1. Generazione chiavi
     2. Creazione istanze ECDH
     3. Scambio chiavi pubbliche
     4. Calcolo shared secret
     5. Verifica identità
     6. Utilizzo per crittografia
     7. Scambio messaggi criptati
     8. Comunicazione bidirezionale

#### 📝 Implementazione
- **[lib/implementations/key_exchange/ecdh_key_exchange.dart](lib/implementations/key_exchange/ecdh_key_exchange.dart)** - Classe ECDH

---

## 🚀 Quick Start Guide

### Per Chi Inizia con la Factory

```
1. Leggi: CIPHER_FACTORY_README.md
2. Guarda: example/cipher_factory_example.dart
3. Usa: CipherFactory.symmetric(...), .asymmetric(...), ecc.
```

### Per Chi Vuole Fare Key Exchange

```
1. Leggi: KEY_EXCHANGE_GUIDE.md
2. Guarda: example/key_exchange_two_peers_example.dart
3. Usa: ECDHKeyExchange.generateKeyPair() e .generateSharedSecret()
```

### Per Chi Vuole Tutto

```
1. Leggi: CIPHER_FACTORY_README.md
2. Leggi: KEY_EXCHANGE_GUIDE.md
3. Guarda: example/cipher_factory_example.dart
4. Guarda: example/key_exchange_two_peers_example.dart
5. Leggi i dettagli: CIPHER_FACTORY_IMPLEMENTATION.md
6. Esplora il codice: lib/factories/cipher_factory.dart
```

---

## 📋 Tabella Riassuntiva

| Argomento | Documento | Tipo | Livello |
|-----------|-----------|------|---------|
| **Factory Overview** | CIPHER_FACTORY_README.md | 📖 Guida | Beginner |
| **Factory Details** | CIPHER_FACTORY_IMPLEMENTATION.md | 📖 Tecnico | Intermediate |
| **Factory Methods** | FACTORY_METHODS_FULL.md | 📖 Design | Advanced |
| **Factory Example** | example/cipher_factory_example.dart | 💻 Codice | Beginner |
| **Key Exchange Overview** | KEY_EXCHANGE_GUIDE.md | 📖 Guida | Beginner |
| **Key Exchange Example** | example/key_exchange_two_peers_example.dart | 💻 Codice | Beginner |

---

## 🎯 Casi d'Uso

### ✅ Voglio creare un AES cipher
```
Documento: CIPHER_FACTORY_README.md → Symmetric Ciphers section
Esempio: example/cipher_factory_example.dart → SYMMETRIC CIPHERS section
```

### ✅ Voglio creare un RSA cipher
```
Documento: CIPHER_FACTORY_README.md → Asymmetric Ciphers section
Esempio: example/cipher_factory_example.dart → ASYMMETRIC CIPHERS section
```

### ✅ Voglio fare HMAC signature
```
Documento: CIPHER_FACTORY_README.md → Symmetric Signatures section
Esempio: example/cipher_factory_example.dart → SYMMETRIC SIGNATURES section
```

### ✅ Voglio fare key exchange tra due peer
```
Documento: KEY_EXCHANGE_GUIDE.md → Sezione "Esempio Completo: Due Peer"
Esempio: example/key_exchange_two_peers_example.dart
```

### ✅ Voglio integrare tutto insieme
```
Documentazione: Tutti i guide sopra
Esempi: Entrambi gli example files
```

---

## 📚 Struttura Documentazione

```
CryptDart/
├── CIPHER_FACTORY_README.md          ⭐ Start here for Factory
├── CIPHER_FACTORY_IMPLEMENTATION.md   📖 Technical details
├── FACTORY_METHODS_FULL.md            📖 Design patterns
├── KEY_EXCHANGE_GUIDE.md              ⭐ Start here for ECDH
├── GUIDES_INDEX.md                    📍 Questo file
│
├── lib/factories/
│   └── cipher_factory.dart            🔧 Factory implementation
│
├── lib/implementations/
│   ├── symmetric/
│   │   ├── aes_cipher.dart
│   │   ├── des_cipher.dart
│   │   └── chacha20_cipher.dart
│   ├── asymmetric/
│   │   └── prime_based/rsa_cipher.dart
│   ├── signed_based/
│   │   ├── hmac_sign.dart
│   │   ├── rsa_signature_cipher.dart
│   │   └── ecdsa_sign.dart
│   └── key_exchange/
│       └── ecdh_key_exchange.dart     🔧 ECDH implementation
│
└── example/
    ├── cipher_factory_example.dart    💻 Factory demo
    └── key_exchange_two_peers_example.dart  💻 ECDH demo
```

---

## 🔑 Metodi Principali

### CipherFactory

```dart
// Symmetric ciphers
CipherFactory.symmetric(SymmetricCipherAlgorithm, InputSymmetricCipher)
CipherFactory.chacha20(InputChaCha20Cipher)

// Asymmetric ciphers
CipherFactory.asymmetric(AsymmetricCipherAlgorithm, InputAsymmetricCipher)

// Signatures
CipherFactory.symmetricSign(SymmetricSignAlgorithm, InputSymmetricSign)
CipherFactory.asymmetricSign(AsymmetricSignAlgorithm, InputAsymmetricSign)

// Key Exchange
CipherFactory.ecdh(InputECDHKeyExchange)
```

### ECDHKeyExchange

```dart
// Generate keys
ECDHKeyExchange.generateKeyPair({curve})

// Create instance
ECDHKeyExchange.createFull(InputECDHKeyExchange)

// Compute shared secret
ecdh.generateSharedSecret(otherPublicKey)

// Get public key
ecdh.getPublicKey()
```

---

## 💡 Best Practices

### ✅ DO

- ✅ Usa la `CipherFactory` per un'interfaccia consistente
- ✅ Genera nuove chiavi per ogni sessione
- ✅ Trasmetti solo chiavi pubbliche
- ✅ Usa expiration dates per security
- ✅ Verifica identità dei peer (firmature)
- ✅ Usa curve forti per ECDH (secp384r1 o secp521r1)

### ❌ DON'T

- ❌ Non trasmettere mai chiavi private
- ❌ Non riutilizzare chiavi tra sessioni
- ❌ Non ignorare expiration checks
- ❌ Non usare curve deboli
- ❌ Non saltare verifica identità

---

## 📞 Quick Reference

### Generare una chiave
```dart
final key = AESCipher.generateKey();
final keyPair = await RSACipher.generateKeyPair();
```

### Creare un cipher
```dart
final aes = CipherFactory.symmetric(
  SymmetricCipherAlgorithm.aes,
  (key: key, parent: (...)),
);
```

### Fare key exchange
```dart
final secret = await ecdh.generateSharedSecret(otherPublicKey);
```

### Encriptare/Decriptare
```dart
final encrypted = cipher.encrypt(data);
final decrypted = cipher.decrypt(encrypted);
```

### Firmare/Verificare
```dart
final signature = sign.sign(data);
final valid = sign.verify(data, signature);
```

---

## 🎓 Learning Path

### Livello 1: Beginner
1. Leggi CIPHER_FACTORY_README.md
2. Esegui example/cipher_factory_example.dart
3. Prova a creare un semplice AES cipher

### Livello 2: Intermediate
1. Leggi KEY_EXCHANGE_GUIDE.md
2. Esegui example/key_exchange_two_peers_example.dart
3. Implementa key exchange tra due componenti

### Livello 3: Advanced
1. Leggi CIPHER_FACTORY_IMPLEMENTATION.md
2. Leggi FACTORY_METHODS_FULL.md
3. Esplora il codice in lib/factories/
4. Implementa handshake con autenticazione

---

## 🔗 File Correlati

### Configurazione
- `pubspec.yaml` - Dipendenze
- `bin/generate_barrel.dart` - Barrel file generator

### Test
- `test/` - Test unitari

### Altro
- `README.md` - README principale
- `CHANGELOG.md` - Changelog

---

## ✨ Novità in Questa Release

- ✅ CipherFactory centralizzata
- ✅ Supporto completo ECDH
- ✅ KEY_EXCHANGE_GUIDE con esempio two-peers
- ✅ Documentazione completa
- ✅ Esempi eseguibili

---

**Pronto a cominciare? Scegli il tuo percorso di apprendimento sopra!** 🚀
