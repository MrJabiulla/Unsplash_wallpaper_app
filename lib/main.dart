import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper_app/constants/color_constant.dart';
import 'package:wallpaper_app/provider/product_provider.dart';
import 'package:wallpaper_app/provider/searchProvider.dart';
import 'package:wallpaper_app/screen/bottom_nevigation.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/screen/home_tab.dart';
import 'package:wallpaper_app/screen/homepage_screen.dart';
import 'package:wallpaper_app/screen/splash_screen.dart';

import 'allwallpepar.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle( const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black));
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<ProductProvider>(create: (context) => ProductProvider()),
            ChangeNotifierProvider(create: (context) => PhotoSearchProvider()),
            ChangeNotifierProvider(create: (context) => ProductProvider(),)

          ],
          child: const MyApp()
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colorAppTextWhite),
        scaffoldBackgroundColor: colorAppBackground,
        appBarTheme: const AppBarTheme(
          color: colorAppBackground,
        ),
        useMaterial3: true,
      ),
      home:SplashScreen(),
    );
  }
}

