abstract class ApiListener {
  void setLoadingState(bool isShow);
  void onApiSuccess(String statusCode, String apiName, dynamic mObject);
  void onApiFailure(String statusCode, String apiName, String message);
  void onException();
  void onNoInternetConnection();
}
