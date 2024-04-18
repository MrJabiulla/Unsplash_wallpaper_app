import 'package:flutter/material.dart';
import 'package:wallpaper_app/constants/color_constant.dart';
import 'package:wallpaper_app/screen/searchScreen.dart';
import 'categories_tab.dart';
import 'homepage_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  final List<Widget> _screens = [
    const HomepageScreen(),
    const CategoriesTab(),
    PhotoSearch(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ///----Home-----
              InkWell(
                  onTap: (){
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Icon(
                      Icons.home, size: _selectedIndex ==0 ? 35 : 30,
                    color: _selectedIndex == 0? colorAppIconButton : colorAppTextGrey,
                  )
              ),

              ///---Search-----
              InkWell(
                  onTap: (){
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Icon(
                    Icons.category,size: _selectedIndex ==1 ? 35 : 30,
                    color: _selectedIndex == 1? colorAppIconButton : colorAppTextGrey,
                  )
              ),
              ///-----Profile----
              InkWell(
                  onTap: (){
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  child: Icon(
                    Icons.search,size: _selectedIndex ==2 ? 35 : 30,
                    color: _selectedIndex == 2? colorAppIconButton : colorAppTextGrey,
                  )
              ),
            ],
          )
      ),
    );
  }
}
