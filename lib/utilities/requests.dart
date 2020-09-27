import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';


class Requests {
  static Future<void> postMyQuestion(Map<String, String> data, String session) async {
    String requestUrl = 'https://doublecheckapp.herokuapp.com/question';
    print("POST QUESTION: " + session);

    int feedbackType = 0;
    String question = "";
    data.forEach((key, value) {
      if (key == "Feedback") {
        feedbackType = int.parse(value);
        print("FEEDBACK IS: " + feedbackType.toString());
      }
      if (key == "question") {
        question = value;
      }
    });
    Map<String, dynamic> jsonMap = {
      'questionBody': question,
      'feedback_type': feedbackType,
      'sessionId': session,
    };
    String jsonString = json.encode(jsonMap);
    var request = await HttpClient().postUrl(Uri.parse(requestUrl));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    request.write(jsonString);
    var response = await request.close();
    print(response.statusCode);
    // var contents =
    //     await response.transform(utf8.decoder).transform(json.decoder).single;
    // return contents;
  }

  static Future<dynamic> getResult(String path) async {
    String requestUrl = 'https://earth-hacks-eco-post.herokuapp.com/';
    var request = await HttpClient().getUrl(Uri.parse(requestUrl + path));
    var response = await request.close();
    var contents =
        await response.transform(utf8.decoder).transform(json.decoder).single;
    return contents;
  }
}
