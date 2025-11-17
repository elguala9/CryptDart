

import 'i_expiration.dart';

// IExpritaion work on the actual (kind of [0])
abstract class IHandlerExpiration implements IExpiration {
  void setNextCrypt(IExpiration obj);
  List<IExpiration> get crypts;
  void deleteCrypt(int index);
}