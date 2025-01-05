import 'package:get/get.dart';

// Menggunakan getter dan setter yang sudah disediakan oleh GetX
class CNearby extends GetxController {
  final _category = 'All Place'.obs;

  String get category => _category.value;

  set category(n) {
    _category.value = n;
    // Karena memilih menggunakan update(), jadi menggunakan GetBuilder() nantinya dan bukan Obx()
    update();
  }

  List<String> get categories => [
        'All Place',
        'Industrial',
        'Village',
      ];
}
