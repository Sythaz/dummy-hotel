import 'package:get/get.dart';
import 'package:syth_hotel/model/hotel.dart';
import 'package:syth_hotel/source/hotel_source.dart';

// Menggunakan getter dan setter yang sudah disediakan oleh GetX
class CNearby extends GetxController {
  // --------------------- Filter berdasarkan kategori -------------------------

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
    // Saat menu category diubah, maka fungsi filter by category dan _applyFilters() (name) dijalankan lagi
    _category.value = n;
    _applyFilters();

    // Karena memilih menggunakan update(), jadi widget pembungkusnya harus menggunakan GetBuilder() dan bukan Obx()
    update();
  }

  // --------------------- Filter berdasarkan pencarian ------------------------

  // Instansiasi penyimpanan list data hotel
  final _listHotel = <Hotel>[].obs;
  final _filteredListHotel = <Hotel>[].obs;

  List<Hotel> get listHotel => _filteredListHotel.value;

  // Memanggil list data hotel dari sumber data (hotel_source)
  getListHotel() async {
    // Dipisah karena untuk memisahkan logika bisnis (pengambilan data) dengan controller
    _listHotel.value = await HotelSource.getHotel();
    _applyFilters();

    update();
  }

  // Fungsi untuk menerapkan filter berdasarkan kategori dan pencarian
  void _applyFilters({String searchQuery = ''}) {
    List<Hotel> tempList = _listHotel;

    // Filter berdasarkan kategori jika tidak All Place
    if (category != 'All Place') {
      tempList = tempList.where((hotel) => hotel.category == category).toList();
    }

    // Setelah filter kategori, filter berdasarkan pencarian dilakukan
    if (searchQuery.isNotEmpty) {
      tempList = tempList
          .where((hotel) =>
              hotel.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    _filteredListHotel.value = tempList;
  }

  void searchHotel(String query) {
    _applyFilters(searchQuery: query);
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


// --- Penjelasan alur filter ----

// Ketika Nearby Page pertama kali dibuka, fungsi onInit() akan dijalankan untuk mengambil data asli dari
// sumber data menggunakan getListHotel(). Data yang berhasil diambil akan disimpan ke dalam variabel _listHotel.
// Karena kategori awal secara default adalah 'All Place', tidak ada filter kategori yang diterapkan, sehingga
// seluruh data asli langsung disalin ke variabel _filteredListHotel untuk ditampilkan ke pengguna.

// Jika pengguna mulai mengetik sesuatu di search field, fungsi searchHotel(query) akan dipanggil.
// Fungsi ini bertugas untuk menjalankan applyFilters(), yang akan memfilter data berdasarkan kategori
// dan query pencarian. Dalam applyFilters, alur akan bercabang tergantung pada kategori yang dipilih.

// Jika kategori saat ini adalah 'All Place', maka seluruh data asli di _listHotel akan difilter hanya
// berdasarkan query pencarian menggunakan fungsi .where(). Namun, jika kategori yang dipilih berbeda,
// data di _listHotel terlebih dahulu difilter berdasarkan kategori tersebut, kemudian hasilnya difilter
// kembali berdasarkan query yang dimasukkan.

// Ketika kategori diubah oleh pengguna, setter category akan secara otomatis memanggil kembali applyFilters().
// Filter baru akan diterapkan ke data asli tanpa perlu mengambil ulang data dari sumber. Jika query pencarian
// sebelumnya masih ada, maka filter akan tetap mengacu pada query tersebut. Sebaliknya, jika query dihapus,
// applyFilters() akan menampilkan seluruh data berdasarkan kategori tanpa menerapkan filter pencarian.

// Pendekatan ini memastikan bahwa data asli di _listHotel tidak pernah diubah, sehingga memudahkan
// pengelolaan data dan memungkinkan sistem untuk fleksibel serta efisien dalam memproses filter dan pencarian.