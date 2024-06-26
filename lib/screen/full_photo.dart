import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpaper_app/constants/color_constant.dart';
import 'package:wallpaper_app/provider/product_provider.dart';
import '../model/product_model.dart';
import '../provider/image_helper_provider.dart';

class FullPhotoScreen extends StatefulWidget {
  final String fullUrl;

  const FullPhotoScreen({Key? key, required this.fullUrl}) : super(key: key);

  @override
  State<FullPhotoScreen> createState() => _FullPhotoScreenState();
}

class _FullPhotoScreenState extends State<FullPhotoScreen> {
  bool isFavorite = false;
  List<String> favoriteItems = [];

  List<IconData> iconData = [
    Icons.download,
    Icons.wallpaper,
  ];


  void handleDownloadWallpaper(void showSnackbar) {
    ImageHelper.downloadWallpaper(context, widget.fullUrl);
  }

  void handleSetWallpaper(void showSnackbar) {
    ImageHelper.setWallpaper(context, widget.fullUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (BuildContext context, provider, _) {
          if (provider.dataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.productData == null ||
              provider.productData!.isEmpty) {
            return const Center(child: Text('No available Data'));
          } else {
            return Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: widget.fullUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  top: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///back button
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(32)
                            ),
                            child: const Icon(Icons.arrow_back, color: colorAppWhite)),
                      ),
                      ///information
                      GestureDetector(
                          onTap: (){
                            _showDialog(context, widget.fullUrl, provider.productData!);
                          },
                          child: const Icon(Icons.info, color: colorAppTextGrey)),
                    ],
                  ),
                ),
                ///download and set wallpaper
                Positioned(
                  left: 40,
                  right: 40,
                  bottom: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var index = 0; index < iconData.length; index++)
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                               if (index == 0) {
                                handleDownloadWallpaper(ImageHelper.showSnackbar(context,'Wallpaper Downloading..'));
                              } else if (index == 1) {
                                handleSetWallpaper(ImageHelper.showSnackbar(context, 'Setting Wallpaper..', duration: const Duration(seconds: 8)));
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(color: colorAppWhite),
                                  borderRadius: BorderRadius.circular(32),
                                  color: Colors.transparent,
                                ),
                                child: Icon(
                                  iconData[index],
                                  size: 28,
                                  color: colorAppWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }


  void _showDialog(BuildContext context, String fullUrl, List<PhotoDetails> productData) {
    PhotoDetails selectedPhoto = productData.firstWhere((photo) => photo.fullUrl == fullUrl);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.4),
          title: const Center(child: Text('Photo Information')),
          titleTextStyle: const TextStyle(color: Colors.white),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Likes : ${selectedPhoto.likes}', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text('Uploader Name : ${selectedPhoto.username}', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text('Height : ${selectedPhoto.height}', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text('Width : ${selectedPhoto.width}', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text('Photo Location : ${selectedPhoto.location}', style: TextStyle(color: Colors.white)),

                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: colorAppSubmitButton),),
            ),
          ],
        );
      },
    );
  }

}