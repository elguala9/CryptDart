import 'package:cryptdart/cryptdart.dart';
import 'dart:convert';
import 'dart:typed_data';

void main() {
  print('═══════════════════════════════════════════════════════════');
  print('            AES EXAMPLES - ADVANCED USAGE');
  print('═══════════════════════════════════════════════════════════\n');

  // ============================================
  // ESEMPIO 1: Testo semplice
  // ============================================
  print('1️⃣  TESTO SEMPLICE\n');
  esempio1_TestoSemplice();

  print('\n' + '═' * 63 + '\n');

  // ============================================
  // ESEMPIO 2: Dati JSON
  // ============================================
  print('2️⃣  DATI JSON\n');
  esempio2_JSON();

  print('\n' + '═' * 63 + '\n');

  // ============================================
  // ESEMPIO 3: File binari
  // ============================================
  print('3️⃣  DATI BINARI\n');
  esempio3_DatiBinari();

  print('\n' + '═' * 63 + '\n');

  // ============================================
  // ESEMPIO 4: Chiave personalizzata
  // ============================================
  print('4️⃣  CHIAVE PERSONALIZZATA\n');
  esempio4_ChiavePersonalizzata();

  print('\n' + '═' * 63 + '\n');

  // ============================================
  // ESEMPIO 5: Batch encryption/decryption
  // ============================================
  print('5️⃣  BATCH ENCRYPTION\n');
  esempio5_BatchEncryption();

  print('\n' + '═' * 63 + '\n');

  // ============================================
  // ESEMPIO 6: Espirazione chiave
  // ============================================
  print('6️⃣  CHIAVE CON SCADENZA\n');
  esempio6_ChiaveConScadenza();
}

// ============================================
// ESEMPIO 1: Testo semplice
// ============================================
void esempio1_TestoSemplice() {
  final chiave = AESCipher.generateKey();
  final cipher = AESCipher(
    InputAESCipher(
      parent: InputSymmetricCipher(
        key: chiave,
        parent: InputCipher(
          parent: InputExpirationBase(),
        ),
      ),
    ),
  );

  final testo = 'Hello, World! 🔐';
  final bytesOriginali = utf8.encode(testo);

  print('Testo originale: "$testo"');
  print('Bytes originali: $bytesOriginali');

  // Cripta
  final bytesCriptati = cipher.encrypt(bytesOriginali);
  final criptatiHex = bytesToHex(bytesCriptati);
  print('Testo criptato (hex): $criptatiHex');

  // Decripta
  final bytesDecriptati = cipher.decrypt(bytesCriptati);
  final testoDecriptato = utf8.decode(bytesDecriptati);
  print('Testo decriptato: "$testoDecriptato"');
  print('Match: ${testo == testoDecriptato ? '✅' : '❌'}');
}

// ============================================
// ESEMPIO 2: Dati JSON
// ============================================
void esempio2_JSON() {
  final chiave = AESCipher.generateKey();
  final cipher = AESCipher(
    InputAESCipher(
      parent: InputSymmetricCipher(
        key: chiave,
        parent: InputCipher(
          parent: InputExpirationBase(),
        ),
      ),
    ),
  );

  // JSON da criptare
  final jsonData = {
    'username': 'mario_rossi',
    'email': 'mario@example.com',
    'segreto': 'password123',
    'ruoli': ['admin', 'user']
  };

  final jsonString = jsonEncode(jsonData);
  print('JSON originale: $jsonString');

  // Cripta
  final criptato = cipher.encrypt(utf8.encode(jsonString));
  print('JSON criptato: ${bytesToHex(criptato)}');

  // Decripta
  final decriptato = cipher.decrypt(criptato);
  final jsonDecriptato = jsonDecode(utf8.decode(decriptato));
  print('JSON decriptato: $jsonDecriptato');
  print('Match: ${jsonEncode(jsonData) == jsonEncode(jsonDecriptato) ? '✅' : '❌'}');
}

// ============================================
// ESEMPIO 3: Dati binari
// ============================================
void esempio3_DatiBinari() {
  final chiave = AESCipher.generateKey();
  final cipher = AESCipher(
    InputAESCipher(
      parent: InputSymmetricCipher(
        key: chiave,
        parent: InputCipher(
          parent: InputExpirationBase(),
        ),
      ),
    ),
  );

  // Crea dati binari (es: immagine, file)
  final datiBinari = Uint8List.fromList(
    List.generate(64, (i) => i % 256)
  );

  print('Dati binari originali (primi 16 byte):');
  print('   ${datiBinari.take(16).toList()}');

  // Cripta
  final criptati = cipher.encrypt(datiBinari);
  print('Dati criptati (primi 16 byte):');
  print('   ${criptati.take(16).toList()}');

  // Decripta
  final decriptati = cipher.decrypt(criptati);
  print('Dati decriptati (primi 16 byte):');
  print('   ${decriptati.take(16).toList()}');

  // Confronto lunghezza (il decrypt aggiunge padding)
  print('Lunghezza originale: ${datiBinari.length}');
  print('Lunghezza decriptati: ${decriptati.length}');
}

