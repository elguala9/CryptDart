
import '../types/crypto_algorithm.dart';

abstract class IExpitration {
  bool isExpired();
  DateTime? get expirationDate;
  CryptoAlgorithm get algorithm;
}