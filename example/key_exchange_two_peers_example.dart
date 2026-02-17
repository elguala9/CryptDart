/// Example demonstrating ECDH Key Exchange between two peers (Alice and Bob).
///
/// This example shows a complete key exchange scenario:
/// 1. Two peers generate their own key pairs
/// 2. They exchange public keys over an insecure channel
/// 3. Each peer computes the same shared secret locally
/// 4. The shared secret can be used for symmetric encryption

import 'package:cryptdart/cryptdart.dart';

void main() async {
  print('🔐 ECDH Key Exchange - Alice & Bob\n');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('ECDH Key Exchange è un protocollo che permette a due peer di');
  print('stabilire un shared secret su un canale insicuro, senza scambiarsi');
  print('le chiavi private.\n');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 1: INITIALIZATION
  // ════════════════════════════════════════════════════════════════════════════

  print('📍 PHASE 1: Generazione delle chiavi\n');

  // Alice generates her key pair
  print('👤 Alice: Generando coppia di chiavi...');
  final aliceKeyPair = await ECDHKeyExchange.generateKeyPair();
  final alicePublicKey = aliceKeyPair['publicKey']!;
  final alicePrivateKey = aliceKeyPair['privateKey']!;
  print('✅ Alice chiave pubblica pronta (${alicePublicKey.length} chars)\n');

  // Bob generates his key pair
  print('👤 Bob: Generando coppia di chiavi...');
  final bobKeyPair = await ECDHKeyExchange.generateKeyPair();
  final bobPublicKey = bobKeyPair['publicKey']!;
  final bobPrivateKey = bobKeyPair['privateKey']!;
  print('✅ Bob chiave pubblica pronta (${bobPublicKey.length} chars)\n');

  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 2: KEY EXCHANGE SETUP
  // ════════════════════════════════════════════════════════════════════════════

  print('📍 PHASE 2: Creazione istanze ECDH\n');

  // Create ECDH instance for Alice
  final aliceEcdh = ECDHKeyExchange.createFull(InputECDHKeyExchange(
    parent: InputKeyExchangeBase(
      algorithm: KeyExchangeAlgorithm.ecdh,
      expirationDate: DateTime.now().add(Duration(hours: 1)),
      expirationTimes: null,
    ),
    publicKey: alicePublicKey,
    privateKey: alicePrivateKey,
    curve: '', // Default curve (secp256r1)
  ));
  print('✅ Alice ECDH istanza creata');

  // Create ECDH instance for Bob
  final bobEcdh = ECDHKeyExchange.createFull(InputECDHKeyExchange(
    parent: InputKeyExchangeBase(
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
  print('   Primo byte: ${alicePublicKey.substring(0, 20)}...');
  print('   Lunghezza: ${alicePublicKey.length} caratteri\n');

  print('🔄 Bob invia la sua chiave pubblica ad Alice');
  print('   Primo byte: ${bobPublicKey.substring(0, 20)}...');
  print('   Lunghezza: ${bobPublicKey.length} caratteri\n');

  print('✅ Scambio completato (le chiavi pubbliche sono pubbliche!)\n');

  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 4: SHARED SECRET COMPUTATION
  // ════════════════════════════════════════════════════════════════════════════

  print('📍 PHASE 4: Calcolo del shared secret\n');

  // Alice computes shared secret
  print('👤 Alice: Calcolando shared secret con chiave pubblica di Bob...');
  final aliceSharedSecret = aliceEcdh.generateSharedSecret(bobPublicKey);
  print('✅ Shared Secret calcolato (${aliceSharedSecret.length} chars)');
  print('   Primi 32 chars: ${aliceSharedSecret.substring(0, 32)}...\n');

  // Bob computes shared secret
  print('👤 Bob: Calcolando shared secret con chiave pubblica di Alice...');
  final bobSharedSecret = bobEcdh.generateSharedSecret(alicePublicKey);
  print('✅ Shared Secret calcolato (${bobSharedSecret.length} chars)');
  print('   Primi 32 chars: ${bobSharedSecret.substring(0, 32)}...\n');

  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 5: VERIFICATION
  // ════════════════════════════════════════════════════════════════════════════

  print('📍 PHASE 5: Verifica che i shared secret sono identici\n');

  final secretsMatch = aliceSharedSecret == bobSharedSecret;

  if (secretsMatch) {
    print('✅ ✅ ✅ SUCCESSO! ✅ ✅ ✅\n');
    print('I shared secret di Alice e Bob sono IDENTICI!');
    print('Lunghezza: ${aliceSharedSecret.length} caratteri');
    print('\nShared Secret completo:');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print(aliceSharedSecret);
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  } else {
    print('❌ ERRORE: I shared secret non coincidono!');
    print('Alice: ${aliceSharedSecret.substring(0, 50)}...');
    print('Bob:   ${bobSharedSecret.substring(0, 50)}...');
    return;
  }

  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 6: USE THE SHARED SECRET FOR ENCRYPTION
  // ════════════════════════════════════════════════════════════════════════════

  print('📍 PHASE 6: Utilizzo del shared secret per crittografia\n');

  // The shared secret can be used as a key for symmetric encryption
  // For AES, we need a 256-bit key (64 hex characters)
  final aesKeyFromSecret = aliceSharedSecret.substring(0, 64);

  print('🔑 Derivazione chiave AES dal shared secret:');
  print('   Primi 32 chars del secret: ${aesKeyFromSecret.substring(0, 32)}...');
  print('   Lunghezza chiave AES: ${aesKeyFromSecret.length} chars (256-bit)\n');

  // Alice creates AES cipher from the shared secret
  print('👤 Alice: Creando AES cipher dalla chiave derivata...');
  final aes = AESCipher.createFull(InputAESCipher(
    parent: InputSymmetricCipher(
      key: aesKeyFromSecret,
      parent: InputCipher(
        parent: InputExpirationBase(
          expirationDate: DateTime.now().add(Duration(hours: 1)),
          expirationTimes: null,
        ),
      ),
    ),
  ));
  print('✅ AES cipher creato\n');

  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 7: SECURE MESSAGE EXCHANGE
  // ════════════════════════════════════════════════════════════════════════════

  print('📍 PHASE 7: Scambio di messaggi criptati\n');

  // Alice sends an encrypted message to Bob
  const message = 'Ciao Bob! Questo è un messaggio segreto da Alice!';
  final messageBytes = List<int>.from(message.codeUnits);

  print('📨 Alice invia un messaggio:');
  print('   Messaggio: "$message"');
  print('   Lunghezza: ${messageBytes.length} bytes\n');

  // Encrypt
  print('🔒 Alice: Encriptando il messaggio con AES...');
  final encrypted = aes.encrypt(messageBytes);
  print('✅ Messaggio encriptato');
  print('   Lunghezza: ${encrypted.length} bytes');
  print('   Dati encriptati (hex): ${encrypted.toString().substring(1, 50)}...\n');

  print('📤 Alice invia il messaggio encriptato a Bob su un canale pubblico\n');

  // Bob decrypts the message using the same AES cipher derived from shared secret
  print('📥 Bob riceve il messaggio encriptato\n');

  // Create the same AES cipher from the shared secret
  print('👤 Bob: Creando AES cipher dalla chiave derivata (stesso secret)...');
  final aesForBob = AESCipher.createFull(InputAESCipher(
    parent: InputSymmetricCipher(
      key: aesKeyFromSecret, // Same key as Alice
      parent: InputCipher(
        parent: InputExpirationBase(
          expirationDate: DateTime.now().add(Duration(hours: 1)),
          expirationTimes: null,
        ),
      ),
    ),
  ));
  print('✅ AES cipher creato\n');

  // Decrypt
  print('🔓 Bob: Decriptando il messaggio...');
  final decrypted = aesForBob.decrypt(encrypted);
  final decryptedMessage = String.fromCharCodes(decrypted);
  print('✅ Messaggio decriptato: "$decryptedMessage"');
  print('   Corrisponde al messaggio originale: ${decryptedMessage == message}\n');

  // ════════════════════════════════════════════════════════════════════════════
  // PHASE 8: REVERSE COMMUNICATION (Bob to Alice)
  // ════════════════════════════════════════════════════════════════════════════

  print('📍 PHASE 8: Comunicazione bidirezionale\n');

  const messageFromBob = 'Ciao Alice! Ho ricevuto il tuo messaggio!';
  final messageFromBobBytes = List<int>.from(messageFromBob.codeUnits);

  print('📨 Bob invia una risposta:');
  print('   Messaggio: "$messageFromBob"');
  print('   Lunghezza: ${messageFromBobBytes.length} bytes\n');

  // Encrypt with Alice's cipher
  print('🔒 Bob: Encriptando il messaggio con AES...');
  final encryptedFromBob = aes.encrypt(messageFromBobBytes);
  print('✅ Messaggio encriptato\n');

  // Decrypt with Bob's cipher
  print('👤 Alice riceve e decripta il messaggio da Bob...');
  final decryptedFromBob = aesForBob.decrypt(encryptedFromBob);
  final decryptedMessageFromBob = String.fromCharCodes(decryptedFromBob);
  print('✅ Messaggio ricevuto: "$decryptedMessageFromBob"\n');

  // ════════════════════════════════════════════════════════════════════════════
  // SUMMARY
  // ════════════════════════════════════════════════════════════════════════════

  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('📊 SUMMARY - ECDH Key Exchange Completato\n');

  print('✅ Generazione chiavi: 2 coppie (Alice + Bob)');
  print('✅ Scambio pubblico: 2 chiavi pubbliche (non criptate)');
  print('✅ Calcolo locale: 2 shared secret identici');
  print('✅ Derivazione chiave: AES key da shared secret');
  print('✅ Crittografia: Messaggi scambiati in sicurezza\n');

  print('Proprietà di Sicurezza ECDH:');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('''
🔐 Le chiavi private RIMANGONO SEGRETE
   • Alice non trasmette mai privA
   • Bob non trasmette mai privB
   • Solo le chiavi pubbliche viaggiano su canale pubblico

🔐 Il shared secret è identico su entrambi i peer
   • Calcolato localmente usando:
     - Propria chiave privata
     - Chiave pubblica dell'altro peer
   • Risultato: secret_A == secret_B

🔐 Sicurezza su canale insicuro
   • Anche se qualcuno ascolta lo scambio di chiavi pubbliche
   • Non può calcolare il shared secret senza una chiave privata
   • Le chiavi private rimangono al sicuro

🔐 Forward Secrecy
   • Ogni sessione usa nuove chiavi
   • Se una chiave privata è compromessa in futuro,
     le sessioni passate rimangono sicure
''');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  print('🎯 Prossimi Step:');
  print('   1. Implementare handshake per autenticazione peer');
  print('   2. Aggiungere signature digitale per integrità chiavi pubbliche');
  print('   3. Implementare key derivation function (HKDF) per più chiavi');
  print('   4. Aggiungere forward secrecy con rekeying periodico\n');
}
