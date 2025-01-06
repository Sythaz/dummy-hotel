import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syth_hotel/model/hotel.dart';

class HotelSource {
  static Future<List<Hotel>> getHotel() async {
    // Mengambil semua data firebase dari collection 'Hotel'
    var dataCollection =
        await FirebaseFirestore.instance.collection('Hotel').get();

    // result.docs => Mengambil daftar document dari collection 'Hotel'
    // map Hotel.fromJson(e.data()))
    //    => Mengubah setiap dokumen (yang berupa map) menjadi objek Hotel menggunakan fungsi Hotel.fromJson
    var rawResult = dataCollection.docs.map((e) => Hotel.fromJson(e.data()));

    // toList(): Mengembalikan hasil map sebagai list
    return rawResult.toList();
  }
}
