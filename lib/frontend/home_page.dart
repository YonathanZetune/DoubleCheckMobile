import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:double_check/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        bottomNavigationBar: ConvexAppBar(
          onTap: (int index) => {print('click index=$index')},
          initialActiveIndex: 0,
          gradient: FlutterGradients.northMiracle(

              ),
          items: [
            TabItem(icon: (FontAwesomeIcons.clipboardList), title: "Q/A"),
            TabItem(icon: (FontAwesomeIcons.commentDots), title: "Ask"),
            TabItem(icon: (FontAwesomeIcons.poll), title: "Polls"),
          ],
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(60, 40, 20, 20),
            child: Image(image: AssetImage("assets/images/logo1.png")),
          ),
        ),
      ),
    ));
  }
}
