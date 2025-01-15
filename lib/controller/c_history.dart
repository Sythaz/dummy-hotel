import 'package:get/get.dart';

import '../model/booking.dart';
import '../source/booking_source.dart';

// Controller untuk history page
class CHistory extends GetxController {
  // Untuk menangani ListView di halaman History
  final _listBooking = <Booking>[].obs;

  List<Booking> get listBooking => _listBooking.value;

  getListBooking(String id) async {
    _listBooking.value = await BookingSource.getHistory(id);
    update();
  }
}
