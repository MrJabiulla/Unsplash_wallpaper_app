import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: const HomePage());
  }
}
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String baseUrl = 'https://api.unsplash.com/photos/';
  final String clientId = 'e8gVc5wKIVcSIihSoURU8f0t6vlbG_sNTAH-1Ypr08k';
  final int perPage = 30;

  int _page = 0;

  final int _limit = 20;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  List _posts = [];

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300
    ) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      _page += 1; // Increase _page by 1

      try {
        final res =
        await http.get(Uri.parse("$baseUrl?client_id=$clientId&per_page=$perPage&page=$_page"));

        final List fetchedPosts = json.decode(res.body);
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {

          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }


      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      final res =
      await http.get(Uri.parse("$baseUrl?client_id=$clientId&per_page=$perPage&page=$_page"));
      setState(() {
        _posts = json.decode(res.body);
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your news', style: TextStyle(color: Colors.white),),
        ),
        body:_isFirstLoadRunning?const Center(
          child: CircularProgressIndicator(),
        ):Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _posts.length,
                controller: _controller,
                itemBuilder: (_, index) => Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(_posts[index]['title'] ?? 'No title'),
                    subtitle: Text(_posts[index]['body']?? 'No body'),
                  ),
                ),
              ),
            ),
            if (_isLoadMoreRunning == true)
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            if (_hasNextPage == false)
              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 40),
                color: Colors.amber,
                child: const Center(
                  child: Text('You have fetched all of the content'),
                ),
              ),
          ],
        )
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'model/product_model.dart';
//
// // class PhotoDetails {
// //   final String thumUrl;
// //   final String fullUrl;
// //
// //   PhotoDetails({required this.thumUrl, required this.fullUrl});
// //
// //   factory PhotoDetails.fromJson(Map<String, dynamic> json) {
// //     return PhotoDetails(
// //       thumUrl: json['urls']['thumb'] as String,
// //       fullUrl: json['urls']['full'] as String,
// //     );
// //   }
// // }
//
// class AllWallpaper2 extends StatefulWidget {
//   const AllWallpaper2({Key? key}) : super(key: key);
//
//   @override
//   State<AllWallpaper2> createState() => _AllWallpaper2State();
// }
//
// class _AllWallpaper2State extends State<AllWallpaper2> {
//   final ScrollController scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     scrollController.addListener(() {
//       Provider.of<ProductProvider>(context, listen: false)
//           .scrollListener(scrollController);
//     });
//     Provider.of<ProductProvider>(context, listen: false).fetchProductData(scrollController);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProductProvider>(
//       builder: (BuildContext context, provider, _) {
//         if (provider.dataLoading && provider.currentPage == 1) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (provider.productData == null || provider.productData!.isEmpty) {
//           return const Center(
//             child: Text(
//               'No data available',
//               style: TextStyle(color: Colors.red),
//             ),
//           );
//         } else {
//           return GridView.builder(
//             controller: scrollController,
//             itemCount: provider.productData!.length + 1,
//             shrinkWrap: true,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 0.67,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//             ),
//             itemBuilder: (BuildContext context, index) {
//               if (index < provider.productData!.length) {
//                 final data = provider.productData![index];
//                 return GestureDetector(
//                   onTap: () {
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //     builder: (context) => FullPhotoScreen(fullUrl: data.fullUrl.toString()),
//                     //   ),
//                     // );
//                   },
//                   child: Container(
//                     height: 300,
//                     width: 220,
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.white.withOpacity(0.1),
//                           spreadRadius: 0.1,
//                           blurRadius: 20,
//                         )
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         '${data.thumUrl}',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 );
//               } else if (provider.hasMoreData) {
//                 // Loading indicator while fetching more data
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else {
//                 // End of data
//                 return SizedBox.shrink();
//               }
//             },
//           );
//         }
//       },
//     );
//   }
// }
//
// // class FullPhotoScreen extends StatelessWidget {
// //   final String fullUrl;
// //
// //   const FullPhotoScreen({Key? key, required this.fullUrl}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Center(
// //         child: Image.network(fullUrl),
// //       ),
// //     );
// //   }
// // }
//
// class ProductProvider extends ChangeNotifier {
//   final String baseUrl = 'https://api.unsplash.com/photos/';
//   final String clientId = 'e8gVc5wKIVcSIihSoURU8f0t6vlbG_sNTAH-1Ypr08k';
//   final int perPage = 30;
//
//   List<PhotoDetails>? _productData;
//   List<PhotoDetails>? get productData => _productData;
//   bool dataLoading = false;
//   int currentPage = 1;
//   bool hasMoreData = true;
//
//   Future<void> fetchProductData(ScrollController scrollController) async {
//     if (dataLoading || !hasMoreData) return;
//
//     String photoUrl = '$baseUrl?client_id=$clientId&per_page=$perPage&page=$currentPage';
//     dataLoading = true;
//
//     final response = await http.get(Uri.parse(photoUrl));
//     dataLoading = false;
//
//     if (response.statusCode == 200) {
//       List<dynamic> body = jsonDecode(response.body);
//       List<PhotoDetails> newData = body.map((item) => PhotoDetails.fromJson(item)).toList();
//
//       if (currentPage == 1) {
//         _productData = newData;
//       } else {
//         _productData?.addAll(newData);
//       }
//
//       if (body.length < perPage) {
//         // No more data available
//         hasMoreData = false;
//       }
//
//       currentPage++;
//       notifyListeners();
//     } else {
//       print('Failed to load data');
//       notifyListeners();
//     }
//   }
//
//   void scrollListener(ScrollController scrollController) {
//     if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
//       fetchProductData(scrollController);
//     }
//   }
// }
//
// // void main() {
// //   runApp(
// //     ChangeNotifierProvider(create: (context) => ProductProvider(),
// //       child: MaterialApp(
// //         home: Scaffold(
// //           appBar: AppBar(title: const Text('Wallpapers')),
// //           body: AllWallpaper(),
// //         ),
// //       ),
// //     ),
// //   );
// // }
