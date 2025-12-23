# ECDH Bidirectional Secure Communication System

Questo sistema implementa un protocollo di comunicazione sicura bidirezionale utilizzando ECDH (Elliptic Curve Diffie-Hellman) per lo scambio di chiavi e negoziazione automatica degli algoritmi.

## Caratteristiche

### 🔄 **Negoziazione Bidirezionale degli Algoritmi**
- Ogni peer dichiara i suoi algoritmi supportati (asimmetrici + simmetrici)
- Negoziazione automatica con priorità configurabili
- Fallback su algoritmi più sicuri disponibili

### 🔐 **Key Exchange ECDH**
- Utilizzo di curve ellittiche per lo scambio sicuro delle chiavi
- Supporto per curve standard (secp256r1, secp384r1, secp521r1)
- Generazione di chiavi condivise sicure

### 🎯 **Integrazione con gli Handler Esistenti**
- Restituisce i tuoi handler `HandlerCipherSymmetric` e `HandlerCipherAsymmetric`
- Supporta tutti gli algoritmi esistenti (AES, ChaCha20, DES, RSA)
- Compatibilità totale con l'architettura CryptDart

## Struttura delle Cartelle

```
lib/
├── interfaces/key_exchange/
│   ├── i_algorithm_negotiation.dart     # Interfaccia per negoziazione algoritmi
│   ├── i_crypto_session.dart            # Interfaccia per gestione sessioni
│   └── i_key_exchange.dart              # Interfaccia base per key exchange
├── implementations/
│   ├── key_exchange/
│   │   └── ecdh_key_exchange.dart       # Implementazione ECDH
│   └── session/
│       ├── algorithm_negotiation.dart    # Logica di negoziazione
│       ├── crypto_session_manager.dart   # Manager principale delle sessioni
│       └── secure_communication_factory.dart # Factory di alto livello
└── types/
    └── crypto_algorithm.dart            # Enum aggiornato con ECDH
```

## API Principale

### Quick Start

```dart
import 'package:cryptdart/implementations/session/secure_communication_factory.dart';
import 'package:cryptdart/types/crypto_algorithm.dart';

// Initiator (Alice)
final aliceSession = await SecureCommunicationFactory.initiateSecureSession(
  localPeerId: 'alice@example.com',
  supportedAsymmetric: [CryptoAlgorithm.ecdh, CryptoAlgorithm.rsa],
  supportedSymmetric: [CryptoAlgorithm.chacha20, CryptoAlgorithm.aes],
  sendToRemote: (message) async {
    // Invia message a Bob e ricevi risposta
    return bobResponseMessage;
  },
);

// Responder (Bob)
final bobResult = await SecureCommunicationFactory.respondToSecureSession(
  localPeerId: 'bob@example.com',
  initiationMessage: aliceMessage,
  supportedAsymmetric: [CryptoAlgorithm.rsa, CryptoAlgorithm.ecdh],
  supportedSymmetric: [CryptoAlgorithm.aes, CryptoAlgorithm.chacha20],
);
```

### Utilizzo degli Handler

```dart
// Crittografia simmetrica (per dati)
final encrypted = session.encryptData(utf8.encode('Hello World'));
final decrypted = session.decryptData(encrypted);

// Crittografia asimmetrica (per chiavi/firme)
final asymmetricEncrypted = session.encryptAsymmetric(keyData);
final asymmetricDecrypted = session.decryptAsymmetric(asymmetricEncrypted);

// Accesso diretto agli handler
final symmetricHandler = session.symmetricHandler;
final asymmetricHandler = session.asymmetricHandler;
```

## Flusso del Protocollo

```
Alice (Initiator)           Bob (Responder)
      |                           |
   1. |------- Handshake -------->| (capabilities + ECDH pubkey)
      |                           |
   2. |<----- Response ----------| (negotiation + ECDH pubkey)
      |                           |
   3. [Calculate Shared Secret]   [Calculate Shared Secret]
      |                           |
   4. [Create Handlers]           [Create Handlers]
      |                           |
   5. <=== Secure Communication ==>
```

## Algoritmi Supportati

### Priorità Asimmetriche (più sicuro → meno sicuro)
1. **ECDH** - Elliptic Curve Diffie-Hellman
2. **RSA** - RSA encryption

### Priorità Simmetriche (più sicuro → meno sicuro)
1. **ChaCha20** - Modern stream cipher
2. **AES** - Advanced Encryption Standard
3. **DES** - Data Encryption Standard (legacy)

## Sicurezza

- **Forward Secrecy**: Ogni sessione usa chiavi ECDH temporanee
- **Algorithm Agility**: Supporto dinamico per nuovi algoritmi
- **Expiration Management**: Gestione automatica della scadenza delle chiavi
- **Secure Random**: Utilizzo di generatori crittograficamente sicuri

## Testing

```bash
# Test completi del sistema
dart test test/secure_session_test.dart

# Esempio funzionante
dart run example/secure_session_example.dart
```

## Estensibilità

### Aggiungere Nuovi Algoritmi Key Exchange

1. Implementare `IKeyExchange`
2. Aggiungere l'algoritmo a `CryptoAlgorithm`
3. Aggiornare `_asymmetricPriority` in `AlgorithmNegotiation`
4. Aggiornare il `CryptoSessionManager`

### Personalizzare la Negoziazione

```dart
final customNegotiator = AlgorithmNegotiation();
final sessionManager = CryptoSessionManager(negotiator: customNegotiator);
```

## Note Implementative

- **ChaCha20**: Utilizza IV da 8 byte (requisito PointyCastle)
- **ECDH**: Default curve secp256r1, supporto per curve personalizzate
- **Handlers**: Configurazione automatica con limiti sensati
- **Error Handling**: Gestione robusta degli errori di negoziazione

## Vantaggi Architetturali

✅ **Compatibilità**: Utilizza completamente l'architettura esistente CryptDart
✅ **Flessibilità**: Peer con capacità diverse possono comunicare
✅ **Scalabilità**: Facile aggiunta di nuovi algoritmi
✅ **Performance**: Selezione ottimale basata su priorità
✅ **Sicurezza**: Forward secrecy e algoritmi all'avanguardia