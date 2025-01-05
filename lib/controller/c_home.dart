import 'package:get/get.dart';

// Sebuah controller untuk mengambil dan mengatur index halaman utama
// Menggunakan getter dan setter dari GetX
class CHome extends GetxController {
  final _indexPage = 0.obs;
  int get indexPage => _indexPage.value;
  set indexPage(n) => _indexPage.value = n;
}
