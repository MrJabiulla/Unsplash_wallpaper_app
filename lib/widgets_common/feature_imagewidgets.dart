import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/constants/color_constant.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpaper_app/screen/full_photo.dart';
import 'package:wallpaper_app/provider/searchProvider.dart';

class FeatureImageScreen extends StatefulWidget {
  final String query;
  const FeatureImageScreen({Key? key, required this.query});

  @override
  State<FeatureImageScreen> createState() => _FeatureImageScreenState();
}

class _FeatureImageScreenState extends State<FeatureImageScreen> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // scrollController.addListener(() {
    //   Provider.of<PhotoSearchProvider>(context, listen: false)
    //       .scrollListener(scrollController);
    // });
    Provider.of<PhotoSearchProvider>(context, listen: false).searchPhotos(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoSearchProvider>(
      builder: (BuildContext context, provider, _) {
        if (provider.dataLoading == true) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Stack(
            children: [
              GridView.builder(
                itemCount: provider.photos!.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.67,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, index) {
                  final data = provider.photos![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FullPhotoScreen(fullUrl: data.fullUrl.toString(),)),
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
                child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(40)
                    ),
                    child: IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back, size: 25,color: Colors.white,))))
            ],
            
          );
        }
      },
    );
  }
}
