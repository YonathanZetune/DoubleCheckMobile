import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_check/models/double_check_info.dart';
import 'package:double_check/widgets/join_session.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuestionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dbCheckinfo = Provider.of<DoubleCheckInfo>(context, listen: true);

    CollectionReference getStudentQuestions() {
      // await Firebase.initializeApp();
      // CollectionReference sessions =
      return FirebaseFirestore.instance
          .collection('sessions')
          .doc(dbCheckinfo.currSession)
          .collection('studentQuestions');
    }

    return dbCheckinfo.currSession.isEmpty
        ? JoinSession()
        : Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: getStudentQuestions().snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> projectSnap) {
                switch (projectSnap.connectionState) {
                  case ConnectionState.none:
                    return new Text('No Data');
                  case ConnectionState.waiting:
                    return new CircularProgressIndicator();
                  default:
                    if (projectSnap.hasError)
                      return new Text('Error: ${projectSnap.error}');
                    else
                      return new ListView(
                        children: projectSnap.data.docs
                            .map((QueryDocumentSnapshot d) {
                          return Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new ListTile(
                                dense: false,
                                title: new Text(d.data()['questionBody'] == null ? '' : d.data()['questionBody'], style: GoogleFonts.montserrat(fontSize: 18),),
                                trailing: Icon(d.data()['isViewed'] != null ? d.data()['isViewed'] ? FontAwesomeIcons.checkDouble: FontAwesomeIcons.userClock : FontAwesomeIcons.question),
                                subtitle: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(d.data()['upvotes'] == null ? '0': d.data()['upvotes']),
                                    ),
                                    IconButton(
                                      icon: Icon(FontAwesomeIcons.thumbsUp),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                }
              },
            ),
          );
  }
}
