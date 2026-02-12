# 🔐 ECDH Key Exchange Guide - Due Peer

Una guida completa su come fare il **key exchange tra due peer** usando **ECDH (Elliptic Curve Diffie-Hellman)** in CryptDart.

## 📚 Cos'è ECDH?

**ECDH (Elliptic Curve Diffie-Hellman)** è un protocollo di key exchange che permette a due peer di stabilire un **secret condiviso** su un canale non sicuro, senza scambiarsi effettivamente la chiave privata.

### 🔄 Flusso di Base

```
┌──────────────┐                    ┌──────────────┐
│   PEER A     │                    │   PEER B     │
│              │                    │              │
│ 1. Gen keys  │                    │ 1. Gen keys  │
│    privA     │                    │    privB     │
│    pubA      │                    │    pubB      │
│              │                    │              │
│ 2. Scambia   │──── pubA ────→     │ 2. Riceve    │
│    pubA      │                    │    pubA      │
│              │                    │              │
│              │     ← ─── pubB ───│ 3. Scambia   │
│ 3. Riceve    │                    │    pubB      │
│    pubB      │                    │              │
│              │                    │              │
│ 4. Calcola   │                    │ 4. Calcola   │
│    secret =  │                    │    secret =  │
│   ECDH(privA │                    │   ECDH(privB │
│   + pubB)    │                    │   + pubA)    │
│              │                    │              │
│   SONO UGUALI! ← ─── IDENTICI ─→ │   SONO UGUALI!
│              │                    │              │
└──────────────┘                    └──────────────┘
```

## 🎯 Metodi Principali

### 1. **Generazione Chiavi**

```dart
// Genera una nuova coppia di chiavi
final keyPair = await ECDHKeyExchange.generateKeyPair();

// Oppure con curva specifica
final keyPair = await ECDHKeyExchange.generateKeyPair(
  curve: ECCKeyUtils.secp384r1,  // Curve alternative: secp256r1, secp384r1, etc.
);

// Result
print(keyPair['publicKey']);   // Chiave pubblica (da scambiare)
print(keyPair['privateKey']);  // Chiave privata (MANTIENI SEGRETA!)
```

### 2. **Creazione Istanza ECDH**

```dart
final ecdh = ECDHKeyExchange.createFull((
  parent: (
    algorithm: KeyExchangeAlgorithm.ecdh,
    expirationDate: DateTime.now().add(Duration(hours: 1)),
    expirationTimes: null,
  ),
  publicKey: keyPair['publicKey']!,
  privateKey: keyPair['privateKey']!,
  curve: '', // Empty string per default curve (secp256r1)
));
```

### 3. **Generazione Shared Secret**

```dart
// Ricevi la chiave pubblica dell'altro peer
final otherPeerPublicKey = '...'; // Ricevuto dall'altro peer

// Genera il secret condiviso
final sharedSecret = await ecdh.generateSharedSecret(otherPeerPublicKey);

print('Shared Secret: $sharedSecret');  // Hex string (identico su entrambi i peer)
```

### 4. **Ottieni la Tua Chiave Pubblica**

```dart
final myPublicKey = ecdh.getPublicKey();
// Invia questa a l'altro peer
```

## 🌐 Esempio Completo: Due Peer

Questo esempio mostra come due peer (Alice e Bob) eseguono il key exchange:

