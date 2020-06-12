class ApiResponse<T>{
  bool success;
  String msg;
  T result;

  ApiResponse.success({this.result, this.msg}){
    success = true;
  }

  ApiResponse.error({this.result, this.msg}){
    success = false;
  }

}