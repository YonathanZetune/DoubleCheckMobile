import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:double_check/frontend/ask_question_page.dart';
import 'package:double_check/frontend/polls_page.dart';
import 'package:double_check/frontend/questions_page.dart';
import 'package:double_check/models/double_check_info.dart';
import 'package:double_check/utilities/constants.dart';
import 'package:double_check/widgets/join_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dbinfo = Provider.of<DoubleCheckInfo>(context);
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
            dbinfo.currSession.isEmpty ? JoinSession() : AskQuestion(),
            dbinfo.currSession.isEmpty ? JoinSession() : PollsPage(),
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
                onPressed: () {
                  dbinfo.currSession = "";
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.TOPSLIDE,
                      title: 'You have left the session.',
                      desc: 'Thanks for using DoubleCheck!',
                      btnOkOnPress: () {},
                      btnCancel: null)
                    ..show();
                },
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
