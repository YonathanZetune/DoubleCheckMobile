import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_check/models/double_check_info.dart';
import 'package:double_check/widgets/join_session.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slimy_card/slimy_card.dart';

class PollsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dbCheckinfo = Provider.of<DoubleCheckInfo>(context, listen: true);

    CollectionReference getTeacherQuestions() {
      // await Firebase.initializeApp();
      // CollectionReference sessions =
      return FirebaseFirestore.instance
          .collection('sessions')
          .doc(dbCheckinfo.currSession)
          .collection('teacherQuestions');
    }

    Future<void> submitAnswer(String answerToQ, String question) async {
      getTeacherQuestions().snapshots().forEach((element) {
        element.docs.forEach((doc) {
          print(doc.id);
          print(answerToQ);

          if (doc.id != null && doc.id == question) {
            print("HERE");

            doc.reference.collection('answers').snapshots().forEach((answer) {
              print(answer.docs.first.id);

              answer.docs.forEach((answerDoc) {
                print(answerDoc.id);
                print(answerDoc.data()['answer']);

                if (answerDoc.data()['answer'] != null &&
                    answerDoc.data()['answer'].toString() == answerToQ) {
                  print("FOUND!!!");
                  final count = answerDoc.data()['count'];
                  answerDoc.reference.update({'count': count + 1});
                  answerToQ = "____";
                }
              });
            });
          }
        });
      });
    }

    Future<List<Widget>> generatePollWidget(
        String pollType, CollectionReference data) async {
      List<Widget> rows = new List<Widget>();
      rows.clear();
      // rows.add((Row(
      //   children: [Text('HI')],
      // )));
      // return rows;
      final List<String> choices = ["A", "B", "C", "D"];

      if (pollType == "poll") {
        print(data);
        return await data.get().asStream().forEach((element) {
          int count = 0;

          element.docs.forEach((doc) {
            print(doc.id);
            rows.add(Container(
              child: new Row(
                children: [
                  FlatButton(
                    onPressed: () async {
                      print("PRESSED");
                      await submitAnswer(doc.data()['answer'], data.parent.id)
                          .then((value) {
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.SUCCES,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Answer Submitted Successfully!',
                            desc: 'Wait for your teacher to show the results.',
                            btnOkOnPress: () {},
                            btnCancel: null)
                          ..show();
                      });
                    },
                    child: Text(
                      choices.elementAt(count),
                      style: GoogleFonts.montserrat(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                        side:
                            BorderSide(color: Colors.deepPurpleAccent, width: 4)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text(
                      (doc.data()['answer'] == null
                              ? "N/A"
                              : doc.data()['answer'])
                          .toString(),
                      style: GoogleFonts.montserrat(fontSize: 12),
                      maxLines: 3,
                    ),
                  )
                ],
              ),
            ));
            count++;
          });
          print(rows);
        }).then((value) {
          return rows;
        });
      }
    }

    return dbCheckinfo.currSession.isEmpty
        ? JoinSession()
        : Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: getTeacherQuestions().snapshots(),
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
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SlimyCard(
                              color: Colors.blueAccent,
                              topCardWidget: Text(
                                d.data()['question'] == null
                                    ? ''
                                    : d.data()['question'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    fontSize: 18, color: Colors.white),
                              ),
                              topCardHeight: 200,
                              bottomCardHeight: 250,
                              width: 400,
                              bottomCardWidget: FutureBuilder(
                                  future: generatePollWidget(
                                      d.data()['question_type'],
                                      d.reference.collection('answers')),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<Widget>> pjSnap) {
                                    switch (projectSnap.connectionState) {
                                      case ConnectionState.none:
                                        return new Text('No Data');
                                      case ConnectionState.waiting:
                                        return new CircularProgressIndicator();
                                      default:
                                        return Column(
                                          children: pjSnap.data,
                                        );
                                    }
                                  }),
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
