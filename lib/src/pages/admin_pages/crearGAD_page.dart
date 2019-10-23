import 'package:flutter/material.dart';

import 'package:acpam/src/preferencias_usuario/preferencias_usuario.dart';

class CrearGADPage extends StatelessWidget {
  
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GADs'),
      ),
      drawer: _crearMenuLateral(context),
      body: Center(
        child: Text('GAD Page'),
      ),
    );
  }

  Widget _crearMenuLateral(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/menuLateral.jpg'),
                fit: BoxFit.cover
              )
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Crear administrador general'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'crearAdmin');
            },
          ),
          ListTile(
            leading: Icon(Icons.cached),
            title: Text('Crear administrador de GAD'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'crearAdminGAD');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Crear personal de salud'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'adminPersonalSalud');
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Crear GADs'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
              // TO DO: Crear página de configuraciones 
            },
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text('Cerrar sesión'),
            onTap: () {
              Navigator.pop(context);
              _cerrarSesion(context);
            },
          ),
        ],
      ),
    );
  }

  void _cerrarSesion(BuildContext context) {
    prefs.token = '';
    Navigator.pushReplacementNamed(context, 'login');
  }

}