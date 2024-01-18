import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaper_app/constants/color_constant.dart';
import 'package:wallpaper_app/constants/url_constants.dart';
import 'package:wallpaper_app/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpaper_app/screen/full_photo.dart';

class AllWallpaper extends StatefulWidget {
  const AllWallpaper({Key? key}) : super(key: key);

  @override
  State<AllWallpaper> createState() => _AllWallpaperState();
}

class _AllWallpaperState extends State<AllWallpaper> {
  final ScrollController scrollController = ScrollController();

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
          return GridView.builder(
            controller: scrollController,
            itemCount: provider.productData!.length + 1,
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
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
          );
        }
      },
    );
  }
}

