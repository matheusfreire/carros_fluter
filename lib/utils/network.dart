import 'package:connectivity/connectivity.dart';

Future<bool> isNetworkOn() async{
  
  var connectivityResult = await (Connectivity().checkConnectivity());
  print(connectivityResult);
  return connectivityResult != ConnectivityResult.none;
}