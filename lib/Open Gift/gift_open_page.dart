import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../Home Page/home_page.dart';

class GiftOpenPage extends StatefulWidget {
  const GiftOpenPage({Key? key}) : super(key: key);

  @override
  State<GiftOpenPage> createState() => _GiftOpenPageState();
}

class _GiftOpenPageState extends State<GiftOpenPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    print(HomePage.fullDes);
    print(HomePage.scrIm);
  }

  final List<Widget> imageSliders = HomePage.scrIm
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        // backgroundColor: Color(0xFFEF516F),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFA2362),
        title: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/gift-c0314.appspot.com/o/logo%2Fpng-transparent-pj-thumbnail-removebg-preview.png?alt=media&token=efe8a8d2-4adf-444a-be0c-e1eadb1a86d2',
          scale: 10,
        )),
        actions: [
          Icon(Icons.shopping_cart),
          SizedBox(
            width: 10,
          ),
          Icon(Icons.account_circle_rounded),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.26,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
                    child: Column(
                      children: [
                        Container(
                            child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            autoPlay: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                          ),
                          items: imageSliders,
                        )),
                        DotsIndicator(
                          dotsCount: imageSliders.length,
                          position: currentIndex.toInt(),
                          decorator: DotsDecorator(
                            color: Colors.black87, // Inactive color
                            activeColor: Color(0xFFFA2362),
                            spacing: const EdgeInsets.all(4),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
