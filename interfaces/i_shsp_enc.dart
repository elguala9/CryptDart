
import '../types/crypto_algorithm.dart';

abstract class ICipher {
  List<int> encrypt(List<int> data);
  List<int> decrypt(List<int> data);
  bool isExpired();
  DateTime? get expirationDate;
  CryptoAlgorithm get algorithm;
}