import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/constants/color_constant.dart';
import 'package:wallpaper_app/constants/image_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/searchProvider.dart';
import '../widgets_common/feature_imagewidgets.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});
  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  List <String> categoriesItem =[
    'Games',
    'Film',
    '3D',
    'Textures',
    'Travel',
    'Food',
    'Health',
    'Fashion',
    'Culture',
    'Sports'
  ];
  List <String> categoriesPhotos =[
    imageCategoriesGames,
    imageCategoriesFilm,
    imageCategories3D,
    imageCategoriesTextures,
    imageCategoriesTravel,
    imageCategoriesFood,
    imageCategoriesHealth,
    imageCategoriesFasion,
    imageCategoriesArts,
    imageCategoriesSports
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, index) {
            return Container(
              height: 200,
              width: double.infinity,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => FeatureImageScreen(query: categoriesItem[index],)),);
                  Provider.of<PhotoSearchProvider>(context, listen: false)
                      .fetchSearchPhotos('${categoriesItem[index]}');
                },
                child: Stack(
                  children: [
                    Container(
                        height: 200,
                        width: double.infinity,
                        child: Image.asset(categoriesPhotos[index].toString(), fit: BoxFit.cover,)),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                      ),
                    ),
                    Center(child: Text(categoriesItem[index], style: GoogleFonts.inter(fontSize: 20,fontWeight: FontWeight.bold ,color: colorWhiteLight), )),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
