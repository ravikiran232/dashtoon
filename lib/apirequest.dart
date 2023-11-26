import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:universal_io/io.dart';
// import 'dart:typed_data';

import 'package:flutter/foundation.dart';
// import 'package:http/http.dart';

apirequest(HttpClient httpClient, String text) async {
  String API_URL = "xdwvg9no7pefghrn.us-east-1.aws.endpoints.huggingface.cloud";
  // HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.https(API_URL));
  request.headers.set("Authorization",
      "Bearer VknySbLLTUjbxXAXCjyfaFIPwUTCeRXbFSOjwRiCxsxFyhbnGjSFalPKrpvvDAaPVzWEevPljilLVDBiTzfIbWFdxOkYJxnOPoHhkkVGzAknaOulWggusSFewzpqsNWM");
  request.headers.set("Accept", "image/png");
  request.headers.set('Content-type', 'application/json');
  request.add(utf8.encode(json.encode({"inputs": text})));
  try{
  HttpClientResponse response = await request.close();
  Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  return bytes;}
  on TimeoutException{
    Fluttertoast.showToast(msg: "timeout exception",webBgColor: "#b22222",backgroundColor: Colors.red[400],timeInSecForIosWeb: 3);
  }
  on HttpException{
    Fluttertoast.showToast(msg: "http exception",webBgColor: "#b22222",backgroundColor: Colors.red[400],timeInSecForIosWeb: 3);
  }
  on FormatException{
    Fluttertoast.showToast(msg: "Format exception(unable to parse)",webBgColor: "#b22222",backgroundColor: Colors.red[400],timeInSecForIosWeb: 3);
  }
  catch(err){
    Fluttertoast.showToast(msg: "something went wrong",webBgColor: "#b22222",backgroundColor: Colors.red[400],timeInSecForIosWeb: 3);
  }
  // httpClient.close();
  // print(bytes);
}


