import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_check/models/double_check_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_form/quick_form.dart';
import 'package:double_check/utilities/requests.dart';

class AskQuestion extends StatelessWidget {
  Widget customFormBuilder(FormHelper helper, BuildContext context) => Column(
        children: <Widget>[
          Expanded(
            child: Card(
              elevation: 0.25,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    Row(
                      children: <Widget>[
                        Expanded(flex: 3, child: helper.getWidget("question")),
                        Container(width: 16),
                        // Expanded(flex: 3, child: helper.getWidget("title")),
                        // Container(width: 16),
                        // Expanded(child: helper.getWidget("age"))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child: Container(
                        width: 320,
                        child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text("Feedback"),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: const <Widget>[
                                      Expanded(
                                          child: Text(
                                        "Too Fast",
                                        textAlign: TextAlign.center,
                                      )),
                                      Expanded(
                                          child: Text(
                                        "None",
                                        textAlign: TextAlign.center,
                                      )),
                                      Expanded(
                                          child: Text(
                                        "Can't Hear",
                                        textAlign: TextAlign.center,
                                      )),

                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                          child: helper.getWidget("feedback1")),
                                      Expanded(
                                          child: helper.getWidget("feedback2")),
                                      Expanded(
                                          child: helper.getWidget("feedback3")),
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                    // Row(
                    //   children: <Widget>[
                    //     const Text("Accept Terms"),
                    //     helper.getWidget("checkbox")
                    //   ],
                    // )
                  ]),
                ),
              ),
            ),
          ),
          helper.getWidget("submit")
        ],
      );

  @override
  Widget build(BuildContext context) {
    var dbCheckinfo = Provider.of<DoubleCheckInfo>(context, listen: false);

    const questionForm = <Field>[
      Field(
        name: "question",
        label: "Ask a question here...",
        mandatory: true,
      ),
      Field(
          name: "feedback1",
          group: "Feedback",
          value: "0",
          type: FieldType.radio),
      Field(
          name: "feedback2",
          group: "Feedback",
          value: "1",
          type: FieldType.radio),
      Field(
          name: "feedback3",
          group: "Feedback",
          value: "2",
          type: FieldType.radio),

    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: Container(
        child: questionForm.buildSimpleForm(
            onFormSubmitted: (val) async {
              print(val.values);
              String session = dbCheckinfo.currSession;
              // val.putIfAbsent(key, () => null)
              await Requests.postMyQuestion(val, session).then((value) => {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.SUCCES,
                        animType: AnimType.TOPSLIDE,
                        title: 'Question Submitted Successfully!',
                        desc: 'Go to the Q/A tab to see all questions.',
                        btnOkOnPress: () {},
                        btnCancel: null)
                      ..show()
                  });
            },
            onFormChanged: (map) {
              print(map);
            },
            uiBuilder: customFormBuilder),
      ),
    );
  }
}
