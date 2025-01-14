// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:syth_hotel/config/app_asset.dart';
import 'package:syth_hotel/config/app_color.dart';
import 'package:syth_hotel/config/app_format.dart';
import 'package:syth_hotel/config/app_route.dart';
import 'package:syth_hotel/controller/c_nearby.dart';
import 'package:syth_hotel/model/hotel.dart';

class NearbyPage extends StatelessWidget {
  NearbyPage({super.key});
  final cNearby = Get.put(CNearby());

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 24),
        header(context),
        SizedBox(height: 20),
        searchField(),
        SizedBox(height: 30),
        categories(),
        SizedBox(height: 30),
        hotels(),
      ],
    );
  }

  GetBuilder<CNearby> hotels() {
    return GetBuilder<CNearby>(
      builder: (_) {
        // Menyimpan data list hotel berdasarkan kategori yang dipilih
        List<Hotel> list = _.category == 'All Place'
            ? _.listHotel
            : _.listHotel.where((e) => e.category == _.category).toList();
        return list.isEmpty
            ? Center(child: Text('Data not found'))
            : ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // Mengambil data hotel berdasarkan index
                  Hotel hotel = list[index];
                  // Mengirimkan data hotel yang dipilih ke halaman detail hotel
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoute.detail,
                        arguments: hotel,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        16,
                        index == 0 ? 0 : 8,
                        16,
                        index == list.length - 1 ? 16 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            // Menggunakan AspectRatio untuk mengatur rasio aspek gambar
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                hotel.cover,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Menggunakan Expanded untuk membuat nama hotel dan harga mengambil ruang yang tersisa
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hotel.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                        // Jika teks terlalu panjang (maks 1 baris text) maka akan diabaikan dan ditampilkan dengan ...
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            'Start from ',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                          ),
                                          // Format currency digunakan disini
                                          Text(
                                            AppFormat.currency(
                                                hotel.price.toDouble()),
                                            style: TextStyle(
                                                color: AppColor.secondary,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '/night',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Sebuah package futter_rating_bar untuk menambahkan widget rating
                                RatingBar.builder(
                                  initialRating: hotel.rate,
                                  minRating: 0,
                                  itemCount: 5,
                                  allowHalfRating: true,
                                  direction: Axis.horizontal,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: AppColor.starActive,
                                  ),
                                  unratedColor: AppColor.starInactive,
                                  itemSize: 18,
                                  ignoreGestures: true,
                                  onRatingUpdate: (rating) {},
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  GetBuilder<CNearby> categories() {
    return GetBuilder<CNearby>(
      // _ itu sama dengan defaultnya yaitu controller, hanya untuk memudahkan penulisan
      builder: (_) {
        // Menggunakan SizedBox karena behavior ListView adalah expand secara default
        // Sehingga butuh pembungkus seperti SizedBox agar dapat menentukan tinggi ListView
        return SizedBox(
          height: 45,
          child: ListView.builder(
            itemCount: _.categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              String category = _.categories[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  // Untuk item pertama dan terakhir akan diberi padding 16 dan untuk item lainnya diberi padding 8
                  // Jika index 0 maka padding kiri 16, jika tidak maka padding kiri 8
                  index == 0 ? 16 : 8,
                  0,
                  // Jika index terakhir maka padding kanan 16, jika tidak maka padding kanan 8
                  index == cNearby.categories.length - 1 ? 16 : 8,
                  0,
                ),
                child: Material(
                  color:
                      category == _.category ? AppColor.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      _.category = category;
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        category,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Container searchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Search by name or city here',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: AppColor.secondary,
              borderRadius: BorderRadius.circular(45),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(45),
                child: SizedBox(
                  height: 45,
                  width: 45,
                  child: Center(
                    child: ImageIcon(
                      AssetImage(AppAsset.iconSearch),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              AppAsset.profile,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Near Me',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                '100 hotels',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          )
        ],
      ),
    );
  }
}
