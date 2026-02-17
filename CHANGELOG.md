

# Changelog

## [0.1.7] - 2026-02-17
- Refactor: Pulizia e stabilizzazione post-refactoring typedef
  - Rimozione di esempi duplicati e file di documentazione temporanei
  - Consolidamento della documentazione in guide ufficiali
- Miglioramento: Aggiornamento della versione di referenza in pubspec.yaml e README
- Stabilizzazione: Verifica completa della suite di test e analisi codice
  - Tutti i 38 test passano ✓
  - Verificato con `dart analyze` - 0 errori ✓
  - Dry-run su pub.dev: 0 warnings ✓
- Preparazione: Pacchetto pronto per la pubblicazione stabile su pub.dev

## [0.1.6] - 2026-02-17
- Refactor: Trasformati tutti i 22 typedef da record a classi immutabili
  - InputExpirationBase, InputCipher, InputSign, InputKeyExchangeBase
  - InputSymmetricCipher, InputSymmetricSign, InputAsymmetricCipher, InputAsymmetricSign
  - InputHandler<T>, InputECDHKeyExchange
  - InputAESCipher, InputDESCipher, InputChaCha20Cipher, InputRSACipher, InputECDSACipher
  - InputHMACSign, InputRSASignatureCipher, InputECDSASign
  - KeyPair, CryptoPeerCapabilities, NegotiationResult, SecureSession
- Benefici della trasformazione:
  - Inizializzazione più semplice con costruttori anziché record annidati
  - Implementazioni type-safe di equals/hashCode
  - API coerente con sintassi di classe consistente
  - Validazione e documentazione più facili
- Aggiornati 37 file (lib/, example/, test/)
- Tutti i 38 test passano ✓
- Verificato con `dart analyze` - 0 errori ✓

## [0.1.5] - 2026-02-16
- Feature: Aggiunto sistema di codici numerici univoci per gli algoritmi crittografici
  - Tutti gli enum (SymmetricCipherAlgorithm, AsymmetricCipherAlgorithm, SymmetricSignAlgorithm, AsymmetricSignAlgorithm) ora hanno un campo `code: int`
  - Codici organizzati per categoria: Symmetric (1-3, 21), Asymmetric Cipher (11-12), Asymmetric Sign (31-32)
  - ECDSA ha codici diversi per cipher (12) e sign (32) per evitare conflitti
- Feature: Aggiunti nuovi enum per categorizzare gli algoritmi
  - `SymmetricAlgorithm`: aes(1), des(2), chacha20(3), hmac(21)
  - `AsymmetricAlgorithm`: rsa(11), ecdsaCipher(12), rsaSignature(31), ecdsaSign(32)
- Feature: Aggiunto metodo `CryptoAlgorithm.findByCode(int code)` per lookup rapido per codice numerico
- Miglioramento: Codici occupano poco spazio (1 byte per algoritmo) per serializzazione ottimale
- Tutti i 38 test passano ✓
- Verificato con `dart analyze` ✓

## [0.1.4] - 2026-02-16
- Refactoring: Reso sincrono il metodo `generateSharedSecret()` in `ECDHKeyExchange`
  - Rimosso `Future<String>` dal tipo di ritorno (ora `String`)
  - Rimosso `async` dalla firma del metodo
  - Tutte le operazioni ECDH sono sincrone (no I/O)
- Update: Rimossi tutti gli `await` da 7 file (examples e test)
- Miglioramento: Codice più semplice e veloce (niente overhead asincrono)
- Tutti i 15 test ECDH passano ✓
- Verificato con `dart analyze` - nessun errore ✓

## [0.1.3] - 2026-02-15
- Fix: Rimosso parametro `algorithm` da InputExpirationBase in tutti i test e example
- Fix: Sostituiti riferimenti a CryptoAlgorithm con enum specifici (SymmetricCipherAlgorithm, AsymmetricCipherAlgorithm, SymmetricSignAlgorithm, AsymmetricSignAlgorithm)
- Fix: Risolto accesso a proprietà `.name` su enum values con helper function `_extractAlgorithmName()`
- Fix: Corretta struttura annidata di parent tuple per ECDHKeyExchange
- Fix: Aggiunto parametro `algorithm: KeyExchangeAlgorithm.ecdh` dove mancava
- Refactoring: Riscritto factory_methods_example.dart per usare createFull() factory methods
- Fix: Rimossi import non utilizzati e cast non necessari
- Aggiunto: Dipendenze mancanti (crypto, path) a pubspec.yaml
- Tutti i 38 test passano ✓
- Tutti i 7 example file funzionano correttamente ✓

## [0.1.2] - 2025-11-21
- Fix: tutti i costruttori degli esempi ora rispettano le typedef effettive
- Refactoring: esempio/main.dart ora è completamente compatibile con Dart 3
- Preparazione per pubblicazione su pub.dev

All notable changes to this project will be documented in this file.

## [0.1.1] - 2025-11-21
- Added ECDSA digital signature support
- Updated dependencies: pointycastle ^4.0.0, basic_utils ^5.8.2, meta ^1.17.0
- Improved documentation and README
- Added example package
- Various bugfixes and code formatting improvements

## [0.1.0] - Initial release
- First public release of CryptDart
- Symmetric ciphers: AES, TripleDES, ChaCha20
- Asymmetric cipher: RSA
- Digital signatures: HMAC, RSA signature
- Key generation and expiration logic
- Centralized cryptographic utilities
