import 'package:test/test.dart';
import '../lib/implementations/asymmetric/prime_based/rsa_cipher.dart';
import '../lib/types/crypto_algorithm.dart';
// import '../implementations/asymmetric/prime_based/ecc_cipher.dart'; // ECC test only if implemented

void main() {
  group('AsymmetricCipher', () {
    test('RSA encrypt/decrypt', () {
      final publicKey = '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsB49GdtDJ39FQA22rWbq
Wa0khUTFVUuHpUVPrwoCRCbEYAXgRBjwzKxvANm5TxMI0XHC+XZs5HxKKZHY5c4+
x0twsbzw8GqRktUga9VbQNIoDefT2o9h8ckhgd102wF13c4SDVW7A5kkz7wntyhd
G1KZ7PpXM7PtUlcLWnk0U/FlKHYjGVKjgx2qkjdeBMkGj1dQa2ZBz0E/v1rhsrNc
vK0KIeiaVWGzuS3gJud7fsp+GLzGRgQxEFiSl6mKYCI78nl0gbshxwUjwK7JSs3z
J2AfAKF5tXSW6acVBAx7ILZbqlezBHBS7xAg90eQXWg83jrjZ+g/I33BfKYNWeEW
awIDAQAB
-----END PUBLIC KEY-----''';
      final privateKey = '''-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCwHj0Z20Mnf0VA
DbatZupZrSSFRMVVS4elRU+vCgJEJsRgBeBEGPDMrG8A2blPEwjRccL5dmzkfEop
kdjlzj7HS3CxvPDwapGS1SBr1VtA0igN59Paj2HxySGB3XTbAXXdzhINVbsDmSTP
vCe3KF0bUpns+lczs+1SVwtaeTRT8WUodiMZUqODHaqSN14EyQaPV1BrZkHPQT+/
WuGys1y8rQoh6JpVYbO5LeAm53t+yn4YvMZGBDEQWJKXqYpgIjvyeXSBuyHHBSPA
rslKzfMnYB8AoXm1dJbppxUEDHsgtluqV7MEcFLvECD3R5BdaDzeOuNn6D8jfcF8
pg1Z4RZrAgMBAAECggEAMY8wznfe+9xall3FjCIrzDRm1IG3rfrlHuLUO4Nrg9YM
6KB+rWr/R/k1+11JQjEvCBElNqHWnq1DCVObX3+cNuTJv5pVirHSaSlESFPvq9v3
nYIhIZ27iBh7L1osKfzNOC9m8Q2w5KBRtYtS+b2IBcpGumLv6wK0w7ju3vTAfuY1
a7p6IIjiX1wlJwokEjVBFS2w1v7jZlO7myW1OOCe7Bdow3mwK8fwCs8odRCEW5GY
8tm9BUPAh52SgLb3ZdXvYTsAy4kPJCVmwCceuK5W4s7vrtFjWeg3bpJKPIQ6fCM9
U9DOuCZczJMkPmSa7xYKSlEZYEE/VFi3PYciwmCuEQKBgQDa+4XM0vOFl0+qfM62
lZNCFUyVsn7+N6dOoL585+jIzGciwVcsW5zpgd6X6dyhgcJVq3TqQTSH1agy5Q4f
Dh1A3l0H0eXEwpjj1iN8fR2wOG9MaJNU051Il5aOpaTUTkY09S9qjamp6PqI3nyn
bm//syPjG7x4p+7QeXQ9xsI7vQKBgQDN48H5rBSBgKlDXS9rbzEOw4TilHuC7gno
6tfNAVjkcMg1y2umQg+yN/yywsolB6NJ7iVL8bMfs5gbiUaaQYmkVOdlvRsmQKH1
RLgf6fbI5nm91LOw2ATfrNo80Gt/K/oHPOMsmswIdX84S08Y9549qcB4EypdfVzA
kCsdtKppRwKBgAYKilZsO2ukEP6TEuDWn4ljLQm0MuywfF0e8iJgA3wGp5G947nF
jT6j5pAqU3vhKItUf5U210woCMvepdUVfpkbiVV95OjYtX8TmUcF7Ju/8tIY0He2
ntAx3mVxDGsO/cDYQsadweB+HOtJuAamdVCIkKTjTv/FIkF+GEbcBN/BAoGBAJ3N
MMDhqR3QtOqSo2OeZ2U/abwXvcqOEz5XsGrJ243K+0hvzuQwwcMAskd4kGJtRjPF
uQRKDdYAWlbQkjJshMhU4r3RgNuCsh9AOjcLpUA5lZlvSwIBr0qYOvRdceaYmBuw
CRYI1tSs6YMGBWvHbZspXgEp/1CEYvCcDs/HxszFAoGAAM5UWLg7Bwc+u2xaMWAb
Mqq+H4NPVgR92OeuMJOoyYtt+9+kdLDkOLfdX0m8vfRc70YZnDFpBha+TD8Lk9nw
HYQO19pjopyeTzV0EdPNxPrZzcLanxf1CwcTOkYmzRv2WEv/j2PRjeoHw5JRvOSc
bX2NFAnbaGQW/Wnmw0lnXnk=
-----END PRIVATE KEY-----''';
      final cipher = RSACipher((
        parent: (
          publicKey: publicKey,
          privateKey: privateKey,
          parent: (
            parent: (
              algorithm: CryptoAlgorithm.RSA,
              expirationDate: DateTime.now().add(Duration(days: 1)),
              expirationTimes: null,
            ),
          ),
        ),
      ));
      final data = [1, 2, 3, 4, 5];
      final encrypted = cipher.encrypt(data);
      final decrypted = cipher.decrypt(encrypted);
      expect(decrypted, equals(data));
    });
    // test('ECC encrypt/decrypt', () {
    //   // Implement ECC test if ECCCipher is fully implemented
    // });
  });
}
