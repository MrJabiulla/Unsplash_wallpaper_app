import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/constants/color_constant.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpaper_app/screen/full_photo.dart';
import 'package:wallpaper_app/provider/search_provider.dart';

class FeatureImageScreen extends StatefulWidget {
  final String query;
  final String image;

  const FeatureImageScreen(
      {Key? key, required this.query, required this.image});

  @override
  State<FeatureImageScreen> createState() => _FeatureImageScreenState();
}

class _FeatureImageScreenState extends State<FeatureImageScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () {
        final currentQuery = widget.query;
        Provider.of<PhotoSearchProvider>(context, listen: false)
            .scrollListener(scrollController, currentQuery);
      },
    );
    Provider.of<PhotoSearchProvider>(context, listen: false)
        .fetchSearchPhotos(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoSearchProvider>(
      builder: (BuildContext context, provider, _) {
        if (provider.dataLoading == true) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            body: Column(
              children: [
                const SizedBox(height: 40),

                ///Banner
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                  image: AssetImage(widget.image),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.50),
                          ),
                        ),
                        Center(
                            child: Text(
                          widget.query,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorWhiteLight),
                        )),
                        Positioned(
                          top: 15,
                          left: 15,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(40)),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: GridView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: provider.photos!.length,
                                shrinkWrap: true,
                                primary: false,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.67,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (BuildContext context, index) {
                                  final data = provider.photos![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FullPhotoScreen(
                                                  fullUrl:
                                                      data.fullUrl.toString(),
                                                )),
                                      );
                                    },
                                    child: Container(
                                      height: 300,
                                      width: 220,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: colorAppWhite
                                                  .withOpacity(0.1),
                                              spreadRadius: 0.1,
                                              blurRadius: 20)
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: '${data.thumUrl}',
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