```dart
import 'package:cryptdart/cryptdart.dart';

void main() async {
  print('🔐 ECDH Key Exchange - Alice & Bob\n');

  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 1: INITIALIZATION
  // ════════════════════════════════════════════════════════════════════════════

  print('📍 PHASE 1: Generazione delle chiavi\n');

  // Alice genera la sua coppia di chiavi
  print('👤 Alice: Generando coppia di chiavi...');
  final aliceKeyPair = await ECDHKeyExchange.generateKeyPair();
  final alicePublicKey = aliceKeyPair['publicKey']!;
  final alicePrivateKey = aliceKeyPair['privateKey']!;
  print('✅ Alice chiave pubblica pronta\n');

  // Bob genera la sua coppia di chiavi
  print('👤 Bob: Generando coppia di chiavi...');
  final bobKeyPair = await ECDHKeyExchange.generateKeyPair();
  final bobPublicKey = bobKeyPair['publicKey']!;
  final bobPrivateKey = bobKeyPair['privateKey']!;
  print('✅ Bob chiave pubblica pronta\n');

  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 2: KEY EXCHANGE SETUP
  // ════════════════════════════════════════════════════════════════════════════

  print('📍 PHASE 2: Creazione istanze ECDH\n');

  // Crea istanza ECDH per Alice
  final aliceEcdh = ECDHKeyExchange.createFull((
    parent: (
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(hours: 1)),
      expirationTimes: null,
    ),
    publicKey: alicePublicKey,
    privateKey: alicePrivateKey,
    curve: '',
  ));
  print('✅ Alice ECDH istanza creata');

  // Crea istanza ECDH per Bob
  final bobEcdh = ECDHKeyExchange.createFull((
    parent: (
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(hours: 1)),
      expirationTimes: null,
    ),
    publicKey: bobPublicKey,
    privateKey: bobPrivateKey,
    curve: '',
  ));
  print('✅ Bob ECDH istanza creata\n');

  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 3: PUBLIC KEY EXCHANGE (Over Insecure Channel)
  // ════════════════════════════════════════════════════════════════════════════

  print('📍 PHASE 3: Scambio chiavi pubbliche (su canale insicuro)\n');

  print('🔄 Alice invia la sua chiave pubblica a Bob');
  print('   Lunghezza: ${alicePublicKey.length} caratteri');
  print('   Primi 50 caratteri: ${alicePublicKey.substring(0, 50)}...\n');

  print('🔄 Bob invia la sua chiave pubblica ad Alice');
  print('   Lunghezza: ${bobPublicKey.length} caratteri');
  print('   Primi 50 caratteri: ${bobPublicKey.substring(0, 50)}...\n');

  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 4: SHARED SECRET COMPUTATION
  // ════════════════════════════════════════════════════════════════════════════

  print('📍 PHASE 4: Calcolo del shared secret (localmente, non scambiato)\n');

  // Alice calcola il shared secret usando la chiave pubblica di Bob
  print('👤 Alice: Calcolando shared secret con chiave pubblica di Bob...');
  final aliceSharedSecret = await aliceEcdh.generateSharedSecret(bobPublicKey);
  print('✅ Shared Secret Alice: ${aliceSharedSecret.substring(0, 32)}...\n');

  // Bob calcola il shared secret usando la chiave pubblica di Alice
  print('👤 Bob: Calcolando shared secret con chiave pubblica di Alice...');
  final bobSharedSecret = await bobEcdh.generateSharedSecret(alicePublicKey);
  print('✅ Shared Secret Bob: ${bobSharedSecret.substring(0, 32)}...\n');

  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 5: VERIFICATION
  // ════════════════════════════════════════════════════════════════════════════

  print('📍 PHASE 5: Verifica che i shared secret sono identici\n');

  final secretsMatch = aliceSharedSecret == bobSharedSecret;

  if (secretsMatch) {
    print('✅ ✅ ✅ SUCCESSO! ✅ ✅ ✅');
    print('I shared secret di Alice e Bob sono IDENTICI!');
    print('Lunghezza secret: ${aliceSharedSecret.length} caratteri');
    print('Secret completo:');
    print('$aliceSharedSecret\n');
  } else {
    print('❌ ERRORE: I shared secret non coincidono!');
    print('Alice: $aliceSharedSecret');
    print('Bob:   $bobSharedSecret');
  }

  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 6: USE THE SHARED SECRET
  // ════════════════════════════════════════════════════════════════════════════

  print('📍 PHASE 6: Utilizzo del shared secret per crittografia\n');

  if (secretsMatch) {
    // Ora Alice e Bob possono usare il shared secret come chiave
    // per cipher simmetrici (AES, ChaCha20, ecc.)

    print('💡 Ora Alice e Bob possono usare il shared secret per:');
    print('   - Crittografia simmetrica con AES');
    print('   - Scambio sicuro di messaggi');
    print('   - Derivazione di chiavi specifiche\n');

    // Esempio: usare il shared secret come chiave AES
    print('📌 Esempio: Usare il secret come chiave AES\n');

    // Il shared secret deve essere della lunghezza corretta per AES
    final aesKey = aliceSharedSecret.substring(0, 64); // 32 bytes = 64 hex chars

    final aes = AESCipher.createFull((
      parent: (
        key: aesKey,
        parent: (
          parent: (
            expirationDate: DateTime.now().add(Duration(hours: 1)),
            expirationTimes: null,
          ),
        ),
      ),
    ));

    print('✅ AES cipher creato dalla chiave derivata dal secret\n');

    // Messaggio
    final message = 'Ciao Bob, questo è un messaggio segreto da Alice!';
    final messageBytes = List<int>.from(message.codeUnits);

    print('📨 Messaggio originale: "$message"');
    print('   Lunghezza: ${messageBytes.length} bytes\n');

    // Encripta
    final encrypted = aes.encrypt(messageBytes);
    print('🔒 Encriptato (hex): ${encrypted.toString().substring(0, 50)}...');
    print('   Lunghezza: ${encrypted.length} bytes\n');

    // Decripta
    final decrypted = aes.decrypt(encrypted);
    final decryptedMessage = String.fromCharCodes(decrypted);

    print('🔓 Decriptato: "$decryptedMessage"');
    print('   Corrisponde al messaggio originale: ${decryptedMessage == message}\n');
  }

  // ════════════════════════════════════════════════════════════════════════════
  // SUMMARY
  // ════════════════════════════════════════════════════════════════════════════

  print('📊 SUMMARY');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('''
✅ Generazione chiavi: 2 coppie (Alice + Bob)
✅ Scambio pubblico: 2 chiavi pubbliche (non sicure)
✅ Calcolo locale: 2 shared secret (identici)
✅ Crittografia: Utilizzabile per simmetrica (AES, ChaCha20, ecc.)

Proprietà ECDH:
• Non scambiate mai le chiavi private
• Il shared secret è identico su entrambi i peer
• Il protocollo è sicuro anche su canale pubblico
• Qualcuno che conosce solo le chiavi pubbliche non può
  calcolare il shared secret senza una delle private
''');
}
```

