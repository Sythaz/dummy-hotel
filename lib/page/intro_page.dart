// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:syth_hotel/config/app_asset.dart';
import 'package:syth_hotel/config/app_route.dart';
import 'package:syth_hotel/widget/button_custom.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAsset.bgIntro,
            fit: BoxFit.cover,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Great Life\nStarts here',
                  // Template style terutama text digunakan disini, "copyWith" untuk merubah style yang belum dideklarasikan
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                SizedBox(height: 8),
                Text(
                  'More than just a hotel',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                ),
                SizedBox(height: 30),
                ButtonCustom(
                  label: 'Get Started',
                  onTap: () =>
                      // Mirip dengan popAndPushNamed() hanya saja ini animasi masuk sedangkan popAndPushNamed() animasi keluar
                      Navigator.pushReplacementNamed(context, AppRoute.signin),
                  isExpand: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
