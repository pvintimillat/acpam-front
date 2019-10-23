import 'dart:convert';

import 'package:acpam/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class UsuarioProvider {

  final prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {
    
    final authData = {
      'email': email,
      'password': password
    };

    final sinConexion = 'Algo ha salido mal. Por favor, revise su conexión a Internet.';
    
    ConnectivityResult _connectivityResult = await (Connectivity().checkConnectivity());

    if (_connectivityResult != ConnectivityResult.mobile && _connectivityResult != ConnectivityResult.wifi) return {'ok': false, 'mensaje': sinConexion};
        
    final resp = await http.post(
      'http://67.207.85.200:3000/login',
      body: authData
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('token')) {

      prefs.token = decodedResp['token'];
      return {'ok': true, 'token': decodedResp['token'], 'rol': decodedResp['usuario']['rol']};
      
    } else {
      return {'ok': false, 'mensaje': decodedResp['err']['mensaje']};
    }

  }
}