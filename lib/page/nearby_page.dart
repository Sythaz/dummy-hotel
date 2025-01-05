// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syth_hotel/config/app_asset.dart';
import 'package:syth_hotel/config/app_color.dart';
import 'package:syth_hotel/controller/c_nearby.dart';

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
        categories()
      ],
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
                    color: category == _.category
                        ? AppColor.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {},
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
