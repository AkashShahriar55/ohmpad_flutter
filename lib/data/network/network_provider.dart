import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ohm_pad/data/preferences/preference_manager.dart';
import 'package:ohm_pad/utils/common_utils.dart';
import 'network_check.dart';
import 'network_constants.dart';

enum HttpMethod { GET, POST ,PUT }

class NetworkProvider {
  NetworkProvider._internal();

  static NetworkProvider instance = new NetworkProvider._internal();

  factory NetworkProvider() => instance;

  NetworkCheck networkCheck = new NetworkCheck();

  Future<dynamic> request({
    String? url,
    HttpMethod? method,
    Map<String, dynamic>? body,
    Map<String, dynamic>? getBody,
    Map<dynamic, String>? headers,
    bool isContentTypeJson = false,
    bool isQueryParam = false,
  }) async {
    final Map<dynamic, dynamic> mapNetworkApiStatus = HashMap();

    final bool isConnect = await networkCheck.check();
    if (isConnect) {
      final String authToken = await PreferenceManager.instance.getAuthToken();
//    final String authToken = '';  // Test auth token
      print("Auth Token = $authToken");

      print("Base URL :: ${NetworkAPI.BASE_URL + url!}");
      if (method != HttpMethod.GET) {
        CommonUtils.printWrapped("Body :: $body");
      }

      try {
        Map<String, String> headers = {
          NetworkParams.TOKEN: authToken.isNotEmpty ? "Bearer " + authToken : "",
        };

        String jsonBody = "";

        if (isContentTypeJson) {
          Map<String, String> jsonHeader = {
            'Content-type': 'application/json',
          };
          headers.addAll(jsonHeader);

          jsonBody = json.encode(body);
        }

        // Uri uri= Uri.parse(NetworkAPI.BASE_URL + url).replace(queryParameters: params);
        // await http.get(uri, headers: headers);

        var uri;
        if(method == HttpMethod.GET){
          if(isQueryParam){
            uri = Uri.parse(NetworkAPI.BASE_URL + url + '?' + Uri(queryParameters: body).query);
          }else{
            uri = Uri.parse(NetworkAPI.BASE_URL + url).replace(queryParameters: getBody);
          }
        }
        print("API URL :: $uri");

        final response = method == HttpMethod.GET ? await http.get(uri, headers: headers)
            : method == HttpMethod.PUT ? await http.put(Uri.parse(NetworkAPI.BASE_URL + url),
            body: isContentTypeJson ? jsonBody : body ?? {}, headers: headers)
            : await http.post(Uri.parse(NetworkAPI.BASE_URL + url),
                body: isContentTypeJson ? jsonBody : body ?? {},
                headers: headers);
        print("API Response status code = ${response.statusCode}");
        CommonUtils.printWrapped(
            "API Response data = ${response.body.toString()}");

        if (response.statusCode >= 200 && response.statusCode < 400) {
          mapNetworkApiStatus[NetworkResponse.STATUS_CODE] =
              response.statusCode.toString();
          mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.SUCCESS;
          mapNetworkApiStatus[NetworkResponse.DATA] = response.body.toString();
        } else {
          mapNetworkApiStatus[NetworkResponse.STATUS_CODE] =
              response.statusCode.toString();
          mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.FAILURE;
          mapNetworkApiStatus[NetworkResponse.DATA] = response.body.toString();
        }
        return mapNetworkApiStatus;
      } catch (error) {
        mapNetworkApiStatus[NetworkResponse.STATUS_CODE] = "-1";
        mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.EXCEPTION;
        mapNetworkApiStatus[NetworkResponse.DATA] = error.toString();
        return mapNetworkApiStatus;
      }
    } else {
      mapNetworkApiStatus[NetworkResponse.STATUS_CODE] = "0";
      mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.NO_INTERNET;
      mapNetworkApiStatus[NetworkResponse.DATA] = "Internect not connected";
      return mapNetworkApiStatus;
    }
  }

  Future<dynamic> requestMultipart(
      {String? url,
      HttpMethod? method,
      Map<dynamic, String>? headers,
      Map<dynamic, String>? body,
      String? imageKey,
      File? imageValue,
        bool isContentTypeJson = false}) async {
    final Map<dynamic, dynamic> mapNetworkApiStatus = HashMap();

    final bool isConnect = await networkCheck.check();
    if (isConnect) {
      final String authToken =
          await PreferenceManager.instance.getAuthToken();
      print("Auth Token = $authToken");

      print("Base URL :: ${NetworkAPI.BASE_URL + url!}");
      print("Body :: $body");

      try {
        var uri = Uri.parse(NetworkAPI.BASE_URL + url);
        var request = http.MultipartRequest(method == HttpMethod.POST ? 'POST' : 'PUT', uri);

        body!.forEach((key, value) {
          request.fields[key] = value;
        });

        if (imageValue != null) {
          print("Body profilePic :: ${imageValue.path}");

          try{
            http.MultipartFile multipartFile =
            await http.MultipartFile.fromPath(imageKey!, imageValue.path);
            request.files.add(multipartFile);
          }catch(e){
          }
        }

        final String authToken =
            await PreferenceManager.instance.getAuthToken();
        print("Auth Token = $authToken");

        request.headers[NetworkParams.TOKEN] =
            authToken.isNotEmpty ? "Bearer " + authToken : "";

        var response = await request.send();

        var responseHttp = await http.Response.fromStream(response);

        print("response reasonPhrase = ${response.reasonPhrase}");
        print("response Data = ${response.statusCode}");
        print("response responseHttp body = ${responseHttp.body}");

        if (response.statusCode >= 200 && response.statusCode < 400) {
          mapNetworkApiStatus[NetworkResponse.STATUS_CODE] =
              response.statusCode.toString();
          mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.SUCCESS;
          mapNetworkApiStatus[NetworkResponse.DATA] =
              responseHttp.body.toString();
        } else {
          mapNetworkApiStatus[NetworkResponse.STATUS_CODE] =
              response.statusCode.toString();
          mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.FAILURE;
          mapNetworkApiStatus[NetworkResponse.DATA] =
              responseHttp.body.toString();
        }

        return mapNetworkApiStatus;
      } catch (error) {
        mapNetworkApiStatus[NetworkResponse.STATUS_CODE] = "-1";
        mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.EXCEPTION;
        mapNetworkApiStatus[NetworkResponse.DATA] = error.toString();
        return mapNetworkApiStatus;
      }
    } else {
      mapNetworkApiStatus[NetworkResponse.STATUS_CODE] = "0";
      mapNetworkApiStatus[NetworkResponse.STATUS] = NetworkResponse.NO_INTERNET;
      mapNetworkApiStatus[NetworkResponse.DATA] = "Internect not connected";
      return mapNetworkApiStatus;
    }
  }
}
