import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_app/constants/color_constant.dart';

class ImageHelper {
  static Future<void> setWallpaper(BuildContext context, String imageUrl) async {
    int location = WallpaperManager.HOME_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(imageUrl);
    final bool result =
    await WallpaperManager.setWallpaperFromFile(file.path, location);
    _showSnackbar(
      context,
      'Wallpaper ${result ? 'set' : 'failed to set'} successfully',
    );
  }

  static Future<void> downloadWallpaper(BuildContext context, String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String localPath = '${appDocDir.path}/wallpaper.jpg';
      final File file = File(localPath);
      await file.writeAsBytes(response.bodyBytes);
      _showSnackbar(context, 'Wallpaper downloaded successfully');
    } else {
      throw Exception('Failed to download wallpaper');
    }
  }

  static void showSnackbar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colorAppIconButton,
        content: Text(message, style: TextStyle(color: Colors.white)),
        duration: duration,
      ),
    );
  }

  static void _showSnackbar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colorAppIconButton,
        content: Text(message, style: TextStyle(color: Colors.white)),
        duration: duration,
      ),
    );
  }
}
