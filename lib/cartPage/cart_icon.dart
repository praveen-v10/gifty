import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class CartPageIcon extends StatefulWidget {
  const CartPageIcon({super.key});

  @override
  State<CartPageIcon> createState() => _CartPageIconState();
}

class _CartPageIconState extends State<CartPageIcon> {
  List details = [];
  String giftId = '';
  List giftDetails = [];
  List productRemove = [];

  @override
  void initState() {
    super.initState();
    check();
  }

  check() async {
    setState(() {
      giftId = '';
      giftDetails.clear();
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc('e90e2d2d-0947-4cc3-9ea5-377ba4c143be')
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        final Map<String, dynamic> doc1 =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          details = doc1['cart'];
        });
        for (var i in details) {
          setState(() {
            giftId = i.toString();
          });

          await FirebaseFirestore.instance
              .collection('app')
              .doc(giftId)
              .get()
              .then((DocumentSnapshot documentSnapshot) async {
            if (documentSnapshot.exists) {
              final Map<String, dynamic> doc2 =
                  documentSnapshot.data() as Map<String, dynamic>;
              // print(doc2);
              setState(() {
                giftDetails.add(doc2);
                // giftDetails.add(giftDetails[0]['prize']);
              });
              print(productRemove);
              // print(giftDetails);
              // for(var m in giftDetails){
              //   print(m);
              // }
              //print(giftDetails);
              // print(details);
            } else {
              print('not print');
            }
          });

          // print(giftId);
        }
        // print(doc1['cart']);
        //  print(details);
      } else {
        print('not print');
      }
    });
  }

  List addproduct = [];
  addCart() {
    FirebaseFirestore.instance
        .collection('users')
        .doc('e90e2d2d-0947-4cc3-9ea5-377ba4c143be')
        .update({"cart": FieldValue.arrayUnion(addproduct)});
  }

  List removeProduct = [];

  removeCart() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc('e90e2d2d-0947-4cc3-9ea5-377ba4c143be')
        .update({"cart": FieldValue.arrayRemove(removeProduct)});
  }

  final ImagePicker _ImagePicker = ImagePicker();
  List<File> ListImage = [];

  Future<void> uploadImage(File image) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String pathname = 'Testimages/';
      Reference ref = storage.ref().child(pathname + DateTime.now().toString());
      await ref.putFile(image);
      String imageUrl = await ref.getDownloadURL();
      print('Image uploaded: $imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        // backgroundColor: Color(0xFFEF516F),

        backgroundColor: Color(0xFFFA2362),
        title: Text(
          'My Cart',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        // Image.network(
        //   'https://firebasestorage.googleapis.com/v0/b/gift-c0314.appspot.com/o/logo%2Fpng-transparent-pj-thumbnail-removebg-preview.png?alt=media&token=efe8a8d2-4adf-444a-be0c-e1eadb1a86d2',
        //   scale: 10,
        // ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ElevatedButton(
              //     onPressed: () async {
              //       await removeCart();
              //
              //     },
              //     child: Text('Click me')),
              ListView.builder(
                shrinkWrap: true,
                itemCount: giftDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          color: Colors.grey.shade700,
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFF7F7F7),
                    ),
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.16,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 14, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                          color: Colors.grey.shade700,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xFFF7F7F7),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.34,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        giftDetails[index]['default_image'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                              giftDetails[index]
                                                  ['sort_description'],
                                              style: TextStyle(fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              softWrap: false,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 40, 0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '₹ ${giftDetails[index]['prize'].toString()}',
                                                ),
                                                Text(
                                                  'Free Delivery',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade800,
                        ),
                        Container(
                          child: Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      //Icon(Icons.delete_outlined,size: 24,color: Colors.grey,),
                                      IconButton(
                                        onPressed: () async {
                                          await removeCart();
                                          // List c = [];
                                          // await FirebaseFirestore.instance
                                          //     .collection('app')
                                          //     .doc('gift')
                                          //     .get()
                                          //     .then((DocumentSnapshot
                                          //         documentSnapshot) async {
                                          //   if (documentSnapshot.exists) {
                                          //     final Map<String, dynamic> doc =
                                          //         documentSnapshot.data()
                                          //             as Map<String, dynamic>;
                                          //     print(doc);
                                          //     print(c);
                                          //   } else {
                                          //     print(
                                          //         'netPrice Prices not exist on the database');
                                          //   }
                                          // });
                                        },
                                        icon: const Icon(
                                          Icons.delete_outlined,
                                          size: 24,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Remove',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          await addCart();
                                          List buyNewProduct = [];
                                          await FirebaseFirestore.instance
                                              .collection('app')
                                              .doc('gift')
                                              .get()
                                              .then((DocumentSnapshot
                                          documentSnapshot) async {
                                            if (documentSnapshot.exists) {
                                              final Map<String, dynamic> doc =
                                              documentSnapshot.data()
                                              as Map<String, dynamic>;
                                              print(doc);
                                              print(buyNewProduct);
                                            } else {
                                              print(
                                                  'netPrice Prices not exist on the database');
                                            }
                                          });

                                        },
                                        icon: const Icon(
                                          Icons.shopping_cart_checkout_outlined,
                                          size: 24,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      //Icon(Icons.shopping_cart_checkout_outlined,size: 24,color: Colors.grey,),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Buy Now',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          List<XFile>? lstImage =
                                              await _ImagePicker
                                                  .pickMultiImage();
                                          if (lstImage != null &&
                                              lstImage.length > 0) {
                                            for (var img in lstImage) {
                                              ListImage.add(File(img.path));
                                              await uploadImage(File(img.path));
                                            }
                                          }
                                          String imageStore =
                                              ListImage.toString();
                                          print(imageStore);
                                        },
                                        icon: const Icon(
                                          Icons.shopping_cart_checkout_outlined,
                                          size: 24,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      //Icon(Icons.shopping_cart_checkout_outlined,size: 24,color: Colors.grey,),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Upload Image',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Container(
                        //     height: MediaQuery.of(context).size.height*0.5,
                        //     width: MediaQuery.of(context).size.width,
                        //
                        //     decoration: BoxDecoration(
                        //       image: DecorationImage(
                        //           image: FileImage(ListImage[index]))
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
