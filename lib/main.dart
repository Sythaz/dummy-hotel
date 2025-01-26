import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:syth_hotel/config/app_color.dart';
import 'package:syth_hotel/config/app_route.dart';
import 'package:syth_hotel/config/session.dart';
import 'package:syth_hotel/model/user.dart';
import 'package:syth_hotel/page/checkout_page.dart';
import 'package:syth_hotel/page/detail_booking_page.dart';
import 'package:syth_hotel/page/detail_page.dart';
import 'package:syth_hotel/page/home_page.dart';
import 'package:syth_hotel/page/intro_page.dart';
import 'package:syth_hotel/page/signin_page.dart';
import 'firebase_options.dart';
import 'page/checkout_success_page.dart';

Future<void> main() async {
  // debugPaintSizeEnabled = true; // Menampilkan batas layout
  WidgetsFlutterBinding
      .ensureInitialized(); // Menjaga komponen bekerja dengan baik
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeDateFormatting('en_US');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // Flutter menyediakan beberapa template tema seperti: textTheme, scaffoldBackgroundColor, primaryColor, dan colorScheme, dll
      // Yang bertujuan memberikan "konsistensi" tema (warna, font, dll) di seluruh aplikasi
      // Kita bisa mengubah template dengan sesuai yang diingkan:
      theme: ThemeData(
        // Seluruh teks menggunakan font Poppins
        textTheme: GoogleFonts.poppinsTextTheme(),
        // Background Scaffold tiap halaman
        scaffoldBackgroundColor: AppColor.backgroundScaffold,
        primaryColor: AppColor.primary, // Warna utama
        colorScheme: const ColorScheme.light(
          // Warna tema terang, jika gelap bisa diganti dengan ColorScheme.dark
          primary: AppColor.primary,
          secondary: AppColor.secondary,
        ),
      ),
      routes: {
        '/': (context) {
          return FutureBuilder(
            future: Session.getUser(),
            builder: (context, AsyncSnapshot<User> snapshot) {
              // Validasi 1: Jika data user masih kosong
              // Validasi 2: Jika user melakukan login dan akun salah/tidak ada
              if (snapshot.data == null || snapshot.data!.id == null) {
                return const IntroPage();
              } else {
                return HomePage();
              }
            },
          );
        },
        AppRoute.intro: (context) => const IntroPage(),
        AppRoute.home: (context) => HomePage(),
        AppRoute.signin: (context) => SigninPage(),
        AppRoute.detail: (context) => DetailPage(),
        AppRoute.checkout: (context) => CheckoutPage(),
        AppRoute.checkoutSuccess: (context) => const CheckoutSuccessPage(),
        AppRoute.detailBooking: (context) => DetailBookingPage(),
      },
    );
  }
}
