import 'package:acpam/src/models/personalSalud_model.dart';
import 'package:flutter/material.dart';

import 'package:acpam/src/providers/personalSalud_provider.dart';

class PersonalPsicologiaPage extends StatefulWidget {
  @override
  _PersonalPsicologiaPageState createState() => _PersonalPsicologiaPageState();
}

class _PersonalPsicologiaPageState extends State<PersonalPsicologiaPage> {

  ScrollController _scrollController = new ScrollController();
  
  final personalSaludProvider = PersonalSaludProvider();
  List<PersonalSaludModel> _especialistas = new List<PersonalSaludModel>();


  bool _cargando = false;
  int _desde = 0;
  int _limite = 10;

  @override
  void initState() { 
    super.initState();
    
    setState(() {
     _cargando = true; 
    });

    _scrollController.addListener( () {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        fetchData();
      }
    });

    personalSaludProvider.cargarPersonalSalud('Psicología', _desde, _limite).then((result) {
      setState(() {
        print(result);
          _especialistas = result;
          _cargando = false;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    print(_especialistas);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        _crearLista(),
        _mostrarLoading(size),
      ],
    );
  }

  Widget _crearLista() {
    return RefreshIndicator(
      onRefresh: _refrescar,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _especialistas.length,
        itemBuilder: (BuildContext context, int index) {
          final especialista = _especialistas[index];
          return _crearItem(especialista);
        },
      ),
    );
  }

  Future<Null> _refrescar() async {
    _especialistas.clear();
    _desde = 0;
    _limite = 10;

    _especialistas = await personalSaludProvider.cargarPersonalSalud('Psicología', _desde, _limite);
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


  Widget _mostrarLoading(Size size) {
    if (_cargando) {
      return Center(
        child: Container(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)
              ),
              width: size.width * 0.2,
              height: size.width * 0.2,
        ),
      );
    } else {
      return Container();
    }
  }       

  void _agregar10() {
    _desde += 10;
    _limite += 10;
  } 

  Future fetchData() async {
    
    _cargando = true;
    setState(() {});
    _scrollController.animateTo(
      _scrollController.position.pixels + 100,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 250),
    );
    _agregar10();
    final List<PersonalSaludModel> especialistas = await personalSaludProvider.cargarPersonalSalud('Psicología', _desde, _limite);
    especialistas.forEach((especialista) {
      _especialistas.add(especialista);
    });
    _cargando = false;
    setState(() {});

  }
}