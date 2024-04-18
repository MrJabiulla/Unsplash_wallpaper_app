import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaper_app/constants/color_constant.dart';
import '../constants/text_constants.dart';
import 'populer_wallpaper.dart';
import 'home_tab.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              textAppName,
              style: GoogleFonts.dancingScript(
                  textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: colorAppTextWhite)),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              const TabBar(
                labelColor: Colors.white,
                indicatorColor: colorAppSubmitButton,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: TextHome),
                  Tab(text: TextPopuler),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    HomeTabScreen(),
                    PopulerWallpaper(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
