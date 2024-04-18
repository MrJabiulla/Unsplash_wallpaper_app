import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper_app/constants/color_constant.dart';
import 'package:wallpaper_app/provider/populer_wallpaper_provider.dart';
import 'package:wallpaper_app/provider/product_provider.dart';
import 'package:wallpaper_app/provider/search_provider.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/screen/splash_screen.dart';

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
            ChangeNotifierProvider(create: (context) => ProductProvider(),),
            ChangeNotifierProvider<PopulerWallpaperProvider>(create: (_) => PopulerWallpaperProvider(),),

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

