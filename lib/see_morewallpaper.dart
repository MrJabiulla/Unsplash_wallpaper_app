import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/constants/color_constant.dart';
import 'package:wallpaper_app/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpaper_app/screen/full_photo.dart';

class SeeMoreWallpaper extends StatefulWidget {
  const SeeMoreWallpaper({Key? key}) : super(key: key);

  @override
  State<SeeMoreWallpaper> createState() => _SeeMoreWallpaperState();
}

class _SeeMoreWallpaperState extends State<SeeMoreWallpaper> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProductData(scrollController);
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ProductProvider>(
      builder: (BuildContext context, provider, _) {
        print('hmgfhgfhjfhmf ${provider.productData!.length}');
        if (provider.dataLoading == true) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.productData == null ||
            provider.productData!.isEmpty) {
          return const Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.red),
              ));
        } else {
          return Stack(
            children: [
              GridView.builder(
                  itemCount: provider.productData!.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.67,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, index) {
                    final data = provider.productData![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FullPhotoScreen(fullUrl: data.fullUrl.toString(),)),
                        );
                      },
                      child: Container(
                        height: 300,
                        width: 220,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: colorAppWhite.withOpacity(0.1),
                                  spreadRadius: 0.1,
                                  blurRadius: 20
                              )
                            ]
                        ),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: '${data.thumUrl}',
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
              Positioned(
                top: 50,
                left: 16,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(32)
                    ),
                    child: Icon(Icons.arrow_back, color: Colors.white,),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

