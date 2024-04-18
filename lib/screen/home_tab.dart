import 'package:flutter/material.dart';
import 'package:wallpaper_app/constants/color_constant.dart';
import 'package:wallpaper_app/constants/image_constants.dart';
import 'package:wallpaper_app/constants/text_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../provider/search_provider.dart';
import '../widgets_common/feature_imagewidgets.dart';
import 'full_photo.dart';

class HomeTabScreen extends StatefulWidget {
  HomeTabScreen({Key? key}) : super(key: key);

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  final ScrollController scrollController = ScrollController();
  List<String> featuredTitle  =[
    'Arts',
    'Landscape',
    'Sky',
    'Technology',
    'Galaxy',
    'Clothing',
    'Person',
    'Nature'
  ];

  List featureImage = [
    imageFeatureArt,
    imageFeatureLandscap,
    imageFeatureSky,
    imageFeatureTechnology,
    imageFeatureGalaxy,
    imageFeatureClothing,
    imageFeaturePerson,
    imageFeatureNature
  ];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      Provider.of<ProductProvider>(context, listen: false)
          .scrollListener(scrollController);
    });
    Provider.of<ProductProvider>(context, listen: false).fetchProductData(scrollController);
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      physics: ScrollPhysics(),
      controller: scrollController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///-----------------Feature -------------------
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Text(
              TextFeatured,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 18, color: colorAppTextWhite),
              ),
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8),
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => FeatureImageScreen(query: featuredTitle[index], image: featureImage[index],)),);
                          Provider.of<PhotoSearchProvider>(context, listen: false)
                              .fetchSearchPhotos(featuredTitle[index]);
                        },
                        child: Stack(
                          children: [
                            Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(featureImage[index].toString(), fit: BoxFit.cover,))),
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.46),
                                borderRadius: BorderRadius.circular(12)
                              ),
                              ),
                              Positioned(
                              child: Center(
                                child: Text(
                                  featuredTitle[index].toString(),
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold, color: Colors.white),),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TextTopWallpaper,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorAppTextWhite),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          allWallpapers(),
        ],
      ),
    );
  }

  Widget allWallpapers(){
    return Consumer<ProductProvider>(
      builder: (BuildContext context, provider, _) {
        if (provider.dataLoading && provider.currentPage == 1) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.productData == null || provider.productData!.isEmpty) {
          return const Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              //controller: scrollController,
              itemCount: provider.productData!.length + 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.67,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, index) {
                if (index < provider.productData!.length) {
                  print("Index ${index}");
                  final data = provider.productData![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullPhotoScreen(fullUrl: data.fullUrl.toString()),
                        ),
                      );
                    },
                    child: Container(
                      height: 300,
                      width: 220,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            spreadRadius: 0.1,
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          '${data.thumUrl}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                } else if (provider.hasMoreData) {
                  print("hasMoreData");
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  // End of data
                  return SizedBox.shrink();
                }
              },
            ),
          );
        }
      },
    );
  }
}