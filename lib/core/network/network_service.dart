import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../errors/errors.dart';
import '../utils/typedef.dart';

class NetworkService {
  static final _headers = {'Content-Type': 'application/json'};

  static EitherResponse<Map<String, dynamic>> testCall(
      var rawData, String url) async {
    await Future.delayed(const Duration(seconds: 1));
    final Map<String, dynamic> response = {
      'name': 'name',
      'mobileNumber': 'mobileNumber',
      'spotId': 'spotId'
    };
    // final exception=BadRequestException();
    return Right(response);
  }

  static EitherResponse<Map> postApi(var rawData, String url) async {
    Map fetchedData = {};

    final uri = Uri.parse(url);
    final body = jsonEncode(rawData);
    try {
      final response = await http.post(uri, body: body, headers: _headers);
      fetchedData = _getResponse(response);
    } on SocketException {
      return Left(InternetException());
    } on http.ClientException {
      // return Left(RequestTimeOUtException());
    } catch (e) {
      print(e);
      return Left(BadRequestException());
    }
    return Right(fetchedData);
  }

  static EitherResponse getApi(String url) async {
    final uri = Uri.parse(url);

    dynamic fetchedData;
    try {
      final response = await http.get(uri, headers: _headers);
      fetchedData = _getResponse(response);
    } on SocketException {
      return Left(InternetException());
    } on http.ClientException {
      // return Left(RequestTimeOUtException());
    } catch (e) {
      return Left(BadRequestException());
    }
    return Right(fetchedData);
  }

  static EitherResponse putApi(var rawData, String url) async {
    final uri = Uri.parse(url);
    final body = jsonEncode(rawData);
    dynamic fetchedData;

    try {
      final response = await http.put(uri, body: body, headers: _headers);
      fetchedData = _getResponse(response);
    } on SocketException {
      return Left(InternetException());
    } on http.ClientException {
      // return Left(RequestTimeOUtException());
    } catch (e) {
      print(e);
      return Left(BadRequestException());
    }
    return Right(fetchedData);
  }

  static EitherResponse<Map> patchApi(
    var userData,
    String url,
    String token,
  ) async {
    final uri = Uri.parse(url);
    final body = jsonEncode(userData);
    _headers['vendortoken'] = token;
    Map<String, dynamic> fetchedData = {};
    try {
      final response = await http.patch(uri, body: body, headers: _headers);
      fetchedData = _getResponse(response);
    } on SocketException {
      return Left(InternetException());
    } on http.ClientException {
      // return Left(RequestTimeOUtException());
    } catch (e) {
      return Left(BadRequestException());
    }
    return Right(fetchedData);
  }

  static EitherResponse deleteApi(String url, String token) async {
    _headers['vendortoken'] = token;
    dynamic fetchedData;
    final uri = Uri.parse(url);
    try {
      final response = await http.delete(uri, headers: _headers);
      fetchedData = _getResponse(response);
    } on SocketException {
      return Left(InternetException());
    } on http.ClientException {
      // return Left(());
    } catch (e) {
      return Left(BadRequestException());
    }
    return Right(fetchedData);
  }

  static dynamic _getResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return (jsonDecode(response.body));
      case 400:
        throw BadRequestException();
      default:
        throw BadRequestException();
    }
  }
}
