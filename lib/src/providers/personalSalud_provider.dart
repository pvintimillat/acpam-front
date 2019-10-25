import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

import 'package:acpam/src/models/personalSalud_model.dart';
import 'package:acpam/src/preferencias_usuario/preferencias_usuario.dart';

class PersonalSaludProvider {

  final String _url = 'http://67.207.85.200:3000';
  final prefs = new PreferenciasUsuario();

  Future<List<String>> crearPersonalSalud(PersonalSaludModel personalSalud) async {

    // final sinConexion = 'Algo ha salido mal. Por favor, revise su conexión a Internet.';
    
    ConnectivityResult _connectivityResult = await (Connectivity().checkConnectivity());

    final List<String> datos = ['Error', 'Por favor, revise su conexión a Internet'];

    if (_connectivityResult != ConnectivityResult.mobile && _connectivityResult != ConnectivityResult.wifi) return datos;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'token': '${prefs.token}'
    };

    final url = '$_url/personalSalud';

    final resp = await http.post(url, body: personalSalud.toJson(), headers:requestHeaders);

    final decodedData = json.decode(resp.body);
    if (decodedData['ok']) {
      datos[0] = 'Ok';
      datos[1] = decodedData['mensaje'];
    } else {
      datos[0] = 'Error';
      datos[1] = decodedData['err']['message'];
    }

    return datos;
  }

  Future<List<PersonalSaludModel>> cargarPersonalSalud(String tipoEspecialidad, int desde, int limite) async {

    ConnectivityResult _connectivityResult = await (Connectivity().checkConnectivity());

    if (_connectivityResult != ConnectivityResult.mobile && _connectivityResult != ConnectivityResult.wifi) return [];
    
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'token': '${prefs.token}'
    };
    
    final url = '$_url/personalSalud?especialidad=$tipoEspecialidad&desde=$desde&limite=$limite';
    final resp = await http.get(url, headers:requestHeaders);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final usuariosPersonalSalud = decodedData['usuarios'];
    final List<PersonalSaludModel> usuarios = new List();

    if (decodedData == null) return [];

    usuariosPersonalSalud.forEach( (usuarioPersonalSalud) {
      
      usuarioPersonalSalud.addAll({'usuarioID': usuarioPersonalSalud['usuario']['_id']});
      usuarios.add(PersonalSaludModel.fromJson(usuarioPersonalSalud));

    });
    
    return usuarios;

  }

  Future<bool> borrarPersonalSalud(String id) async {

    ConnectivityResult _connectivityResult = await (Connectivity().checkConnectivity());

    if (_connectivityResult != ConnectivityResult.mobile && _connectivityResult != ConnectivityResult.wifi) return false;
    
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'token': '${prefs.token}'
    };
    
    final url = '$_url/personalSalud/$id';
    final resp = await http.delete(url, headers:requestHeaders);

    print(json.decode(resp.body));
    
    return true;
  }

}