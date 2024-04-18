import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants/url_constants.dart';
import '../model/product_model.dart';


class PopulerWallpaperProvider extends ChangeNotifier {
  final String baseUrl = 'https://api.unsplash.com/search/photos';
  final String clientId = 'e8gVc5wKIVcSIihSoURU8f0t6vlbG_sNTAH-1Ypr08k';
  final int perPage = 30;

  List<PhotoDetails>? _productData;
  List<PhotoDetails>? get productData => _productData;
  bool dataLoading = false;
  int currentPage = 1;
  bool hasMoreData = true;

  Future<void> fetchPopulerData(ScrollController scrollController) async {
    print("fetchProductData");
    if (dataLoading || !hasMoreData) return;

    String photoUrl = '$baseUrl?query=popular&client_id=$clientId&per_page=$perPage&page=$currentPage';
    dataLoading = true;

    final response = await http.get(Uri.parse(photoUrl));
    dataLoading = false;

    if (response.statusCode == 200) {
      print("Response 200");
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Check if the 'results' key exists in the response body
      if (responseBody.containsKey('results')) {
        List<dynamic> body = responseBody['results'];
        List<PhotoDetails> newData = body.map((item) => PhotoDetails.fromJson(item)).toList();

        if (currentPage == 1) {
          print("Current page == 1");
          _productData = newData;
        } else {
          print("Current page == ${currentPage}");
          _productData?.addAll(newData);
        }

        if (body.length < perPage) {
          hasMoreData = false;
        }

        currentPage++;
        notifyListeners();
      } else {
        print('Results key not found in the response body');
        notifyListeners();
      }
    } else {
      print('Failed to load data');
      notifyListeners();
    }
  }


  void scrollListener(ScrollController scrollController) {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      fetchPopulerData(scrollController);
    }
  }
}
