import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syth_hotel/config/app_asset.dart';
import 'package:syth_hotel/config/app_color.dart';
import 'package:syth_hotel/controller/c_home.dart';
import 'package:syth_hotel/page/nearby_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final cHome = Get.put(CHome());
  final List<Map<String, String>> listNav = [
    {'icon': AppAsset.iconNearby, 'label': 'Nearby'},
    {'icon': AppAsset.iconHistory, 'label': 'History'},
    {'icon': AppAsset.iconPayment, 'label': 'Payment'},
    {'icon': AppAsset.iconReward, 'label': 'Reward'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (cHome.indexPage == 1) {
          return const Center(child: Text('History'));
        } else if (cHome.indexPage == 2) {
          return const Center(child: Text('Payment'));
        } else if (cHome.indexPage == 3) {
          return const Center(child: Text('Reward'));
        } else {
          return NearbyPage();
        }
      }),
      bottomNavigationBar: Obx(() {
        return Material(
          elevation: 8,
          child: Container(
            color: Colors.white,
            child: BottomNavigationBar(
              currentIndex: cHome.indexPage,
              onTap: (value) => cHome.indexPage = value,

              elevation: 0,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,

              // Style selected
              selectedItemColor: Colors.black,
              selectedIconTheme: const IconThemeData(color: AppColor.primary),
              selectedFontSize: 12,
              selectedLabelStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),

              // Style unselected
              unselectedItemColor: Colors.grey,

              // Perulangan untuk menampilkan item button
              items: listNav.map((e) {
                return BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage(e['icon'] ?? '')),
                  label: e['label'] ?? '',
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}
