# CryptDart Project Memory

## Project Overview
- **Purpose**: Unified cryptography library for Dart with symmetric/asymmetric encryption, signatures, key exchange
- **Tech Stack**: Dart 3.0+, PointyCastle, BasicUtils, LGPL-3.0
- **Architecture**: 3-layer (Interfaces → Partial Base → Concrete Implementations)

## Concrete Classes Structure

### Symmetric Ciphers
- AESCipher, ChaCha20Cipher, DESCipher (under `lib/implementations/symmetric/`)
- Each has: Constructor(InputXXX), generateKey() static
- Extend SymmetricCipher base class

### Asymmetric Ciphers  
- RSACipher (under `lib/implementations/asymmetric/prime_based/`)
- ECDSACipher (under `lib/implementations/asymmetric/non_prime_based/`)
- Each has: Constructor(InputXXX), generateKeyPair() static
- Extend AsymmetricCipher base class

### Key Exchange
- ECDHKeyExchange (under `lib/implementations/key_exchange/`)
- Has: Constructor(InputECDHKeyExchange), generateKeyPair() static
- Extends KeyExchangeBase

### Signatures
- HMACSign, RSASignatureCipher, ECDSASign (under `lib/implementations/signed_based/`)
- Each has: Constructor(InputXXX), generateKey()/generateKeyPair() static
- Extend SymmetricSign or AsymmetricSign base classes

## Conventions
- Input parameters as typedef records (InputXXXClass)
- Factory methods are static and return primitive types (String, Map<String, String>)
- Constructors accept typedef Input objects with nested parent fields
- Use `@includeInBarrelFile` annotation

## Commands
```bash
dart test              # Run all tests
dart analyze           # Code analysis
dart pub get           # Install dependencies
```
