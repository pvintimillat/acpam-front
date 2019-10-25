import 'package:acpam/src/routes/routes.dart';
import 'package:flutter/material.dart';

import 'package:acpam/src/bloc/provider.dart';
import 'package:acpam/src/preferencias_usuario/preferencias_usuario.dart';

void main() async {

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());

} 
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ACPAM',
        initialRoute: 'login',
        routes: getApplicationToutes(),
        theme: ThemeData(
          primaryColor: Color.fromRGBO(30, 43, 60, 1.0),
        ),
      ), 
    );
  }
}