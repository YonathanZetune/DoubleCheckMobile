import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:double_check/frontend/questions_page.dart';
import 'package:double_check/models/double_check_info.dart';
import 'package:double_check/utilities/constants.dart';
import 'package:double_check/widgets/join_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.deepPurpleAccent,
        body: TabBarView(
          children: [
            QuestionsPage(),
            JoinSession(),
            JoinSession(),
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          onTap: (int index) => {print('click index=$index')},
          initialActiveIndex: 0,
          gradient: FlutterGradients.northMiracle(),
          items: [
            TabItem(icon: (FontAwesomeIcons.clipboardList), title: "Q/A"),
            TabItem(icon: (FontAwesomeIcons.commentDots), title: "Ask"),
            TabItem(icon: (FontAwesomeIcons.poll), title: "Polls"),
          ],
        ),
        appBar: AppBar(
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  size: 30,
                ),
                onPressed: () {},
              ),
            )
          ],
          title: Padding(
            padding: const EdgeInsets.fromLTRB(70, 30, 0, 20),
            child: Image(image: AssetImage("assets/images/logo1.png")),
          ),
        ),
      ),
    ));
  }
}
