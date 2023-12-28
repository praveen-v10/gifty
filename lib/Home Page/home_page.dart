import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gift/Open%20Gift/gift_open_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import '../Splash Screen/s.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static List fullDescription = [];
  static List screenImage = [];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// navigation bar animation filter usage//
  late ScrollController _hideBottomNavController;
  late bool _isVisible;

  //end here navigation bar//

  //image loading purpose in firebase//
  List defaultImage = [];

  // shimmer effect bool value//
  bool shimmerEffect = false;
  //bool _loading = false;
  List jdata = [];

  @override
  void initState() {
    super.initState();
    getAllData();

    // animation bar functions//
    _isVisible = true;
    _hideBottomNavController = ScrollController();
    _hideBottomNavController.addListener(
      () {
        if (_hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisible) {
            setState(() {
              _isVisible = false;
            });
          }
        }
        if (_hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isVisible) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      },
    );
    print('object');
  }

  // end here//

  getAllData() async {
    setState(() {
      jdata.clear();
      shimmerEffect = true;
    });
    FirebaseFirestore.instance
        .collection('app')
        .where('category', isEqualTo: 'normal_frame')
        .snapshots()
        .listen((data) {
      jdata = data.docs;

      for (var documen in jdata) {
        print(documen);
        var jsonData = documen.data();
        print(jsonData['default_image']);
        defaultImage.add(jsonData['default_image']);
        print(defaultImage);
      }
    });

//shimme effect loading timing effect//
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        shimmerEffect = false;
      });
    });
  }

  // end here//

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          backgroundColor: Color(0xFFFA2362),
          title: Text('Profile Page'),
          actions: [
            IconButton(
              onPressed: () async {
                // await generateOtp();
                // await sendEmail(
                //     emailOtp: HomePage.otp,
                //     email: 'goviprasath18@gmail.com'
                // );
              },
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            //IconButton(Icons.account_circle_rounded),
            IconButton(
              onPressed: () {
                getAllData();
              },
              icon: const Icon(
                Icons.account_circle_rounded,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          controller: _hideBottomNavController,
          child: Column(
            children: [
              // shimmer effect starts here for loading skeleton design//

              shimmerEffect
                  ? Shimmer.fromColors(
                      // The baseColor and highlightColor creates a LinearGradient which would be painted over the child widget
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: jdata.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 2.5,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
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
                                ),
                                Divider(
                                  color: Colors.grey.shade800,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  color: Color(0xFFF7F7F7),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  color: Color(0xFFF7F7F7),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  :

                  // shimmer end here and when data loading shimmer is true that time shimmer works after data loads shimmer state get false//

                  // when shimmer get false state this element shows the data in firebase//

                  GridView.builder(
                      shrinkWrap: true,
                      itemCount: jdata.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                      ),
                      itemBuilder: (context, index) {
                        var giftData = jdata[index];
                        //print('2222222222222222222200');
                        print(giftData['scroll_image']);
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              // print('object1');
                              // print(giftData['scroll_image']);

                              setState(() {
                                HomePage.fullDescription.clear();
                                HomePage.screenImage.clear();
                                HomePage.fullDescription = giftData['details'];
                                HomePage.screenImage = giftData['scroll_image'];
                              });
                              print(giftData['sort_description']);
                              //
                              Get.to(const GiftOpenPage());
                            },
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
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          defaultImage[index],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade800,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 4, 2, 0),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              giftData['sort_description'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              softWrap: false,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          4, 14, 4, 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '₹ ${giftData['prize']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const Text(
                                            'Free Delivery',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

              // end here//

              // this container is extended  page or add data inside//
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                color: Colors.green,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                color: Colors.yellow,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                color: Colors.red,
              ),

              // end here//
            ],
          ),
        ),

        // bottom navigation bar animation code starts here//

        extendBody: true,
        bottomNavigationBar: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: _isVisible ? 60 : 0.0,
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        color: Colors.grey.shade700,
                      )
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFF7F7F7),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: GestureDetector(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.sort_outlined,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Container(
                            child: GestureDetector(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Text(
                                    'Filter',
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // bottom nav bar animation end here//
      ),
    );
  }
}

// reusable codes for changes//

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late ScrollController _hideBottomNavController;
//
//   late bool _isVisible;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _isVisible = true;
//     _hideBottomNavController = ScrollController();
//     _hideBottomNavController.addListener(
//           () {
//         if (_hideBottomNavController.position.userScrollDirection ==
//             ScrollDirection.reverse) {
//           if (_isVisible) {
//             setState(() {
//               _isVisible = false;
//             });
//           }
//         }
//         if (_hideBottomNavController.position.userScrollDirection ==
//             ScrollDirection.forward) {
//           if (!_isVisible) {
//             setState(() {
//               _isVisible = true;
//             });
//           }
//         }
//       },
//     );
//     print('object');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           appBar: AppBar(
//             elevation: 4,
//             // backgroundColor: Color(0xFFEF516F),
//
//             backgroundColor: Color(0xFFFA2362),
//             title: Text('Profile Page'),
//             actions: [
//               Icon(Icons.shopping_cart),
//               SizedBox(width: 10,),
//               Icon(Icons.account_circle_rounded),
//               SizedBox(width: 10,),
//             ],
//           ),
//           resizeToAvoidBottomInset: false,
//           body: ListView(
//             children: [
//               Container(
//                 child: StreamBuilder(
//                   stream: FirebaseFirestore.instance
//                       .collection('app')
//                  .where('category', isEqualTo: 'normal_frame')
//                 .snapshots(),
//                   builder:
//                       (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                           ));
//                     } else {
//                       return ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: snapshot.data.docs.length,
//                           itemBuilder: (context, index) {
//                             DocumentSnapshot userOH = snapshot.data.docs[index];
//                             print(userOH['category']);
//
//                             print('Got data');
//                             return ListView(
//                               physics: ScrollPhysics(),
//                               shrinkWrap: true,
//                               children: <Widget>[
//                                 Padding(
//                                   padding: const EdgeInsets.fromLTRB(12, 0, 12, 2),
//                                   child: Card(
//                                     color: Color(0xFFE7ECEF),
//                                     elevation: 3,
//                                     shape: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                         borderSide: BorderSide(
//                                           color: Color(0xFFE7ECEF),
//                                         )),
//                                     child: ListTile(
//                                       title: Text(
//                                         userOH['category'],
//                                         style: const TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       subtitle: const Text(
//                                         "Approved ",
//                                         style: TextStyle(
//                                             color: Colors.green,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       leading: const CircleAvatar(
//                                         backgroundColor: Colors.green,
//                                         child: Icon(
//                                           Icons.check_circle,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       trailing: const Icon(
//                                         Icons.verified_user,
//                                         color: Colors.green,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           });
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//           extendBody: true,
//           bottomNavigationBar: AnimatedContainer(
//             duration: const Duration(milliseconds: 500),
//             height: _isVisible ? 60 : 0.0,
//             child: SingleChildScrollView(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.4,
//                     height: MediaQuery.of(context).size.height * 0.05,
//                     decoration: BoxDecoration(
//                       // boxShadow: [
//                       //   BoxShadow(
//                       //     offset: Offset(0, 4),
//                       //     blurRadius: 20,
//                       //     color: Colors.grey.shade700,
//                       //   )
//                       // ],
//                         borderRadius: BorderRadius.circular(60),
//                         color: Colors.grey.shade300),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           //crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               child: GestureDetector(
//                                 onTap: () {},
//                                 child: Column(
//                                   children: [
//                                     Icon(
//                                       Icons.sort_outlined,
//                                       size: 20,
//                                       color: Colors.black,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 16,
//                             ),
//                             Container(
//                               child: GestureDetector(
//                                 onTap: () {},
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       'Filter',
//                                       style: TextStyle(color: Colors.black),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late ScrollController _hideBottomNavController;
//
//   late bool _isVisible;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _isVisible = true;
//     _hideBottomNavController = ScrollController();
//     _hideBottomNavController.addListener(
//           () {
//         if (_hideBottomNavController.position.userScrollDirection ==
//             ScrollDirection.reverse) {
//           if (_isVisible) {
//             setState(() {
//               _isVisible = false;
//             });
//           }
//         }
//         if (_hideBottomNavController.position.userScrollDirection ==
//             ScrollDirection.forward) {
//           if (!_isVisible) {
//             setState(() {
//               _isVisible = true;
//             });
//           }
//         }
//       },
//     );
//     print('object');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           appBar: AppBar(
//             elevation: 4,
//             // backgroundColor: Color(0xFFEF516F),
//
//             backgroundColor: Color(0xFFFA2362),
//             title: Text('Profile Page'),
//             actions: [
//               Icon(Icons.shopping_cart),
//               SizedBox(width: 10,),
//               Icon(Icons.account_circle_rounded),
//               SizedBox(width: 10,),
//             ],
//           ),
//           resizeToAvoidBottomInset: false,
//           body: ListView(
//             children: [
//               Container(
//                 child: StreamBuilder(
//                   stream: FirebaseFirestore.instance
//                       .collection('app')
//                  .where('category', isEqualTo: 'normal_frame')
//                 .snapshots(),
//                   builder:
//                       (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                           ));
//                     } else {
//                       return ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: snapshot.data.docs.length,
//                           itemBuilder: (context, index) {
//                             DocumentSnapshot userOH = snapshot.data.docs[index];
//                             print(userOH['category']);
//
//                             print('Got data');
//                             return ListView(
//                               physics: ScrollPhysics(),
//                               shrinkWrap: true,
//                               children: <Widget>[
//                                 Padding(
//                                   padding: const EdgeInsets.fromLTRB(12, 0, 12, 2),
//                                   child: Card(
//                                     color: Color(0xFFE7ECEF),
//                                     elevation: 3,
//                                     shape: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                         borderSide: BorderSide(
//                                           color: Color(0xFFE7ECEF),
//                                         )),
//                                     child: ListTile(
//                                       title: Text(
//                                         userOH['category'],
//                                         style: const TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       subtitle: const Text(
//                                         "Approved ",
//                                         style: TextStyle(
//                                             color: Colors.green,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       leading: const CircleAvatar(
//                                         backgroundColor: Colors.green,
//                                         child: Icon(
//                                           Icons.check_circle,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       trailing: const Icon(
//                                         Icons.verified_user,
//                                         color: Colors.green,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           });
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//           extendBody: true,
//           bottomNavigationBar: AnimatedContainer(
//             duration: const Duration(milliseconds: 500),
//             height: _isVisible ? 60 : 0.0,
//             child: SingleChildScrollView(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.4,
//                     height: MediaQuery.of(context).size.height * 0.05,
//                     decoration: BoxDecoration(
//                       // boxShadow: [
//                       //   BoxShadow(
//                       //     offset: Offset(0, 4),
//                       //     blurRadius: 20,
//                       //     color: Colors.grey.shade700,
//                       //   )
//                       // ],
//                         borderRadius: BorderRadius.circular(60),
//                         color: Colors.grey.shade300),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           //crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               child: GestureDetector(
//                                 onTap: () {},
//                                 child: Column(
//                                   children: [
//                                     Icon(
//                                       Icons.sort_outlined,
//                                       size: 20,
//                                       color: Colors.black,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 16,
//                             ),
//                             Container(
//                               child: GestureDetector(
//                                 onTap: () {},
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       'Filter',
//                                       style: TextStyle(color: Colors.black),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// }

// Future<1String> getValue() {
//   return Future.delayed(Duration(seconds: 2), () {
//     return "";
//     // throw Exception("Custom Error");
//   });
// }

// Future<String> getValue() async {
//
//   await Future.delayed(Duration(seconds: 3));
//       for ( document in jdata) {
//
//         print(document['full_description']);
//         // var jsonData = document.data();
//         // print(jsonData['scroll_image']);
//          print('gsvs');
//
//         //print(document['full_description']);
//   }
//   return document['full_description'];
// }

// reusable codes for shimmer and future builder//

//
// FutureBuilder(
//   builder: (ctx, snapshot) {
//     // Checking if future is resolved or not
//     if (snapshot.connectionState == ConnectionState.done) {
//       // If we got an error
//       if (snapshot.hasError) {
//         return Center(
//           child: Text(
//             '${snapshot.error} occurred',
//             style: TextStyle(fontSize: 18),
//           ),
//         );
//
//         // if we got our data
//       } else if (snapshot.hasData) {
//         // Extracting data from snapshot object
//         // final data = snapshot.data as String;
//         return GridView.builder(
//
//           shrinkWrap: true,
//           itemCount: jdata.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 2 / 3,
//           ),
//           itemBuilder: (context, index) {
//
//             var giftData = jdata[index];
//             print('2222222222222222222200');
//             print(giftData['scroll_image']);
//             return Padding(
//               padding: EdgeInsets.all(10),
//               child: GestureDetector(
//                 onTap: () {
//                   print('object1');
//                   print(giftData['scroll_image']);
//
//                   setState(() {
//                     HomePage.fullDes.clear();
//                     HomePage.scrIm.clear();
//                     HomePage.fullDes = giftData['details'];
//                     HomePage.scrIm = giftData['scroll_image'];
//                   });
//                   print(giftData['sort_description']);
//                   //
//                   Get.to(const GiftOpenPage());
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         offset: Offset(0, 4),
//                         blurRadius: 4,
//                         color: Colors.grey.shade700,
//                       )
//                     ],
//                     borderRadius: BorderRadius.circular(8),
//                     color: Color(0xFFF7F7F7),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//
//
//                         Container(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Image.network(
//                               giftData['default_image'],
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ),
//                         Divider(
//                           color: Colors.grey.shade800,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
//                           child: Container(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   giftData['sort_description'],
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 2,
//                                   softWrap: false,
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(4, 14, 4, 0),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 '₹ ${giftData['prize']}',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const Text(
//                                 'Free Delivery',
//                                 style: TextStyle(color: Colors.blue),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }
//     }
//
//     // Displaying LoadingSpinner to indicate waiting state
//     return Shimmer.fromColors(
//       // The baseColor and highlightColor creates a LinearGradient which would be painted over the child widget
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: GridView.builder(
//         shrinkWrap: true,
//         itemCount: jdata.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 2 / 2.5,
//         ),
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               children: [
//                 Container(
//
//                   height: MediaQuery.of(context).size.height * 0.2,
//                   width: MediaQuery.of(context).size.width * 0.4,
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         offset: Offset(0, 4),
//                         blurRadius: 4,
//                         color: Colors.grey.shade700,
//                       )
//                     ],
//                     borderRadius: BorderRadius.circular(8),
//                     color: Color(0xFFF7F7F7),
//                   ),
//
//                 ),
//                 Divider(
//                   color: Colors.grey.shade800,
//                 ),
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.01,
//                   width: MediaQuery.of(context).size.width * 0.4,
//                   color: Color(0xFFF7F7F7),
//                 ),
//                 SizedBox(height: 4,),
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.01,
//                   width: MediaQuery.of(context).size.width * 0.4,
//                   color: Color(0xFFF7F7F7),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   },
//
//   // Future that needs to be resolved
//   // inorder to display something on the Canvas
//   future: getValue(),
// ),
