import 'package:flutter/material.dart';

import 'package:acpam/src/utils/utils.dart' as utils;
import 'package:acpam/src/providers/personalSalud_provider.dart';

import 'package:acpam/src/models/personalSalud_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class CrearPersonalSaludPage extends StatefulWidget {
  const CrearPersonalSaludPage({Key key}) : super(key: key);

  @override
  _CrearPersonalSaludPageState createState() => _CrearPersonalSaludPageState();
}

class _CrearPersonalSaludPageState extends State<CrearPersonalSaludPage> {
  
  final map = new MapController();

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final personalSaludProvider = new PersonalSaludProvider();

  PersonalSaludModel personalSalud = new PersonalSaludModel();

  String _tipoID = 'Cédula';
  bool _seleccion = false;
  bool _mapa = false;
  bool _guardando = false;
  String _estudios = '';
  LatLng _coords;

  @override
  void initState() { 
    _coords = personalSalud.getLatLng();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final String especialidad = ModalRoute.of(context).settings.arguments;
    final size = MediaQuery.of(context).size;

    personalSalud.tipoId = _tipoID;
    personalSalud.especialidad = especialidad;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Nuevo especialista'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check_circle),
            onPressed: (_guardando) ? null : _submit,
          ),
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: (_guardando) ? null : _reset,
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(size.height * 0.05),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      _crearAvatar(context, size),
                      SizedBox(height: size.height * 0.02),
                      _crearNombres(context, size),
                      SizedBox(height: size.height * 0.02),
                      _crearApellidos(context, size),
                      SizedBox(height: size.height * 0.02),
                      _crearEmail(context, size),
                      SizedBox(height: size.height * 0.02),
                      _crearTipoID(),
                      SizedBox(height: size.height * 0.02),
                      _crearNumeroID(context, size),
                      SizedBox(height: size.height * 0.02),
                      _crearEstudios(context, size),
                      SizedBox(height: size.height * 0.02),
                      _crearEspecialidad(context, size, especialidad),
                      SizedBox(height: size.height * 0.02),
                      _crearSenescyt(context, size),
                      SizedBox(height: size.height * 0.02),
                      _crearCelular(context, size),
                      SizedBox(height: size.height * 0.02),
                      _seleccionarMapa(context, size),
                      SizedBox(height: size.height * 0.02),
                      _crearConsultorio(context, size),
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget _crearAvatar(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () => print('Avatar'),
      child: Container(
          width: size.width * 0.3,
          height: size.width * 0.3,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/noAvatar.png'),
              ))),
    );
  }

  Widget _crearNombres(BuildContext context, Size size) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.height * 0.02),
        ),
        labelText: 'Nombres',
      ),
      validator: (value) {
        if (value.length < 3) {
          return 'El nombre ingresado debe tener al menos 3 letras.';
        } else {
          return null;
        }
      },
      onSaved: (value) => personalSalud.nombres = value,
    );
  }

  Widget _crearApellidos(BuildContext context, Size size) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.height * 0.02),
        ),
        labelText: 'Apellidos',
      ),
      validator: (value) {
        if (value.length < 3) {
          return 'El apellido ingresado debe tener al menos 3 letras.';
        } else {
          return null;
        }
      },
      onSaved: (value) => personalSalud.apellidos = value,
    );
  }

  Widget _crearEmail(BuildContext context, Size size) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.height * 0.02),
        ),
        labelText: 'Correo electrónico',
      ),
      validator: (value) {
        if (utils.isEmail(value)) {
          return null;
        } else {
          return 'El correo electrónico ingresado no es válido.';
        }
      },
      onSaved: (value) => personalSalud.email = value,
    );
  }

  Widget _crearTipoID() {
    return SwitchListTile(
      title: Text('Cédula / Pasaporte'),
      value: _seleccion,
      onChanged: (value) {
        if (value) {
          _tipoID = 'Pasaporte';
        } else {
          _tipoID = 'Cédula';
        }
        setState(() {
          _seleccion = value;
        });
      },
    );
  }

  Widget _crearNumeroID(BuildContext context, Size size) {
    return TextFormField(
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.height * 0.02),
        ),
        labelText: '$_tipoID',
      ),
      validator: (value) {
        if (utils.isCedula(value, _tipoID)) {
          return null;
        } else {
          return 'El número de cédula ingresado no es válido.';
        }
      },
      onSaved: (value) => personalSalud.numeroId = value,
    );
  }

  Widget _crearEstudios(BuildContext context, Size size) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.height * 0.02),
        ),
        labelText: 'Estudios',
        counter: Text('${_estudios.length}'),
      ),
      validator: (value) {
        if (value != '') {
          if ((value.length < 6) | (value.length > 140)) {
            return 'Esta descripción debe poseer de 6 a 140 caracteres.';
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      onChanged: (valor) {
        setState(() {
          _estudios = valor;
        });
      },
      onSaved: (value) => personalSalud.estudios = value,
    );
  }

  Widget _crearEspecialidad(
      BuildContext context, Size size, String especialidad) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.height * 0.02),
        ),
        labelText: '$especialidad',
      ),
      enabled: false,
    );
  }

  Widget _crearSenescyt(BuildContext context, Size size) {
    return TextFormField(
      keyboardType: TextInputType.number,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.height * 0.02),
        ),
        labelText: 'Registro Senescyt',
      ),
      validator: (value) {
        if (value != '') {
          if (utils.isSenescyt(value)) {
            return null;
          } else {
            return 'El registro senescyt ingresado no es válido.';
          }
        } else {
          return null;
        }
      },
      onSaved: (value) => personalSalud.senescyt = value,
    );
  }

  Widget _crearCelular(BuildContext context, Size size) {
    return TextFormField(
      keyboardType: TextInputType.number,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.height * 0.02),
        ),
        labelText: 'Celular',
      ),
      validator: (value) {
        if (utils.isCelular(value)) {
          return null;
        } else {
          return 'El número celular ingresado no es válido.';
        }
      },
      onSaved: (value) => personalSalud.celular = value,
    );
  }

  Widget _seleccionarMapa(BuildContext context, Size size) {
    return SwitchListTile(
      title: Text('Coordenadas / Mapa'),
      value: _mapa,
      onChanged: (value) {
        setState(() {
          _mapa = value;
        });
        _mostrarMapaAlert(context, size);
      },
    );
  }

  Widget _crearConsultorio(BuildContext context, Size size) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.height * 0.02),
        ),
        labelText: 'Consultorio',
      ),
      onSaved: (value) => personalSalud.consultorio = value,
    );
  }

  void _mostrarMapaAlert(BuildContext context, Size size) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  border: new Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 5.0,
                      style: BorderStyle.solid),
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0))),
              height: size.height * 0.75,
              width: size.width * 0.95,
              child: FlutterMap(
                  mapController: map,
                  options: MapOptions(
                      center: _coords,
                      zoom: 10,
                      onPositionChanged: (posicion, valor) {
                        print(valor);
                        if (valor) {
                          setState(() {
                            _coords = posicion.center;
                            print(_coords);
                          });
                        }
                      }),
                  layers: [
                    _crearMapa(),
                    _crearMarcadores(),
                  ]),
            ),
          );
        });
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: "https://api.tiles.mapbox.com/v4/"
          '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken':
            'pk.eyJ1IjoicHZpbnRpbWlsbGEiLCJhIjoiY2syMmFieDVlMTh4ZjNjbWY2MmxiMHZzcSJ9.3YaQE1SExlROXabNB8Hfeg',
        'id': 'mapbox.streets',
      },
    );
  }

  _crearMarcadores() {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
        height: 70.0,
        width: 70.0,
        point: _coords,
        builder: (context) => Container(
          child: Icon(
            Icons.location_on,
            size: 50.0,
            color: Theme.of(context).primaryColor,
          ),
        )
      )
    ]);
  }

  void _submit() {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    personalSaludProvider.crearPersonalSalud(personalSalud);

    setState(() {
      _guardando = false;
    });
    mostarSnackbar('Usuario creado exitosamente');

    Navigator.pop(context);
  }

  void _reset() {
    formKey.currentState.reset();
    setState(() {
      _seleccion = false;
    });
  }

  void mostarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
