import 'package:flutter/material.dart';
import 'package:wallpaper_app/provider/populer_wallpaper_provider.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/screen/full_photo.dart';

class PopulerWallpaper extends StatefulWidget {
  const PopulerWallpaper({Key? key}) : super(key: key);

  @override
  State<PopulerWallpaper> createState() => _PopulerWallpaperState();
}

class _PopulerWallpaperState extends State<PopulerWallpaper> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      Provider.of<PopulerWallpaperProvider>(context, listen: false)
          .scrollListener(scrollController);
    });
    Provider.of<PopulerWallpaperProvider>(context, listen: false).fetchPopulerData(scrollController);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PopulerWallpaperProvider>(
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
          return SingleChildScrollView(
            physics: const ScrollPhysics(),
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
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
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