## 🎯 Parametri Curve

Curve disponibili per ECDH:

```dart
// Default (NIST P-256)
ECCKeyUtils.secp256r1

// Alternative supportate
ECCKeyUtils.secp384r1  // NIST P-384 (più sicura)
ECCKeyUtils.secp521r1  // NIST P-521 (massima sicurezza)

// Utilizzo
final keyPair = await ECDHKeyExchange.generateKeyPair(
  curve: ECCKeyUtils.secp384r1,
);
```

## 📋 Metodi Disponibili

### Classe `ECDHKeyExchange`

| Metodo | Tipo | Descrizione |
|--------|------|-------------|
| `generateKeyPair()` | `static async` | Genera coppia chiavi per curve specifica |
| `createFull()` | `static` | Crea istanza ECDH completamente configurata |
| `generateSharedSecret()` | `async` | Calcola shared secret con chiave pubblica remota |
| `getPublicKey()` | Sincrono | Ritorna la chiave pubblica dell'istanza |
| `isExpired()` | Sincrono | Verifica se l'istanza è scaduta |

## 🔄 Workflow Tipico

```
1. GENERAZIONE
   ├─ Peer A: generateKeyPair() → pubA, privA
   └─ Peer B: generateKeyPair() → pubB, privB

2. CREAZIONE ISTANZE
   ├─ Peer A: createFull(privA, pubA)
   └─ Peer B: createFull(privB, pubB)

3. EXCHANGE (canale pubblico)
   ├─ A → B: pubA
   └─ B → A: pubB

4. CALCOLO SECRET (localmente)
   ├─ A: generateSharedSecret(pubB) → secret_A
   └─ B: generateSharedSecret(pubA) → secret_B

5. VERIFICARE
   └─ secret_A === secret_B ✅

6. UTILIZZO
   └─ Usare secret come chiave per AES, ChaCha20, ecc.
```

## ⚠️ Considerazioni di Sicurezza

### ✅ Chiavi Private - MANTIENI SEGRETE!
```dart
// ❌ SBAGLIATO: Non trasmettere mai la chiave privata
sendOverNetwork(keyPair['privateKey']!);

// ✅ CORRETTO: Trasmetti solo la chiave pubblica
sendOverNetwork(keyPair['publicKey']!);
```

### ✅ Verifica Integrità (Opzionale)
Se utilizzi un canale insicuro, considera di:
1. Firmare digitalmente le chiavi pubbliche (ECDSA)
2. Usare certificati per autenticazione
3. Implementare anti-replay attack

### ✅ Curve Selection
- **secp256r1**: Standard, buon compromesso sicurezza/performance
- **secp384r1**: Maggiore sicurezza, più lento
- **secp521r1**: Massima sicurezza, più lento ancora

## 🔗 Integrazione con CipherFactory

Se usi la `CipherFactory`, puoi creare istanze ECDH così:

```dart
import 'package:cryptdart/cryptdart.dart';

final keyPair = await ECDHKeyExchange.generateKeyPair();

// Direttamente (senza factory per ECDH)
final ecdh = ECDHKeyExchange.createFull((
  parent: (
    algorithm: KeyExchangeAlgorithm.ecdh,
    expirationDate: DateTime.now().add(Duration(hours: 1)),
    expirationTimes: null,
  ),
  publicKey: keyPair['publicKey']!,
  privateKey: keyPair['privateKey']!,
  curve: '',
));
```

## 📊 Tabella Comparativa: Curve

| Curve | Sicurezza | Performance | Uso |
|-------|-----------|-------------|-----|
| secp256r1 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Tipico |
| secp384r1 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Sicurezza elevata |
| secp521r1 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | Massima sicurezza |

## 🎁 Casi d'Uso Reali

### 1. **Secure Chat**
Alice e Bob scambiano messaggi crittografati usando il shared secret come chiave AES.

### 2. **IoT Communication**
Dispositivo A e Dispositivo B stabiliscono un canale sicuro senza pre-shared key.

### 3. **Session Establishment**
Server e Client eseguono ECDH per creare una session key.

### 4. **Perfect Forward Secrecy**
Ogni sessione usa una nuova coppia di chiavi, se una chiave passata è compromessa, le sessioni precedenti rimangono sicure.

## 📚 File Correlati

- `lib/implementations/key_exchange/ecdh_key_exchange.dart` - Implementazione ECDH
- `lib/interfaces/key_exchange/i_key_exchange.dart` - Interfaccia
- `example/cipher_factory_example.dart` - Esempio di creazione

---

**Pronto a fare Key Exchange sicuro tra due peer!** 🚀
