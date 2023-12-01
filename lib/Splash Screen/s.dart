import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Home Page/home_page.dart';

class S extends StatefulWidget {
  const S({Key? key}) : super(key: key);

  @override
  State<S> createState() => _SState();
}

class _SState extends State<S> {

  @override
  void initState() {
    super.initState();
      print(HomePage.fullDes);
      print(HomePage.scrIm);
  }

  String i ='';

  sep(){
    for(var item in HomePage.scrIm ){
      setState(() {
        i=item.toString();
      });
      print(i);
    }
  }

  var vericId=''.obs;
  String o='';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      child: ElevatedButton(onPressed: () async {
        await FirebaseAuth.instance.verifyPhoneNumber(
         // phoneNumber: '+919514364416',
          phoneNumber: '+918072875342',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              print('The provided phone number is not valid.');
            }
          },
          codeSent: (String verificationId, int? resendToken) async {
        o=verificationId;
        print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
        print(o);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            vericId.value=verificationId;
          },
        );

       // sep();
      }, child: Text('vgvjh')),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:hive/hive.dart';
// import 'package:pinput/pinput.dart';
//
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   static String phoneNumber = '';
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   // firebase
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   // textfield controllers
//   TextEditingController controllerPhoneNumber = TextEditingController();
//   TextEditingController controllerOTP = TextEditingController();
//
//   bool onResendOTP = false;
//   bool onWrongOTP = false;
//   bool onSendOtpButton = false;
//   bool onSendOTP = false;
//   bool defaultLoading = false;
//
//   int _start = 30;
//
//   //otp verify
//   String verify = '';
//   String OTPcode = '';
//
//
//   enableOTP(){
//     setState(() {
//       defaultLoading=false;
//       LoginPage.phoneNumber =
//           controllerPhoneNumber
//               .text;
//       onSendOTP = true;
//       controllerOTP.text = '';
//     });
//   }
//   verifyOTP() async {
//     setState(() {
//       defaultLoading=true;
//     });
//     try {
//       // OTP verification function
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//           verificationId: verify, smsCode: OTPcode);
//       await auth.signInWithCredential(credential);
//       await inputData();
//       print('Success');
//
//       Fluttertoast.showToast(msg: 'OTP has been verified');
//       //Get.offAll(NamePage());
//     } catch (e) {
//       print('Wrong OTP');
//
//       if (!mounted) return;
//       setState(() {
//         controllerOTP.text='';
//         onWrongOTP=true;
//       });
//       await Future.delayed(const Duration(seconds: 1));
//       if (!mounted) return;
//       setState(() {
//         onWrongOTP=false;
//       });
//     }
//     // setState(() {
//     //   defaultLoading=false;
//     // });
//   }
//
//   inputData() async {
//     final User? user = auth.currentUser;
//     final uid = user?.uid;
//     print('$uid Current user id');
//     await Hive.openBox("UserDetails");
//     var box = Hive.box('UserDetails');
//     box.put('current_user_id', uid);
//
//     await FirebaseFirestore.instance.collection('users').doc(uid).set({
//       'user_id': uid,
//       'phoneNumber': LoginPage.phoneNumber,
//       'fullName':''
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 50,
//       height: 50,
//       textStyle: const TextStyle(
//           fontSize: 20,
//           color: Color.fromRGBO(30, 60, 87, 1),
//           fontWeight: FontWeight.w600),
//       decoration: BoxDecoration(
//         border: Border.all(color: onWrongOTP ? Colors.red : Colors.green),
//         borderRadius: BorderRadius.circular(8),
//       ),
//     );
//     final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//       border: Border.all(color: onWrongOTP ? Colors.red : Colors.green),
//       borderRadius: BorderRadius.circular(8),
//     );
//
//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         color: Colors.white,
//       ),
//     );
//     return
//       Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 300,),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       children: [
//                         // Text(
//                         //   'Phone Number',
//                         //   style: TextStyle(
//                         //       fontFamily: 'Poppins',
//                         //       fontWeight: FontWeight.w400,
//                         //       fontSize: 18,
//                         //   color: Color(0xFF216962)),
//                         // ),
//                         onSendOTP
//                             ? Row(
//                           crossAxisAlignment:
//                           CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.center,
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'OTP is sent to +91-' +
//                                           LoginPage.phoneNumber,
//                                       style: TextStyle(
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 14,
//                                           color: Color(0xFF216962)),
//                                     ),
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.fromLTRB(
//                                           10, 0, 0, 0),
//                                       child: TextButton(
//                                           style: TextButton.styleFrom(
//                                             padding: EdgeInsets.zero,
//                                             tapTargetSize:
//                                             MaterialTapTargetSize
//                                                 .shrinkWrap,
//                                             minimumSize: Size.zero,
//                                           ),
//                                           onPressed: () {
//                                             setState(() {
//                                               onResendOTP = false;
//                                               onSendOtpButton = false;
//                                               onSendOTP = false;
//                                               int _start = 30;
//                                               controllerPhoneNumber
//                                                   .text = '';
//                                             });
//                                           },
//                                           child: Text('Wrong Number?',
//                                               style: TextStyle(
//                                                   fontFamily:
//                                                   'Poppins',
//                                                   fontWeight:
//                                                   FontWeight.w400,
//                                                   fontSize: 14,
//                                                   color:
//                                                   Colors.blue))),
//                                     )
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Pinput(
//                                   controller: controllerOTP,
//                                   defaultPinTheme: defaultPinTheme,
//                                   focusedPinTheme: focusedPinTheme,
//                                   submittedPinTheme:
//                                   submittedPinTheme,
//                                   length: 6,
//                                   // androidSmsAutofillMethod:
//                                   // AndroidSmsAutofillMethod.smsRetrieverApi,
//                                   pinputAutovalidateMode:
//                                   PinputAutovalidateMode.onSubmit,
//                                   showCursor: true,
//                                   onChanged: (value) async {
//                                     if (value.length == 6) {
//                                       setState(() {
//                                         OTPcode = value;
//                                       });
//                                       await verifyOTP();
//                                     }
//                                   },
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Don\'t Receive the OTP?',
//                                       style: TextStyle(
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 14,
//                                           color: Color(0xFF216962)),
//                                     ),
//                                     onResendOTP
//                                         ? TextButton(
//                                         onPressed: () async {
//                                           setState(() {
//                                             defaultLoading=true;
//                                             onResendOTP = false;
//                                             _start = 30;
//                                             controllerOTP.text =
//                                             '';
//                                           });
//                                           await FirebaseAuth
//                                               .instance
//                                               .verifyPhoneNumber(
//                                             phoneNumber: '+91${controllerPhoneNumber
//                                                 .text}'.trim(),
//                                             verificationCompleted:
//                                                 (PhoneAuthCredential
//                                             credential) {},
//                                             verificationFailed:
//                                                 (FirebaseAuthException
//                                             e) {},
//                                             codeSent: (String
//                                             verificationId,
//                                                 int?
//                                                 resendToken) async {
//                                               verify =
//                                                   verificationId;
//                                             },
//                                             codeAutoRetrievalTimeout:
//                                                 (String
//                                             verificationId) {
//                                               if (!mounted)
//                                                 return;
//                                               setState(() {
//                                                 defaultLoading=false;
//                                               });
//                                             },
//                                           );
//                                           setState(() {
//                                             defaultLoading=false;
//                                           });
//                                         },
//                                         child: Text(
//                                           "Resend",
//                                           style: TextStyle(
//                                             fontFamily: 'Poppins',
//                                             fontWeight:
//                                             FontWeight.w500,
//                                             fontSize: 14,
//                                           ),
//                                         ))
//                                         : TextButton(
//                                       onPressed: () async {},
//                                       child: TweenAnimationBuilder<
//                                           Duration>(
//                                           duration: Duration(
//                                               seconds: 30),
//                                           tween: Tween(
//                                               begin: Duration(
//                                                   seconds: 30),
//                                               end: Duration
//                                                   .zero),
//                                           onEnd: () {
//                                             setState(() {
//                                               onResendOTP =
//                                               true;
//                                             });
//                                           },
//                                           builder: (BuildContext
//                                           context,
//                                               Duration value,
//                                               Widget? child) {
//                                             // final minutes = value.inMinutes;
//                                             final seconds =
//                                                 value.inSeconds %
//                                                     60;
//                                             return Padding(
//                                                 padding: const EdgeInsets
//                                                     .symmetric(
//                                                     vertical:
//                                                     5),
//                                                 child: Row(
//                                                   children: [
//                                                     Text(
//                                                         'Please Wait',
//                                                         textAlign:
//                                                         TextAlign
//                                                             .center,
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                             'Poppins',
//                                                             fontWeight:
//                                                             FontWeight.w400,
//                                                             color: Colors.black,
//                                                             fontSize: 14)),
//                                                     Text(
//                                                         ' 0:$seconds',
//                                                         textAlign:
//                                                         TextAlign
//                                                             .center,
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                             'Poppins',
//                                                             fontWeight:
//                                                             FontWeight.w400,
//                                                             color: Colors.black,
//                                                             fontSize: 14)),
//                                                   ],
//                                                 ));
//                                           }),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             )
//                           ],
//                         )
//                             : Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 20),
//                           child: TextField(
//                             controller: controllerPhoneNumber,
//                             keyboardType: TextInputType.phone,
//                             inputFormatters: [
//                               LengthLimitingTextInputFormatter(10)
//                             ],
//                             autocorrect: false,
//                             onChanged: (value) {
//                               if (!mounted) return;
//                               if (value.length == 10) {
//                                 FocusManager.instance.primaryFocus
//                                     ?.unfocus();
//                                 setState(() {
//                                   onSendOtpButton = true;
//                                 });
//                               } else {
//                                 setState(() {
//                                   onSendOtpButton = false;
//                                 });
//                               }
//                             },
//                             decoration: InputDecoration(
//                               focusedBorder: const OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Color(0xFF216962),
//                                     width: 1),
//                               ),
//                               enabledBorder: const OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Color(0xFF216962),
//                                     width: 1),
//                               ),
//                               hintText: 'Mobile Number',
//                               hintStyle: TextStyle(
//                                   color: Colors.grey.shade400),
//                               suffixIcon: onSendOtpButton
//                                   ? IconButton(
//                                 icon: Icon(Icons.send,
//                                     color: Color(0xFF216962),
//                                     size: 30),
//                                 onPressed: () async {
//                                   setState(() {
//                                     defaultLoading=true;
//                                   });
//                                   await FirebaseAuth.instance
//                                       .verifyPhoneNumber(
//                                     phoneNumber: '+91' +
//                                         controllerPhoneNumber
//                                             .text,
//                                     verificationCompleted:
//                                         (PhoneAuthCredential
//                                     credential) {},
//                                     verificationFailed:
//                                         (FirebaseAuthException
//                                     e) {},
//                                     codeSent: (String
//                                     verificationId,
//                                         int?
//                                         resendToken) async {
//                                       verify = verificationId;
//                                       await enableOTP();
//                                     },
//                                     codeAutoRetrievalTimeout:
//                                         (String
//                                     verificationId) {
//                                       if (!mounted) return;
//                                       setState(() {
//                                         defaultLoading=false;
//                                       });
//                                     },
//                                   );
//                                 },
//                               )
//                                   : IconButton(
//                                 icon: Icon(Icons.send,
//                                     color: Colors.grey,
//                                     size: 30),
//                                 onPressed: () {
//                                   Fluttertoast.showToast(
//                                       msg:
//                                       'Please Enter Your Number');
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//         //     bottomNavigationBar: Padding(
//         //     padding: MediaQuery.of(context).viewInsets,
//         // child: Container(
//         // height: MediaQuery.of(context).size.height * 0.1,
//         // decoration: BoxDecoration(
//         // color: Colors.white,
//         // borderRadius: BorderRadius.circular(12),
//         // border: Border.all(color: Colors.grey)),
//         //   child: Container(
//         //     decoration: BoxDecoration(
//         //         border: Border.all(color:  Color(0xFFE6B88D)),
//         //         borderRadius: BorderRadius.circular(8)),
//         //     padding: EdgeInsets.all(4),
//         //     width: MediaQuery.of(context).size.width * 0.5,
//         //     child:  ElevatedButton(
//         //           onPressed: () async {
//         //
//         //           },
//         //           style: ElevatedButton.styleFrom(
//         //             elevation: 0,
//         //             primary:  Color(0xFFE6B88D),
//         //           ),
//         //           child: Padding(
//         //               padding: EdgeInsets.all(15.0),
//         //               child: Text(
//         //                 "Log In",
//         //                 style: TextStyle(
//         //                     fontWeight: FontWeight.bold),
//         //               ))),
//         //
//         //   )
//         // )
//         //     )
//       );
//   }
// }

