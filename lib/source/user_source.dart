import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:syth_hotel/config/session.dart';
import '../model/user.dart';

class UserSource {
  static Future<Map<String, dynamic>> signIn(
      String email, String password) async {
    // response ini untuk menampung hasil login dan pesan berhasil ataupun gagal
    Map<String, dynamic> response = {};
    try {
      // Melakukan login menggunakan Firebase Authentication (signInWithEmailAndPassword)
      final credential =
          await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Pesan jika login berhasil
      response['success'] = true;
      response['message'] = 'Sign In Success';

      // Mendapatkan uid
      String uid = credential.user!.uid;
      // Uid didapatkan untuk proses menyimpan data user
      User user = await getWhereId(uid);

      // Menyimpan data user ke dalam Session (GetX Put)
      Session.saveUser(user);
    } on auth.FirebaseAuthException catch (e) {
      response['success'] = false;

      if (e.code == 'user-not-found') {
        response['message'] = 'No user found for that email.';
        // print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        response['message'] = 'Wrong password provided for that user.';
        // print('Wrong password provided for that user.');
      } else {
        response['message'] = 'Sign in failed';
        // print('Wrong password provided for that user.');
      }
    }
    return response;
  }

  // Function tambahan untuk menunjang login
  // Mengambil data user berdasarkan uid yang didapat saat login
  static Future<User> getWhereId(String uid) async {
    // Mendapatkan data user berdasarkan uid (unique id dari masing-masing user)
    DocumentReference<Map<String, dynamic>> ref =
        FirebaseFirestore.instance.collection('User').doc(uid);

    // Mengubah data document menjadi objek User
    DocumentSnapshot<Map<String, dynamic>> doc = await ref.get();
    // !!:  Sebenarnya bisa langsung doc tanpa ref, ref hanya mendeklarasikan kode untuk mendapatkan data
    //      atau bisa dibilang memudahkan kode agar lebih rapi dan mudah dibaca

    // Karena data dari firebase berupa document, maka data harus diubah menjadi objek User dengan fromJson()
    return User.fromJson(doc.data()!);
  }
}