// ============================================
// ESEMPIO 4: Chiave personalizzata (hex string)
// ============================================
void esempio4_ChiavePersonalizzata() {
  // Usa una chiave specifica (in hex)
  // ATTENZIONE: Non usare questa in produzione! È solo un esempio.
  final chiavePersonalizzata =
      '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';

  print('Chiave (hex): $chiavePersonalizzata');
  print('Lunghezza: ${chiavePersonalizzata.length ~/ 2} bytes');

  final cipher = AESCipher(
    InputAESCipher(
      parent: InputSymmetricCipher(
        key: chiavePersonalizzata,
        parent: InputCipher(
          parent: InputExpirationBase(),
        ),
      ),
    ),
  );

  final testo = 'Crittato con chiave personalizzata';
  final criptato = cipher.encrypt(utf8.encode(testo));
  final decriptato = cipher.decrypt(criptato);

  print('Testo originale: "$testo"');
  print('Testo decriptato: "${utf8.decode(decriptato)}"');
  print('Match: ${testo == utf8.decode(decriptato) ? '✅' : '❌'}');
}

// ============================================
// ESEMPIO 5: Batch encryption/decryption
// ============================================
void esempio5_BatchEncryption() {
  final chiave = AESCipher.generateKey();
  final cipher = AESCipher(
    InputAESCipher(
      parent: InputSymmetricCipher(
        key: chiave,
        parent: InputCipher(
          parent: InputExpirationBase(),
        ),
      ),
    ),
  );

  // Lista di messaggi da criptare
  final messaggi = [
    'Messaggio 1',
    'Messaggio 2',
    'Messaggio 3',
    'Messaggio segreto 🔐',
  ];

  print('Criptatura batch:\n');

  final criptati = <String>[];
  for (var i = 0; i < messaggi.length; i++) {
    final msg = messaggi[i];
    final crittato = cipher.encrypt(utf8.encode(msg));
    final hex = bytesToHex(crittato);
    criptati.add(hex);
    print('  ${i + 1}. "$msg" → $hex');
  }

  print('\nDecriptatura batch:\n');

  for (var i = 0; i < criptati.length; i++) {
    final hex = criptati[i];
    final bytes = hexToBytes(hex);
    final decriptato = utf8.decode(cipher.decrypt(bytes));
    final match = messaggi[i] == decriptato;
    print('  ${i + 1}. $hex → "$decriptato" ${match ? '✅' : '❌'}');
  }
}

// ============================================
// ESEMPIO 6: Chiave con scadenza
// ============================================
void esempio6_ChiaveConScadenza() {
  final chiave = AESCipher.generateKey();

  // Chiave che scade tra 10 secondi
  final scadenza = DateTime.now().add(Duration(seconds: 10));

  final cipher = AESCipher(
    InputAESCipher(
      parent: InputSymmetricCipher(
        key: chiave,
        parent: InputCipher(
          parent: InputExpirationBase(
            expirationDate: scadenza,
          ),
        ),
      ),
    ),
  );

  print('Chiave scade alle: $scadenza');
  print('Scaduta adesso? ${cipher.isExpired()}');

  final testo = 'Messaggio con chiave temporale';
  final criptato = cipher.encrypt(utf8.encode(testo));

  print('Messaggio: "$testo"');
  print('Criptato: ${bytesToHex(criptato)}');

  if (!cipher.isExpired()) {
    final decriptato = utf8.decode(cipher.decrypt(criptato));
    print('Decriptato: "$decriptato"');
    print('✅ Chiave ancora valida');
  } else {
    print('❌ Chiave scaduta! Non può essere usata.');
  }
}

// ============================================
// UTILITY FUNCTIONS
// ============================================

String bytesToHex(List<int> bytes) {
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

List<int> hexToBytes(String hex) {
  final result = <int>[];
  for (int i = 0; i < hex.length; i += 2) {
    result.add(int.parse(hex.substring(i, i + 2), radix: 16));
  }
  return result;
}
