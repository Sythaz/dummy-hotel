import 'package:flutter/material.dart';
import 'package:syth_hotel/config/app_asset.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(AppAsset.logo),
        ],
      ),
    );
  }
}
