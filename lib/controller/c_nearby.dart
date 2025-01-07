import 'package:get/get.dart';
import 'package:syth_hotel/model/hotel.dart';
import 'package:syth_hotel/source/hotel_source.dart';

// Menggunakan getter dan setter yang sudah disediakan oleh GetX
class CNearby extends GetxController {
  final _category = 'All Place'.obs;

  String get category => _category.value;

  // List kategori hotel yg akan digunakan untuk filter di Nearby Page
  List<String> get categories => [
        'All Place',
        'Industrial',
        'Village',
      ];

  // Setter untuk mengubah value obs _category menjadi salah satu categories hotel
  set category(n) {
    _category.value = n;
    // Karena memilih menggunakan update(), jadi widget pembungkusnya harus menggunakan GetBuilder() dan bukan Obx()
    update();
  }

  // Instansiasi penyimpanan list data hotel
  final _listHotel = <Hotel>[].obs;
  
  List<Hotel> get listHotel => _listHotel.value;

  // Memanggil list data hotel dari sumber data (hotel_source)
  getListHotel() async {
    // Dipisah karena untuk memisahkan logika bisnis (pengambilan data) dengan controller
    _listHotel.value = await HotelSource.getHotel();
    update();
  }

  // Saat inisialisasi atau CNearby dipanggil, akan memanggil fungsi getListHotel sehingga mendapatkan data
  // Jika ingin data diperbarui saat scroll dari atas, bisa menggunakan refreshIndicator()
  @override
  void onInit() {
    getListHotel();
    super.onInit();
  }
}
