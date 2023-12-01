import 'dart:convert';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:pinput/pinput.dart';
import '../Home Page/home_page.dart';
import 'package:http/http.dart' as http;


class GiftOpenPage extends StatefulWidget {
  const GiftOpenPage({Key? key}) : super(key: key);

  static String  otp= '';

  @override
  State<GiftOpenPage> createState() => _GiftOpenPageState();
}

class _GiftOpenPageState extends State<GiftOpenPage> {
  int currentIndex = 0;

  final controllerEmail = TextEditingController();
  final controllerEmailOTP = TextEditingController();

  bool sentOtp=false;
  bool wrongEmail=false;

  bool emailValidate=false;

  @override
  void initState() {
    super.initState();
    print(HomePage.fullDes);
    print(HomePage.scrIm);
  }


  generateOtp() async {
    var rndnumber = "";
    var rnd = Random();
    for (var i = 0; i < 6; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
    setState(() {
      GiftOpenPage.otp = rndnumber;
    });
    print(rndnumber);
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

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color:Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.green),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.white,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          IconButton(
            onPressed: () async {
              // setState(() {
              //   controllerEmail.text='praveenjeff3@gmail.com';
              // });
              // await generateOtp();
              // await sendEmail(
              //     emailOtp: GiftOpenPage.otp,
              //     email: controllerEmail.text
              // );
            },

            icon: const Icon(
              Icons.shopping_cart,
            ),),
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
        child: SingleChildScrollView(
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

      ),
      // bottomNavigationBar: NavigationBar(
      //   onDestinationSelected: (int index) {
      //     // setState(() {
      //     //   currentPageIndex = index;
      //     // });
      //   },
      //   destinations: [
      //    Padding(
      //      padding: const EdgeInsets.all(8.0),
      //      child: Container(
      //        width: MediaQuery.of(context).size.width * 0.4,
      //        height: MediaQuery.of(context).size.height * 0.05,
      //        decoration: BoxDecoration(
      //            borderRadius: BorderRadius.circular(10),
      //            color: Colors.grey.shade300),
      //        child: TextButton(onPressed: () {  },
      //        child: Text('Add to Cart')),
      //      ),
      //    ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Container(
      //         width: MediaQuery.of(context).size.width * 0.4,
      //         height: MediaQuery.of(context).size.height * 0.05,
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(10),
      //             color: Colors.blue),
      //         child: TextButton(onPressed: () {  },
      //         child: Text('buy now',style: TextStyle(color: Colors.white),)),
      //       ),
      //     )
      // ],
      // )



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
                  onPressed: () async {
                    await Hive.openBox("UserDetails");
                    var box = Hive.box('UserDetails');
                    var userId = box.get('user_id');
                    if(userId == null){

                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: ((context) {

                            return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey.shade200),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  "Sign In / Sign Up",
                                                  style: TextStyle(
                                                      fontFamily: 'Gilroy',
                                                      fontSize: 20),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(Icons.close))
                                              ],
                                            ),
                                            const Divider(
                                              color: Colors.grey,
                                              indent: 20,
                                              endIndent: 20,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: MediaQuery.of(context).size.height * 0.1,
                                              width: MediaQuery.of(context).size.width * 0.2,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.network(
                                                  'https://firebasestorage.googleapis.com/v0/b/gift-c0314.appspot.com/o/logo%2Fpng-transparent-pj-thumbnail-removebg-preview.png?alt=media&token=efe8a8d2-4adf-444a-be0c-e1eadb1a86d2',
                                                  fit: BoxFit.fill,

                                                ),
                                              ),
                                            ),
                                            sentOtp? Text('OTP has Sent to ${controllerEmail.text}') :Text('Please Enter your Email Id',style: TextStyle(fontSize: 18),),
                                            SizedBox(height: 20,),
                                            sentOtp?    Pinput(
                                              controller: controllerEmailOTP,
                                              defaultPinTheme: defaultPinTheme,
                                              focusedPinTheme: focusedPinTheme,
                                              submittedPinTheme:
                                              submittedPinTheme,
                                              length: 6,
                                              pinputAutovalidateMode:
                                              PinputAutovalidateMode
                                                  .onSubmit,
                                              showCursor: true,
                                              onChanged: (value) async {
                                                  if(value.length >= 6){
                                                    if(GiftOpenPage.otp == controllerEmailOTP.text){
                                                     await Fluttertoast.showToast(msg: 'Email Verified');
                                                      Get.to(HomePage());
                                                    } else{
                                                      setState(() {

                                                        controllerEmailOTP.clear();
                                                      });
                                                     Fluttertoast.showToast(msg: 'OTP invalid');
                                                    }

                                                  }
                                              },
                                            ): TextField(
                                              controller: controllerEmail,
                                              autocorrect: false,
                                              autofocus: true,
                                              onChanged: (value) {
                                                setState(() {
                                                  emailValidate=value.isEmail;
                                                });
                                                // print(value.isEmail);
                                              },
                                              style:TextStyle(fontSize:16),

                                              decoration: InputDecoration(
                                                  focusedBorder:
                                                  const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1),
                                                  ),
                                                  enabledBorder:
                                                  const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1),
                                                  ),
                                                  hintText: 'Email ID',
                                                  hintStyle: TextStyle(
                                                      color: Colors
                                                          .grey.shade400)),
                                            ),
                                            SizedBox(height: 20,),

                                            wrongEmail? TextButton(onPressed: (){
                                              setState(() {
                                                controllerEmail.clear();
                                                wrongEmail=false;
                                                sentOtp=false;
                                              });
                                            }, child: Text('Wrong Email Id'))
                                            : Text(''),
                                            emailValidate?  OutlinedButton(
                                              child: Text("Continue"),
                                              style: OutlinedButton.styleFrom(
                                                primary: Colors.green,
                                                side: BorderSide(
                                                  color: Colors.green,
                                                ),
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  sentOtp=true;
                                                  wrongEmail=true;
                                                  emailValidate=false;
                                                });
                                                print(controllerEmail.text);
                                                FocusScope.of(context).unfocus();
                                                await generateOtp();
                                                await sendEmail(
                                                    emailOtp: GiftOpenPage.otp,
                                                    email: controllerEmail.text
                                                );

                                              },
                                            ):Text(''),
                                            SizedBox(
                                              height: MediaQuery.of(context).viewInsets.bottom,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });


                          }));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.white30,
                    primary: Colors.white70,
                  ),
                  child: Text('Add to Cart',style: TextStyle(color: Colors.black,fontSize: 18),),
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
                  onPressed: () {
                    print('Add to Cart pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                  ),
                  child: Text('Buy Now',style: TextStyle(fontSize: 18),),
                ),
              ),
            )
          ],
        ),

      ],



      //
      // extendBody: true,
      // bottomNavigationBar: SingleChildScrollView(
      //   child: Row(
      //
      //     children: [
      //       Container(
      //         width: MediaQuery.of(context).size.width * 0.5,
      //         height: MediaQuery.of(context).size.height * 0.07,
      //         decoration: BoxDecoration(
      //           // boxShadow: [
      //           //   BoxShadow(
      //           //     offset: Offset(0, 4),
      //           //     blurRadius: 20,
      //           //     color: Colors.grey.shade700,
      //           //   )
      //           // ],
      //           //  borderRadius: BorderRadius.circular(60),
      //             color: Colors.grey.shade300),
      //         child: Center(child: Text('Add to Cart',style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.w400)))
      //       ),
      //       Container(
      //           width: MediaQuery.of(context).size.width * 0.5,
      //           height: MediaQuery.of(context).size.height * 0.07,
      //           decoration: BoxDecoration(
      //             // boxShadow: [
      //             //   BoxShadow(
      //             //     offset: Offset(0, 4),
      //             //     blurRadius: 20,
      //             //     color: Colors.grey.shade700,
      //             //   )
      //             // ],
      //             //  borderRadius: BorderRadius.circular(60),
      //               color: Color(0xFFFA2362),
      //
      //       ),
      //           child: Center(child: Text('Buy Now',style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w400),))
      //       )
      //     ],
      //   ),
      // )

    );

  }


  Future sendEmail({
    required String emailOtp,
    required String email,
  }) async {
    const serviceId = 'service_k88yz6k';
    const templateId = 'template_77cumlb';
    const userId = 'tdiczNLUjrGqfLeoV';

    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'otp': emailOtp,
            'user_email': email,
          }
        }),
      );
      Fluttertoast.showToast(msg: 'OTP has Sent Your Email Id');
      print(response.body);
      print('okkkkkkkkkkkkkkkkk');
    } catch (e) {
      setState(() {
        sentOtp=true;
      });
      Fluttertoast.showToast(msg: 'Please Enter Valid Email Id');
      print(e);
    }
  }


}