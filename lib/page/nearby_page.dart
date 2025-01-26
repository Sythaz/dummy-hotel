import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syth_hotel/config/app_asset.dart';
import 'package:syth_hotel/config/app_color.dart';
import 'package:syth_hotel/config/app_format.dart';
import 'package:syth_hotel/config/app_route.dart';
import 'package:syth_hotel/config/session.dart';
import 'package:syth_hotel/controller/c_nearby.dart';
import 'package:syth_hotel/model/hotel.dart';

import '../controller/c_user.dart';

class NearbyPage extends StatelessWidget {
  NearbyPage({super.key});
  final cNearby = Get.put(CNearby());
  final cUser = Get.put(CUser());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 24),
        header(context),
        const SizedBox(height: 20),
        searchField(),
        const SizedBox(height: 30),
        categories(),
        const SizedBox(height: 30),
        hotels(),
      ],
    );
  }

  GetBuilder<CNearby> hotels() {
    return GetBuilder<CNearby>(
      builder: (_) {
        // Saat terjadi loading pengambilan data
        if (_.isLoading == true) {
          return shimmer();
        }

        // Jika terjadi error saat pengambilan data
        if (_.isError.value == true) {
          return const Center(
            child: Text(
              'Terjadi kesalahan saat mengambil data!',
            ),
          );
        } else {
          // Menyimpan data list hotel berdasarkan kategori yang dipilih
          List<Hotel> list = _.category == 'All Place'
              ? _.listHotel
              : _.listHotel.where((e) => e.category == _.category).toList();

          return list.isEmpty
              ? const Center(child: Text('Data hotel sedang kosong!'))
              : ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                              borderRadius: const BorderRadius.only(
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
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Text(
                                              'Start from ',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13),
                                            ),
                                            // Format currency digunakan disini
                                            Text(
                                              AppFormat.currency(
                                                  hotel.price.toDouble()),
                                              style: const TextStyle(
                                                  color: AppColor.secondary,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
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
                                    itemBuilder: (context, _) => const Icon(
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
        }
      },
    );
  }

  ListView shimmer() {
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.fromLTRB(
            16,
            index == 0 ? 0 : 8,
            16,
            index == 2 ? 16 : 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                // Menggunakan AspectRatio untuk mengatur rasio aspek gambar
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              margin: EdgeInsets.only(right: 16),
                              width: double.infinity,
                              height: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 80,
                              height: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Sebuah package futter_rating_bar untuk menambahkan widget rating
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 80,
                        height: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 30),
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
              controller: searchController,
              onChanged: (value) {
                cNearby.searchHotel(value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Search by name or city here',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(
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
                child: const SizedBox(
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
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showMenu(
                    context: context,
                    position: const RelativeRect.fromLTRB(16, 16, 0, 0),
                    items: [
                      const PopupMenuItem(
                        value: 'logout',
                        child: Text('Logout'),
                      ),
                    ],
                  ).then(
                    (value) {
                      if (value == 'logout') {
                        Session.clearUser();
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoute.signin,
                        );
                      }
                    },
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    AppAsset.profilKu,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Hi, ${cUser.data.name}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
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
              Obx(
                () {
                  return Text(
                    '${cNearby.listHotel.length} hotels',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
