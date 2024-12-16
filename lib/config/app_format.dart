import 'package:intl/intl.dart';

class AppFormat {
  static String date(String stringDate) {
    // Dari 2022-02-05 menjadi 5 Feb 2022 (Tanggal, Bulan dan Tahun)
    DateTime dateTime = DateTime.parse(stringDate);
    return DateFormat('d MMM yyyy', 'en_US').format(dateTime); // 5 Feb 2022
  }

  static String dateMonth(String stringDate) {
    // Dari 2022-02-05 menjadi 5 Feb (Tanggal dan Bulan saja)
    DateTime dateTime = DateTime.parse(stringDate);
    return DateFormat('d MMM', 'en_US').format(dateTime); // 5 Feb
  }

  // Mengubah angka (double) menjadi US Dollar
  // 123.45 => $123
  static String currency(double number) {
    return NumberFormat.currency(
      // Class function dari package INTL
      decimalDigits: 0, // Jumlah angka dibelakang koma
      locale: 'en_US', // Mata uangnya, jika tidak ada maka gunakan symbol (BTC)
      symbol:
          '\$', // Simbol mata uang (opsional), jika mata uang tidak didukung maka boleh menggunakan symbol
    ).format(number); // Memasukkan angka untuk diformat
  }
}
