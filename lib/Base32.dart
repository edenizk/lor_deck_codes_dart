import 'dart:collection';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';

class Base32 {
  static String _digits = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  static int _mask = _digits.length - 1;
  static int _shift = _numberOfTrailingZeros(Int32(_digits.length));
  static int _index = 0;
  static Map<String, int> _charMap = HashMap.fromIterable(_digits.split(''),
      key: (item) => item.toString(), value: (item) => _index++);

  static final String _separator = '-';

  //dart does't support static constructor,
  //until find something works like static constructor
  //we need to asign objects before constructor
  Base32() {}

  String getDigits() {
    return _digits;
  }

  static int _numberOfTrailingZeros(Int32 i) {
    Int32 y;
    if (i == 0) return 32;
    Int32 n = Int32(31);
    y = i << 16;
    if (y != 0) {
      n = n - 16;
      i = y;
    }
    y = i << 8;
    if (y != 0) {
      n = n - 8;
      i = y;
    }
    y = i << 4;
    if (y != 0) {
      n = n - 4;
      i = y;
    }
    y = i << 2;
    if (y != 0) {
      n = n - 2;
      i = y;
    }
    return (n - ((i << 1) >> 31)).toInt();
  }

  static Uint8List Decode(String encoded) {
    encoded = encoded.trim().replaceAll(Base32._separator, '');
    encoded = encoded.replaceAll(RegExp('[=]*\$'), '');

    encoded = encoded.toUpperCase();

    if (encoded.isEmpty) return [0] as Uint8List;

    final int encodedLength = encoded.length;

    int outLength = (encodedLength * _shift / 8).floor();

    Uint8List result = Uint8List(outLength);

    int buffer = 0;
    int next = 0;
    int bitsLeft = 0;
    for (var c in encoded.split('')) {
      if (!_charMap.containsKey(c)) {
        throw DecodingException('Illegal character: ' + c);
      }

      buffer <<= _shift;
      buffer |= _charMap[c] & _mask;
      bitsLeft += _shift;
      if (bitsLeft >= 8) {
        result[next++] = (buffer >> (bitsLeft - 8)) & 0xff;
        bitsLeft -= 8;
      }
    }

    return result;
  }

  static String Encode(List<Uint8List> data, [padOutput = false]) {
    if (data.isEmpty) return '';
    if (data.length >= (1 << 28)) {
      throw ArgumentError('Array is too long for this');
    }

    // StringBuffer does not requires length, because of that there is no point
    // to calculate output Length
    // final outputLength = ((data.length * 8 + _shift - 1) / _shift).floor();
    StringBuffer result = StringBuffer();

    int buffer = data[0].first;
    int next = 1;
    int bitsLeft = 8;
    while (bitsLeft > 0 || next < data.length) {
      if (bitsLeft < _shift) {
        if (next < data.length) {
          buffer <<= 8;

          buffer |= data[next++].first & 0xff;
          bitsLeft += 8;
        } else {
          int pad = _shift - bitsLeft;
          buffer <<= pad;
          bitsLeft += pad;
        }
      }
      int index = _mask & (buffer >> (bitsLeft - _shift));
      bitsLeft -= _shift;
      result.write(_digits[index]);
    }
    if (padOutput) {
      int padding = 8 - (result.length % 8);
      if (padding > 0) result.write('='.padLeft(padding == 8 ? 0 : padding));
    }

    return result.toString();
  }
}

class DecodingException implements Exception {
  DecodingException(String message) : super() {}
}
