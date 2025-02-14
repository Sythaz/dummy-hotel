import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syth_hotel/config/app_asset.dart';
import 'package:syth_hotel/config/app_color.dart';
import 'package:syth_hotel/config/app_format.dart';
import 'package:syth_hotel/config/app_route.dart';
import 'package:syth_hotel/controller/c_user.dart';
import 'package:syth_hotel/widget/button_custom.dart';

import '../model/booking.dart';
import '../model/hotel.dart';
import '../source/booking_source.dart';

class DetailPage extends StatelessWidget {
  DetailPage({super.key});

  final cUser = Get.put(CUser());

  final Rx<Booking> _bookedData = initBooking.obs;
  Booking get bookedData => _bookedData.value;
  set bookedData(Booking n) => _bookedData.value = n;

  // Untuk kebutuhan menampilkan gambar facilities sesuai dengan index
  // Sehingga perlu list map
  final List facilities = [
    {'icon': AppAsset.iconCoffe, 'label': 'Lounge'},
    {'icon': AppAsset.iconOffice, 'label': 'Office'},
    {'icon': AppAsset.iconWifi, 'label': 'Wi-Fi'},
    {'icon': AppAsset.iconStore, 'label': 'Store'},
  ];

  @override
  Widget build(BuildContext context) {
    Hotel hotel = ModalRoute.of(context)!.settings.arguments as Hotel;
    BookingSource.checkIsBooked(cUser.data.id!, hotel.id).then(
      (bookingValue) {
        bookedData = bookingValue ?? initBooking;
      },
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          'Hotel Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      // bottomNavigationBar: bookingNow(hotel, context),
      // bottomNavigationBar: viewReceipt(),
      bottomNavigationBar: Obx(
        () {
          if (bookedData.id == '') {
            return bookingNow(hotel, context);
          }
          return viewReceipt(context);
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            images(hotel),
            const SizedBox(height: 16),
            name(hotel, context),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(hotel.description),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Facilities',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            gridFacilities(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Activities',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            activities(hotel),
          ],
        ),
      ),
    );
  }

  Container viewReceipt(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[100]!, width: 1.5),
        ),
      ),
      height: 80,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          // Pemilihan penggunaan Expanded daripada spaceBetween
          // Karena spaceBetween akan rusak jika ada text yang terlalu panjang (overflow)
          // Sedangkan expanded aman (cocok jika terdapat fitur ganti bahasa)
          const Expanded(
            child: Text(
              'You booked this.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(20),
            color: AppColor.secondary,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.pushNamed(context, AppRoute.detailBooking,
                    arguments: bookedData);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 14,
                ),
                child: Text(
                  'View Receipt',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container bookingNow(Hotel hotel, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[100]!, width: 1.5),
        ),
      ),
      height: 80,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppFormat.currency(hotel.price.toDouble()),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppColor.secondary,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const Text(
                  ' per night',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          ButtonCustom(
            label: 'Booking Now',
            onTap: () {
              Navigator.pushNamed(context, AppRoute.checkout, arguments: hotel);
            },
          ),
        ],
      ),
    );
  }

  SizedBox activities(Hotel hotel) {
    return SizedBox(
      height: 105,
      child: ListView.builder(
        itemCount: hotel.activities.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // Mengambil data dari hotel.activities berdasarkan index
          Map activity = hotel.activities[index];
          return Padding(
            padding: EdgeInsets.fromLTRB(
              index == 0 ? 16 : 8,
              0,
              index == hotel.activities.length - 1 ? 16 : 8,
              0,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      activity['image'],
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(activity['name']),
              ],
            ),
          );
        },
      ),
    );
  }

  GridView gridFacilities() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      itemCount: facilities.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(AssetImage(facilities[index]['icon'])),
              const SizedBox(height: 4),
              Text(
                facilities[index]['label'],
                style: const TextStyle(
                  fontSize: 13,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Padding name(Hotel hotel, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  hotel.location,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.star, color: AppColor.starActive),
          const SizedBox(width: 4),
          Text(
            hotel.rate.toString(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox images(Hotel hotel) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        itemCount: hotel.images.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              index == 0 ? 16 : 8,
              0,
              index == hotel.images.length - 1 ? 16 : 8,
              0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                hotel.images[index],
                fit: BoxFit.cover,
                height: 180,
                width: 240,
              ),
            ),
          );
        },
      ),
    );
  }
}
