import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syth_hotel/model/booking.dart';

class BookingSource {
  static Future<Booking?> checkIsBooked(String userId, String hotelId) async {
    var result = await FirebaseFirestore.instance
        .collection('User')
        .doc(userId)
        .collection('Booking')
        .where('id_hotel', isEqualTo: hotelId)
        .where('is_done', isEqualTo: false)
        .get();
    if (result.size > 0) {
      return Booking.fromJson(result.docs.first.data());
    }
    return null;
  }

  // Sebuah fungsi untuk menambahkan data booking kedalam firebase
  static Future<bool> addBooking(String userId, Booking booking) async {
    var ref = FirebaseFirestore.instance
        .collection('User')
        .doc(userId)
        .collection('Booking');
    // Setelah instansiasi alamat collection, kita dapat menambahkan data menggunakan add
    // Sebelum itu, ubah data booking (model) menjadi Json (map)
    var docRef = await ref.add(booking.toJson());

    // Karena id dari kumpulan data yang baru saja ditambahkan tidak ada (kecuali lihat langsung di firebase)
    // Maka kita dapat menambahkan id tersebut menggunakan update agar data tersebut dapat diakses atau di ubah-ubah
    docRef.update({'id': docRef.id});
    return true;
  }

  // Sebuah fungsi untuk mengambil data booking user dari firebase
  static Future<List<Booking>> getHistory(String id) async {
    var result = await FirebaseFirestore.instance
        .collection('User')
        .doc(id)
        .collection('Booking')
        .get();
    // Mengubah data JSON dari Firebase menjadi objek Booking (model)
    return result.docs.map((e) => Booking.fromJson(e.data())).toList();
  }
}
