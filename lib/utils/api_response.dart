class ApiResponse<T>{
  bool success;
  String msg;
  T result;

  ApiResponse.success(this.result){
    success = true;
  }

  ApiResponse.error(this.msg){
    success = false;
  }

}