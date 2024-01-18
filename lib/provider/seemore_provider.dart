import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants/url_constants.dart';
import '../model/product_model.dart';


class SeeMoreProvider extends ChangeNotifier {
  final String baseUrl = 'https://api.unsplash.com/search/photos';
  final String clientId = 'e8gVc5wKIVcSIihSoURU8f0t6vlbG_sNTAH-1Ypr08k';
  final int perPage = 60;

  List<PhotoDetails> _photos = [];
  List<PhotoDetails> get photos => _photos;
  bool dataLoading = false;

  int currentPage = 1;

  Future<void> searchPhotos(String query, {int page = 1}) async {
    String url =
        '$baseUrl?query=$query&client_id=$clientId&per_page=$perPage&page=$page';

    log('baseUrl${url}');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('search Provider ${response.statusCode}');
      log("json Decode${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> allPhotos = json.decode(response.body);
        log("json Decode${response.body}");

        List<String> searchTerms = query.trim().split(' ');

        List<PhotoDetails> pagePhotos = (allPhotos['results'] as List<dynamic>)
            .where((photo) {
          String description = (photo['description'] ?? '') +
              ' ' +
              (photo['alt_description'] ?? '');

          return searchTerms.every((term) =>
              description.toLowerCase().contains(term.toLowerCase()));
        })
            .map((json) => PhotoDetails.fromJson(json))
            .toList();

        if (page == 1) {
          // If it's the first page, replace existing data
          _photos = pagePhotos;
        } else {
          // If it's not the first page, add to existing data
          _photos.addAll(pagePhotos);
        }

        notifyListeners();
      } else {
        print('Failed to load photos');
      }

      notifyListeners();
    } else {
      print('Failed to load photos');
    }
  }
  Future<void> loadMorePhotos(String query) async {
    currentPage++;
    await searchPhotos(query, page: currentPage);
  }
}
