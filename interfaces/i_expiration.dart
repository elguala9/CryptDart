
import '../types/crypto_algorithm.dart';

abstract class IExpiration {
  bool isExpired();
  DateTime? get expirationDate;
  int? get expirationTimes;
  int? get expirationTimesRemaining;
  CryptoAlgorithm get algorithm;
}

