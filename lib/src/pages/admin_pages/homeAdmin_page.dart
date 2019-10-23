import 'package:acpam/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter/material.dart';

//import 'package:acpam/src/bloc/provider.dart';

class HomeAdminPage extends StatelessWidget {
  
  final prefs = new PreferenciasUsuario();
  
  @override
  Widget build(BuildContext context) {

    // final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[ 
          Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: IconButton(
                icon: Icon(Icons.person_add),
                color: Colors.white,
                onPressed: () => _crearUsuario('crearAdmin', context),
                iconSize: size.height*0.05,
              ),
            ),
          ),
          SizedBox(height: size.height*0.225),
          Expanded(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                        child: GestureDetector(
                            onTap: () {
                              _crearUsuario('crearAdminGAD', context);
                            },
                            child: Icon(
                              Icons.cached,
                              color: Colors.white,
                              size: size.height*0.15,
                          ),
                        ),
                  ),
                  SizedBox(width: size.height*0.05),
                  Container(
                        child: GestureDetector(
                            onTap: () {
                              _crearUsuario('adminPersonalSalud', context);
                            },
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: size.height*0.15,
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height*0.05,),
          Container(
            child: GestureDetector(
              onTap: () {
                _crearUsuario('crearGAD', context);
              },
              child: Icon(
                Icons.home,
                color: Colors.white,
                size: size.height*0.15,
              ),
            ),
          ),
          SizedBox(height: size.height*0.305,),
        ],
      )
    );
  }

  _crearUsuario(String tipoUsuario, BuildContext context) {
    Navigator.pushReplacementNamed(context, tipoUsuario);
  }
}