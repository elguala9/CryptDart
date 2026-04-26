import 'package:cryptdart/cryptdart.dart';
import 'dart:convert';

void main() {
  // ============================================
  // 1. Genera una chiave AES-256
  // ============================================
  final aesKey = AESCipher.generateKey();
  print('🔑 Chiave AES-256 generata:');
  print('   $aesKey\n');

  // ============================================
  // 2. Crea l'istanza di AESCipher
  // ============================================
  final cipher = AESCipher(
    InputAESCipher(
      parent: InputSymmetricCipher(
        key: aesKey,
        parent: InputCipher(
          parent: InputExpirationBase(),
        ),
      ),
    ),
  );
  print('✅ AESCipher creato\n');

  // ============================================
  // 3. Cifra un messaggio
  // ============================================
  final messaggio = 'Ciao, questo è il mio messaggio segreto!';
  final messaggioBytes = utf8.encode(messaggio);

  final criptato = cipher.encrypt(messaggioBytes);
  final criptatoHex = criptato
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join();

  print('📝 Messaggio originale:');
  print('   "$messaggio"\n');
  print('🔐 Messaggio criptato (hex):');
  print('   $criptatoHex\n');

  // ============================================
  // 4. Decifra il messaggio
  // ============================================
  final decriptato = cipher.decrypt(criptato);
  final messaggioDecriptato = utf8.decode(decriptato);

  print('🔓 Messaggio decriptato:');
  print('   "$messaggioDecriptato"\n');

  // ============================================
  // 5. Verifica che è corretto
  // ============================================
  final isCorretto = messaggio == messaggioDecriptato;
  print('✓ Verifica: ${isCorretto ? '✅ CORRETTO' : '❌ ERRORE'}\n');

  // ============================================
  // 6. Esempio con dati binari
  // ============================================
  print('--- Esempio con dati binari ---\n');
  final datiBinari = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final datiBinariCriptati = cipher.encrypt(datiBinari);
  final datiBinariDecriptati = cipher.decrypt(datiBinariCriptati);

  print('📦 Dati originali: $datiBinari');
  print('🔐 Dati criptati: $datiBinariCriptati');
  print('🔓 Dati decriptati: $datiBinariDecriptati');
  print('✓ Match: ${datiBinari == datiBinariDecriptati ? '✅' : '❌'}\n');
}
