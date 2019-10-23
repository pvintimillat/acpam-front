import 'package:acpam/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter/material.dart';

import 'package:acpam/src/models/personalSalud_model.dart';
import 'package:acpam/src/providers/personalSalud_provider.dart';

class AdminListaPersonalSaludPage extends StatelessWidget {
  
  final personalSaludProvider = PersonalSaludProvider();
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return _crearListado();
  }

  Widget _crearListado() {
    
    return FutureBuilder(
      future: personalSaludProvider.cargarPersonalSalud(prefs.especialidad),
      builder: (BuildContext context, AsyncSnapshot<List<PersonalSaludModel>> snaphot) {
        if (snaphot.hasData) {
          final especialistas = snaphot.data;
          return ListView.builder(
            itemCount: especialistas.length,
            itemBuilder: (context, i) => _crearItem(especialistas[i]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(PersonalSaludModel personalSalud) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion) {
        personalSaludProvider.borrarPersonalSalud(personalSalud.id);
      },
      child: ListTile(
        title: Text('${personalSalud.nombres} ${personalSalud.apellidos}'),
        subtitle: Text('${personalSalud.especialidad}'),
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/noAvatar.png'),
        ),
        //contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
        selected: true,
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}