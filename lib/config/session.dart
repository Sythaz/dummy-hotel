import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syth_hotel/controller/c_user.dart';
import 'package:syth_hotel/model/user.dart';

class Session {
  static Future<bool> saveUser(User user) async {
    final pref = await SharedPreferences.getInstance(); // Instansiasi ShPref

    // Mengubah objek User ke Map User(id: "123", name: "John") => {id: "123", name: "John"}
    Map<String, dynamic> mapUser = user.toJson();

    // Mengubah JSON ke String dengan menambahkan '' di awal dan akhir
    String stringUser = jsonEncode(mapUser);

    // Menyimpan String User (encode) ke ShPref dengan setString bernama 'user'
    // Seperti menaruh apel yang sudah disiapkan(instansiasi) kedalam kotak bernama 'user'
    bool success = await pref.setString('user', stringUser);

    if (success) {
      // Menyimpan class CUser agar tiap perubahan melalui function class tersebut (reaktif GetX)
      final cUser = Get.put(CUser());
      // Disinilah data user ditambahkan dengan menggunakan function class CUser itu sendiri
      cUser.setData(user);
    }
    return success;
  }

  static Future<User> getUser() async {
    User user = User(); // default value
    final pref = await SharedPreferences.getInstance();
    String? stringUser = pref.getString('user');
    if (stringUser != null) {
      // Menghapus '' di awal dan akhir String Map yang tersimpan
      Map<String, dynamic> mapUser = jsonDecode(stringUser);
      // Mengubah Map menjadi objek User
      user = User.fromJson(mapUser);
    }
    // Diperlukan put dan setData di getUser yaitu untuk membuat halaman menjadi reaktif terhadap data user
    final cUser = Get.put(CUser());
    cUser.setData(user);
    return user;
  }

  static Future<bool> clearUser() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('user');
    // Diperlukan put dan setData di clearUser yaitu untuk membuat halaman menjadi reaktif terhadap data user
    final cUser = Get.put(CUser());
    // Dapat dilihat setData tidak mengembalikan user seperti fungsi lainnya, karena data user dihapus sehingga menyimpan objek User() kosong
    cUser.setData(User());
    return success;
  }
}
