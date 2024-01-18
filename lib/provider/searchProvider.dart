import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/url_constants.dart';
import '../model/product_model.dart';
import 'package:flutter/foundation.dart';


class PhotoSearchProvider extends ChangeNotifier {
  final String baseUrl = 'https://api.unsplash.com/search/photos';
  final String clientId = 'e8gVc5wKIVcSIihSoURU8f0t6vlbG_sNTAH-1Ypr08k';
  final int perPage = 30;


  List<PhotoDetails> _photos = [];
  List<PhotoDetails> get photos => _photos;
  bool dataLoading= false;

Future<void> searchPhotos(String query) async {
    String url = '$baseUrl?query=$query&client_id=$clientId&per_page=$perPage';

    log('baseUrl${url}');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('search Provider ${response.statusCode}');
      log("json Decode${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> allPhotos = json.decode(response.body);
        log("json Decode${response.body}");

        if (query.trim().split(' ').length == 1) {
          // Single word search
          _photos = (allPhotos['results'] as List<dynamic>)
              .map((json) => PhotoDetails.fromJson(json))
              .toList();
        } else {
          // Multiple words search
          _photos = (allPhotos['results'] as List<dynamic>)
              .where((photo) =>
          photo['alt_description'] != null &&
              photo['alt_description']
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              photo['description'] != null &&
                  photo['description'].toLowerCase().contains(query.toLowerCase()))
              .map((json) => PhotoDetails.fromJson(json))
              .toList();
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

}


