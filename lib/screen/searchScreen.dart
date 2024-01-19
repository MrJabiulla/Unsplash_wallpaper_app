import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/color_constant.dart';
import '../constants/text_constants.dart';
import '../provider/searchProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'full_photo.dart';

class PhotoSearch extends StatefulWidget {
  @override
  State<PhotoSearch> createState() => _PhotoSearchState();
}

class _PhotoSearchState extends State<PhotoSearch> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    Provider.of<PhotoSearchProvider>(context, listen: false).searchPhotos(searchController.text.toLowerCase());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoSearchProvider>(
      builder: (context, photoSearchProvider, child) {
        if(photoSearchProvider.photos != null){
          return Scaffold(
            appBar: AppBar(
              title: Text(
                textAppName,
                style: GoogleFonts.dancingScript(
                    textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: colorAppTextWhite)),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: const TextStyle(
                          color: Colors.white
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        color: Colors.white,
                        onPressed: () {
                          photoSearchProvider.searchPhotos(searchController.text);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                    ),
                    cursorColor: colorAppIconButton,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
                SizedBox(height: 16,),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: photoSearchProvider.photos!.length,
                    itemBuilder: (context, index) {
                      final photo = photoSearchProvider.photos![index];
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> FullPhotoScreen(fullUrl: photo.fullUrl.toString(),)));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            photo.thumUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }else{
          return CircularProgressIndicator();
        }
      },
    );
  }
}
