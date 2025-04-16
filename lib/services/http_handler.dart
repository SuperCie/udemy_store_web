import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void handlerHttp({
  required http.Response response, // response from the request
  required BuildContext context, // show snackbar
  required VoidCallback onSuccess, // if it is a successful response
}) {
  // switch statement to handle different http status codes
  switch (response.statusCode) {
    case 200: // status code 200 indicates a successfull request
      onSuccess();
      break;
    case 400: // status code 400 indicates user error request/bad request
      showBar(context, jsonDecode(response.body)['msg']);
      break;
    case 500: // status code 500 indicates server error
      showBar(context, jsonDecode(response.body)['error']);
      break;
    case 201: // status code 201 indicates a resource was created successfuly
      onSuccess();
      break;
  }
}

void showBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
