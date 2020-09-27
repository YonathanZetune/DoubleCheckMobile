import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_check/models/double_check_info.dart';
import 'package:double_check/widgets/join_session.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

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

    Badge getBadge(int feedbackType) {
      switch (feedbackType) {
        case 0:
          return Badge(
            badgeColor: Colors.green,
            badgeContent:
                Icon(Icons.fast_forward_outlined, color: Colors.white),
          );
        case 1:
          return Badge(
            badgeColor: Colors.red,
            badgeContent: Icon(Icons.fast_rewind_outlined, color: Colors.white),
          );
        case 2:
          return Badge(
            badgeColor: Colors.deepPurpleAccent,
            badgeContent: Icon(
              Icons.hearing_disabled,
              color: Colors.white,
            ),
          );
      }
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
                    else {
                      List<QueryDocumentSnapshot> docs = projectSnap.data.docs;
                      docs.sort((a, b) =>
                          b.data()['upVotes'].compareTo(a.data()['upVotes']));
                      docs.sort((a, b) => a
                          .data()['isViewed']
                          .toString()
                          .compareTo(b.data()['isViewed'].toString()));

                      return new ListView(
                        children: docs.map((QueryDocumentSnapshot d) {
                          return Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new ListTile(
                                dense: false,
                                title: new Text(
                                  d.data()['questionBody'] == null
                                      ? ''
                                      : d.data()['questionBody'],
                                  style: GoogleFonts.montserrat(fontSize: 18),
                                ),
                                trailing: Icon(d.data()['isViewed'] != null
                                    ? d.data()['isViewed']
                                        ? FontAwesomeIcons.checkDouble
                                        : FontAwesomeIcons.userClock
                                    : FontAwesomeIcons.question),
                                subtitle: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 10, 0, 0),
                                      child: Text(
                                          d.data()['upVotes'].toString() == null
                                              ? '0'
                                              : d.data()['upVotes'].toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: IconButton(
                                        icon: IconButton(
                                          icon: Icon(FontAwesomeIcons.thumbsUp),
                                          onPressed: () {
                                            print("THUMBS");
                                            final liked = d.data()['upVotes'];
                                            d.reference
                                                .update({"upVotes": liked + 1});
                                          },
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                    getBadge(d.data()['feedback_type'] == null
                                        ? 0
                                        : d.data()['feedback_type']),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                }
              },
            ),
          );
  }
}
