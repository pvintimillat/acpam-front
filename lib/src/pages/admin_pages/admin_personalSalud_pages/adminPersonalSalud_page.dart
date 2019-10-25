import 'package:acpam/src/pages/admin_pages/admin_personalSalud_pages/adminListaPersonalSalud_page.dart';
import 'package:acpam/src/pages/admin_pages/admin_personalSalud_pages/personalEnfermeria_page.dart';
import 'package:acpam/src/pages/admin_pages/admin_personalSalud_pages/personalGerontologia_page.dart';
import 'package:acpam/src/pages/admin_pages/admin_personalSalud_pages/personalMedicina_page.dart';
import 'package:acpam/src/pages/admin_pages/admin_personalSalud_pages/personalOdontologia_page.dart';
import 'package:acpam/src/pages/admin_pages/admin_personalSalud_pages/personalPsicologia_page.dart';
import 'package:flutter/material.dart';

import 'package:acpam/src/preferencias_usuario/preferencias_usuario.dart';

class AdminPersonalSaludPage extends StatefulWidget {
  const AdminPersonalSaludPage({Key key}) : super(key: key);

  @override
  _AdminPersonalSaludPageState createState() => _AdminPersonalSaludPageState();
}

class _AdminPersonalSaludPageState extends State<AdminPersonalSaludPage> {

  int currentIndex = 2;
  List<String> tipo = ['Enfermería', 'Medicina', 'Gerontología', 'Odontología', 'Psicología'];
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal de ${tipo[currentIndex]}'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.group_add),
            onPressed: () => Navigator.pushNamed(context, 'crearPersonalSalud', arguments: tipo[currentIndex]),
          )
        ],
      ),
      drawer: _crearMenuLateral(context),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
    );
  }

  Widget _callPage(int paginaActual) {

    switch(paginaActual) {
      case 0: return PersonalEnfermeriaPage(); break;
      case 1: return PersonalMedicinaPage(); break;
      case 2: return PersonalGerontologiaPage(); break;
      case 3: return PersonalOdontologiaPage(); break;
      case 4: return PersonalPsicologiaPage(); break;
      
      default: return PersonalGerontologiaPage(); break;
    }
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.add_alert),
          title: Text('Enfermería')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          title: Text('Medicina')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.accessible),
          title: Text('Gerontología')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.airline_seat_flat),
          title: Text('Odontología')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.adb),
          title: Text('Psicología')
        ),
      ],
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
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Crear GADs'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'crearGAD');
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