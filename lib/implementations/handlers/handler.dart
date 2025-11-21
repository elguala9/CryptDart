import 'package:meta/meta.dart';

import 'package:cryptdart/interfaces/i_expiration.dart';
import 'package:cryptdart/interfaces/i_handler.dart';
import 'package:cryptdart/types/crypto_algorithm.dart';

typedef InputHandler<T extends IExpiration> = ({
  T initialCrypt,
  int maxCrypts,
  int? maxExpiredCrypts, // 0 = no limit, -1 = remove all immediately (expiredCrypts always empty)
  int? maxDaysExpiredCrypts, // 0 = no limit, -1 = remove all immediately
});

abstract class Handler<T extends IExpiration> implements IHandler<T> {
  @protected
  final List<T> protectedCrypts;
  @protected
  final List<T> protectedExpiredCrypts;
  final int maxCrypts;
  final int? maxExpiredCrypts;
  final int? maxDaysExpiredCrypts;

  Handler(InputHandler<T> input)
      : protectedCrypts = [input.initialCrypt],
        protectedExpiredCrypts =
            input.initialCrypt.isExpired() ? [input.initialCrypt] : [],
        maxCrypts = input.maxCrypts,
        maxExpiredCrypts = input.maxExpiredCrypts,
        maxDaysExpiredCrypts = input.maxDaysExpiredCrypts;

  /// Protected method to clear all crypts and expired crypts
  @protected
  void cleanCrypts() {
    // Move expired crypts to protectedExpiredCrypts
    final expired = protectedCrypts.where((c) => c.isExpired()).toList();
    protectedExpiredCrypts.addAll(expired);
    protectedCrypts.removeWhere((c) => c.isExpired());
    // Remove expired crypts that are too old
    removeOldExpiredCrypts();
    // Limit the number of expired crypts
    limitExpiredCrypts();
  }

  /// Rimuove da protectedExpiredCrypts quelli che superano maxDaysExpiredCrypts
  @protected
  void removeOldExpiredCrypts() {
    if (maxDaysExpiredCrypts == null || maxDaysExpiredCrypts == 0) {
      // No limit
      return;
    }
    if (maxDaysExpiredCrypts == -1) {
      // Remove all immediately
      protectedExpiredCrypts.clear();
      return;
    }
    final now = DateTime.now();
    protectedExpiredCrypts.removeWhere((c) {
      final expDate = c.expirationDate;
      if (expDate == null) return false;
      return now.difference(expDate).inDays > maxDaysExpiredCrypts!;
    });
  }

  /// Limita il numero di expired crypts a maxExpiredCrypts
  @protected
  void limitExpiredCrypts() {
    if (maxExpiredCrypts == null || maxExpiredCrypts == 0) {
      // Nessun limite
      return;
    }
    if (maxExpiredCrypts == -1) {
      // Elimina tutti subito
      protectedExpiredCrypts.clear();
      return;
    }
    if (protectedExpiredCrypts.length > maxExpiredCrypts!) {
      protectedExpiredCrypts.removeRange(
          0, protectedExpiredCrypts.length - maxExpiredCrypts!);
    }
  }

  @override
  void setNextCrypt(T obj) {
    if (protectedCrypts.length + protectedExpiredCrypts.length >= maxCrypts) {
      throw StateError('Maximum number of crypts reached');
    }
    cleanCrypts();
    if (obj.isExpired()) {
      protectedExpiredCrypts.add(obj);
      return;
    }
    protectedCrypts.add(obj);
  }

  void nextCrypt() {
    if (protectedCrypts.length < 2) {
      throw StateError('No next crypt available');
    }
    final expiredCrypt = protectedCrypts.removeAt(0);
    protectedExpiredCrypts.add(expiredCrypt);
  }

  @override
  T get currentCrypt => protectedCrypts.isNotEmpty
      ? protectedCrypts.first
      : throw StateError('No current crypt available');

  @override
  List<T> get crypts => List.unmodifiable(protectedCrypts);

  @override
  List<T> get expiredCrypts => List.unmodifiable(protectedExpiredCrypts);

  @override
  bool isExpired() => currentCrypt.isExpired();

  @override
  DateTime? get expirationDate => currentCrypt.expirationDate;

  @override
  int? get expirationTimes => currentCrypt.expirationTimes;

  int? get expirationTimesRemaining => currentCrypt.expirationTimesRemaining;

  @override
  CryptoAlgorithm get algorithm => currentCrypt.algorithm;
}
