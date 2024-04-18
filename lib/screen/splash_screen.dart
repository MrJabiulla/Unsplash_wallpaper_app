import 'package:flutter/material.dart';
import 'package:wallpaper_app/constants/image_constants.dart';
import 'bottom_nevigation.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(milliseconds: 1000), (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const BottomNavigationScreen()), (route) => false);
    });
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 8,
            child: Center(
              child: Container(
                height: 400,
                child: Image.asset(imageAppLogo),
              ),
            ),
          ),
          Expanded(
            flex: 2,
              child: Image.asset(imageWaitingCircle, height: 60,width: 60,)),
        ],
      ),
    );
  }
}
