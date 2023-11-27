import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gift/Open%20Gift/gift_open_page.dart';

import '../Splash Screen/s.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static List fullDes =[];
  static List scrIm =[];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _hideBottomNavController;

  late bool _isVisible;

  @override
  void initState() {
    super.initState();

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

  getAllData() async {

    FirebaseFirestore.instance
        .collection('app')
        .where('category', isEqualTo: 'normal_frame')
        .snapshots()
        .listen((data) {
        for (var document in data.docs) {
          var jsonData = document.data();
          print(jsonData['scroll_image']);
          print('gsvs');
          print(jsonData);
          //print(document['full_description']);
    }});

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 4,
            // backgroundColor: Color(0xFFEF516F),

            backgroundColor: Color(0xFFFA2362),
            title: Text('Profile Page'),
            actions: [
              Icon(Icons.shopping_cart),
              SizedBox(
                width: 10,
              ),
              //IconButton(Icons.account_circle_rounded),
          IconButton(
            onPressed: (){
              getAllData();
            },

            icon: const Icon(
              Icons.account_circle_rounded,
            ),),
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
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('app')
                      .where('category', isEqualTo: 'normal_frame')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      ));
                    }
                    else {
                      return

                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 2 / 3),
                          itemBuilder: (context, index) {
                            DocumentSnapshot giftData = snapshot.data.docs[index];

                            print(giftData['scroll_image']);
                            return Padding(
                              padding: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: (){
                                  print('object1');
                                  print(giftData['scroll_image']);

                                  setState(() {
                                    HomePage.fullDes.clear();
                                    HomePage.scrIm.clear();
                                    HomePage.fullDes =giftData['details'];
                                    HomePage.scrIm =giftData['scroll_image'];
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
                                    padding:  EdgeInsets.all(8.0),
                                    child: Column(

                                      children: [
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(
                                              giftData['default_image'],
                                              // height:
                                              //     MediaQuery.of(context).size.height * 0.3,
                                              // width: MediaQuery.of(context).size.height * 0.15,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey.shade800,
                                        ),
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                giftData['sort_description'],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(4, 14 , 4, 0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('₹${giftData['prize']}',style: TextStyle(fontWeight: FontWeight.w500),),

                                              Text(
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
                          });
                    }
                  },
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: Colors.green,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: Colors.yellow,
                ),
              ],
            ),

          ),
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
                        // boxShadow: [
                        //   BoxShadow(
                        //     offset: Offset(0, 4),
                        //     blurRadius: 20,
                        //     color: Colors.grey.shade700,
                        //   )
                        // ],
                        borderRadius: BorderRadius.circular(60),
                        color: Colors.grey.shade300),
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
                            SizedBox(
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
          )),
    );
  }
}

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
