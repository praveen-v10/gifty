// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:gift/Open%20Gift/gift_open_page.dart';
// import 'package:image_picker/image_picker.dart';
//
// class PreviwePage extends StatefulWidget {
//   const PreviwePage({Key? key}) : super(key: key);
//
//   @override
//   State<PreviwePage> createState() => _PreviwePageState();
// }
//
// class _PreviwePageState extends State<PreviwePage> {
//   List<File> listImage = [];
//   final ImagePicker _imagePicker = ImagePicker();
//
//   Future<void> uploadImage(File image) async {
//     try {
//       FirebaseStorage storage = FirebaseStorage.instance;
//       String pathname = 'Testimages/';
//       Reference ref = storage.ref().child(pathname + DateTime.now().toString());
//       await ref.putFile(image);
//       String imageUrl = await ref.getDownloadURL();
//       print('Image uploaded: $imageUrl');
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemBuilder: (BuildContext context, int index) {
//                 return Image.file(listImage[index],height: 70,width: 100,);
//               },
//               itemCount: listImage.length,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   List<XFile>? lstImage = await _imagePicker.pickMultiImage();
//                   if (lstImage != null && lstImage.length > 0) {
//                     for (var img in lstImage) {
//                       setState(() {
//                         listImage.add(File(img.path));
//                       });
//                       //await uploadImage(File(img.path));
//                     }
//                   }
//                   String imageStore = listImage.toString();
//                   print(imageStore);
//                 },
//                 child: Text('Upload Photo'),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   Get.to(GiftOpenPage());
//                 },
//                 child: Text('Cancel'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gift/widget/loading.dart';
import 'package:image_picker/image_picker.dart';

import '../Home Page/home_page.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  List<File> _imageList = [];

  bool imageLength = false;

  Future<void> _pickImages() async {
    var imageCountLength = 15;

    if (imageCountLength >= 10) {
      setState(() {
        imageLength = true;
      });
    } else {
      setState(() {
        imageLength = false;
      });
    }

    setState(() {
      _imageList.clear();
    });
    List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles != null) {
      List<File> images =
          pickedFiles.map((XFile file) => File(file.path)).toList();
      if (images.length <= 20) {
        setState(() {
          _imageList.addAll(images);
        });
      } else {
        alart();
      }
      print('_imageList');
      print(_imageList);
    }
  }

  String imageUrl='';
  List imggg =[];
  bool defLoad = false;

  Future<void> uploadImage( File image) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String pathname = 'Testimages/';

      var file = File(image.path);

      var reff = await storage.ref().child('$pathname${DateTime.now()}.png').putFile(image);
      var downloadUrl = await reff.ref.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
        imggg.add(imageUrl.toString());
      });
      print(imageUrl);

      // final imageBytes = await image.readAsBytes();
      // String imageUrl =  imageBytes.toString();
     // print('Image uploaded: $imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return defLoad ? Loading() :Scaffold(
      appBar: AppBar(
        title: Text('Upload Your Images'),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back_outlined,
            size: 30,
          ),
        ),
      ),
      body: Column(
        children: [
          // ElevatedButton(
          //   onPressed: _pickImages,
          //   child: Text('Pick Images'),
          // ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: imageLength ? 3 : 2,
                // childAspectRatio: /2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: _imageList.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.file(
                  _imageList[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:  2,
                // childAspectRatio: /2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: _imageList.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
                  imggg[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),


        ],
      ),
      persistentFooterButtons: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  onPressed: _pickImages,
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.white30,
                    primary: Colors.white70,
                  ),
                  child: Text(
                    'Upload',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
            ),
            VerticalDivider(
              color: Colors.grey,
              thickness: 1,
            ),
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      defLoad = true;
                    });
                    for (var img in _imageList) {
                      await uploadImage(File(img.path));
                    }
                   // Get.to(HomePage());
                    setState(() {
                      defLoad = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent,
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  alart() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Preview Image"),
        content: const Text("Please Select Maximum 2 images"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}
