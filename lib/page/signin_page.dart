// ignore_for_file: prefer_const_constructors

import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:syth_hotel/config/app_asset.dart';
import 'package:syth_hotel/config/app_color.dart';
import 'package:syth_hotel/config/app_route.dart';
import 'package:syth_hotel/source/user_source.dart';
import 'package:syth_hotel/widget/button_custom.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Mengirim email dan password ke UserSource untuk dilakukan proses login
  // Bisa diletakkan di file/folder yang berbeda (Enkapsulasi)
  login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      UserSource.signIn(controllerEmail.text, controllerPassword.text).then(
        (response) {
          if (response['success']) {
            DInfo.dialogSuccess(context, response['message']);
            DInfo.closeDialog(context, actionAfterClose: () {
              Navigator.pushReplacementNamed(context, AppRoute.home);
            });
          } else {
            DInfo.dialogError(context, response['message']);
            DInfo.closeDialog(context);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          // Menggunakan SCSV untuk mengatasi jika keyboard muncul/orientasi menjadi horizontal tidak terjadi overflow
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // minHeight: MediaQuery.of(context).size.height,
                // Tidak menggunakan MediaQuery karena dengan menggunakan constraints LayoutBuilder membuat lebih ukuran sisa ruang menjadi lebih akurat
                minHeight: constraints.maxHeight,
              ),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAsset.logo,
                        width: 180,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(height: 80),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign In\nTo Your Account',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        style: TextStyle(fontWeight: FontWeight.w500),
                        validator: (value) =>
                            value == '' ? 'Email cannot be empty' : null,
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerEmail,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          hintText: 'Email Address',
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          // Border saat focuse
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor.secondary, width: 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        style: TextStyle(fontWeight: FontWeight.w500),
                        validator: (value) =>
                            value == '' ? 'Password cannot be empty' : null,
                        obscureText: true,
                        controller: controllerPassword,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          hintText: 'Password',
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xFF123E56), width: 1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      ButtonCustom(
                        label: 'Sign In',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            login(context);
                          }
                        },
                        isExpand: true,
                      ),
                      SizedBox(height: 30),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Create new account',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFAFAFAF)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
