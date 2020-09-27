import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'package:path_provider/path_provider.dart';


class Requests {




//   static Future<List<Post>> getAllPosts() async {
//     var path = "get_posts";
//     print("GETTING ALL POSTS... ");
//     var result = await getResult(path);
//     print("RESULT: " + result.toString());
//     var postList = PostList.fromJson(result).posts;
//     postList.forEach((element) {
//       print(element.description);
//     });
// //    print(postList.for);
//     return postList;
//   }


  static Future<dynamic> postResult(String path) async {
    String requestUrl = 'https://earth-hacks-eco-post.herokuapp.com/';
    var request = await HttpClient().postUrl(Uri.parse(requestUrl + path));
    var response = await request.close();
    var contents =
    await response.transform(utf8.decoder).transform(json.decoder).single;
    return contents;
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
