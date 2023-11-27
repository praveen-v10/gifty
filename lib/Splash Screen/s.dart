import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      child: ElevatedButton(onPressed: (){
        sep();
      }, child: Text('vgvjh')),
    );
  }
}
