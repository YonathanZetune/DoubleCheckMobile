import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_check/models/double_check_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blobs/blobs.dart' as UIBlob;
import 'package:pinput/pin_put/pin_put.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

class JoinSession extends StatelessWidget {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    var dbCheckinfo = Provider.of<DoubleCheckInfo>(context);

    Future<bool> checkSessionID(String code) async {
      print("Checking code: " + code);
      bool found = false;
      await Firebase.initializeApp();
      CollectionReference sessions =
          await FirebaseFirestore.instance.collection('sessions');
      await sessions.get().then((value) {
        List<QueryDocumentSnapshot> docs = value.docs;
        docs.forEach((element) {
          print("compare to: " + element.id);
          if (element.id == code) {
            print("TRUE: " + element.id);

            found = true;
          }
        });
      });
      return found;
    }

    return Container(
      color: Color(0x000000),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "You are not currently in a session, click to join or start a new one!",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              child: UIBlob.Blob.animatedRandom(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                          onPressed: () => {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.INFO,
                                  animType: AnimType.BOTTOMSLIDE,
                                  body: Column(children: [
                                    Text(
                                        'Type your 6-digit session code below'),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PinPut(
                                        fieldsCount: 6,
                                        // onSubmit: (String pin) =>
                                        //     _showSnackBar(pin, context),
                                        focusNode: _pinPutFocusNode,
                                        controller: _pinPutController,
                                        submittedFieldDecoration:
                                            _pinPutDecoration.copyWith(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        selectedFieldDecoration:
                                            _pinPutDecoration,
                                        followingFieldDecoration:
                                            _pinPutDecoration.copyWith(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.deepPurpleAccent
                                                .withOpacity(.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  // desc: 'Your teacher should provide this code.',

                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    if (await checkSessionID(
                                        _pinPutController.value.text)) {
                                      AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.SUCCES,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Session Joined Succesfully!',
                                          desc: '',
                                          btnOkOnPress: () {
                                            dbCheckinfo.currSession = _pinPutController.value.text;
                                          },
                                          btnCancel: null)
                                        ..show();

                                    } else {
                                      AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Session Code Not Found!',
                                          desc: '',
                                          btnOkOnPress: () {},
                                          btnCancel: null)
                                        ..show();
                                    }
                                  },
                                )..show()
                              },
                          color: Colors.blue,
                          child: Text(
                            "Join",
                            style: GoogleFonts.baloo(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                          onPressed: () => {},
                          color: Colors.blue,
                          child: Text(
                            "Start",
                            style: GoogleFonts.baloo(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          )),
                    )
                  ],
                ),
                size: 380,
                edgesCount: 7,
                minGrowth: 8,
                // duration: Duration(milliseconds: 5000),
                loop: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
