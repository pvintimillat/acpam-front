import 'dart:convert';

import 'package:acpam/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class CoordTranslate {

  final prefs = new PreferenciasUsuario();
  final String _url = 'https://us1.locationiq.com/v1/reverse.php';
  final String _token = 'pk.73ec911f2d36a5bdd0cde445b6dba45a';

  Future<String> latlng2Dir() async {

    final sinConexion = 'Algo ha salido mal. Por favor, revise su conexión a Internet.';
    
    ConnectivityResult _connectivityResult = await (Connectivity().checkConnectivity());

    if (_connectivityResult != ConnectivityResult.mobile && _connectivityResult != ConnectivityResult.wifi) return sinConexion;//{'ok': false, 'mensaje': sinConexion};

    final coords = prefs.coords.split(',');
    final String url = '$_url?key=$_token&lat=${coords[0]}&lon=${coords[1]}&format=json';
    
    final resp = await http.post(url);
    
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    prefs.coords = 'Sin direccion';
    return '${decodedResp['display_name']}';

  }
}