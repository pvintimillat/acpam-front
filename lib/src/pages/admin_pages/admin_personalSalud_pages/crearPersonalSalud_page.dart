import 'dart:async';

import 'package:flutter/material.dart';

import 'package:acpam/src/utils/mostrarMapaAlert.dart';
import 'package:acpam/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:acpam/src/providers/coordTranslate_provider.dart';

import 'package:acpam/src/utils/utils.dart' as utils;
import 'package:acpam/src/providers/personalSalud_provider.dart';

import 'package:acpam/src/models/personalSalud_model.dart';

class CrearPersonalSaludPage extends StatefulWidget {
  const CrearPersonalSaludPage({Key key}) : super(key: key);

  @override
  _CrearPersonalSaludPageState createState() => _CrearPersonalSaludPageState();
}

class _CrearPersonalSaludPageState extends State<CrearPersonalSaludPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final prefs = new PreferenciasUsuario();

  final personalSaludProvider = new PersonalSaludProvider();
  final coordsTranslateProvider = new CoordTranslate();

  PersonalSaludModel personalSalud = new PersonalSaludModel();
  TextEditingController _controlConsultorio = new TextEditingController();

  String _tipoID = 'Cédula';
  bool _guardando = false;
  String _estudios = '';
  bool _loading = false;

  List<String> _opcionesID = ['Cédula', 'Pasaporte'];

  @override
  void initState() {
    _controlConsultorio.text = 'Sin dirección';
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
              onPressed: (_guardando) ? () => null : () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _submit(context, size);
                },
            ),
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: (_guardando) ? () => null : () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _reset();
              },
            )
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[_formulario(context, size), _mostrarLoading(size)],
        ));
  }

  Widget _formulario(BuildContext context, Size size) {
    return GestureDetector(
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
                    _crearNumeroID(context, size),
                    SizedBox(height: size.height * 0.02),
                    _crearEstudios(context, size),
                    SizedBox(height: size.height * 0.02),
                    _crearEspecialidad(
                        context, size, personalSalud.especialidad),
                    SizedBox(height: size.height * 0.02),
                    _crearSenescyt(context, size),
                    SizedBox(height: size.height * 0.02),
                    _crearCelular(context, size),
                    SizedBox(height: size.height * 0.02),
                    _crearConsultorio(context, size),
                  ],
                ),
              ))),
    );
  }

  Widget _mostrarLoading(Size size) {
    if (_loading) {
      return Container(
        child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
        width: size.width * 0.15,
        height: size.width * 0.15,
      );
    } else {
      return Container();
    }
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

  List<DropdownMenuItem<String>> getOpcionesID() {
    List<DropdownMenuItem<String>> lista = new List();

    _opcionesID.forEach((opcion) {
      lista.add(DropdownMenuItem(child: Text(opcion), value: opcion));
    });

    return lista;
  }

  Widget _crearNumeroID(BuildContext context, Size size) {
    return Row(
      children: <Widget>[
        Flexible(
          child: TextFormField(
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(size.height * 0.02),
              ),
              labelText: 'Identificación',
            ),
            validator: (value) {
              if (utils.isCedula(value, _tipoID)) {
                return null;
              } else {
                return 'El número de cédula ingresado no es válido.';
              }
            },
            onSaved: (value) => personalSalud.numeroId = value,
          ),
        ),
        SizedBox(width: size.width*0.03),
        Container(
          alignment: Alignment.centerRight,
          child: DropdownButton(
            value: _tipoID,
            items: getOpcionesID(),
            onChanged: (opt) {
              setState(() {
                _tipoID = opt;
              });
            },
          ),
        )
      ],
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
      ),
      validator: (value) {
        if (value != '') {
          if ((value.length < 6)) {
            return 'Esta descripción debe poseer mínimo 6 caracteres.';
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

  Widget _crearConsultorio(BuildContext context, Size size) {
    return Row(
      children: <Widget>[
        Flexible(
          child: TextFormField(
            controller: _controlConsultorio,
            enabled: false,
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(size.height * 0.02),
              ),
              labelText: 'Consultorio',
            ),
            onSaved: (value) => personalSalud.consultorio = value,
          ),
        ),
        SizedBox(width: size.width*0.03),
        _botonVerMapa(context, size),
      ],
    );
  }

  Widget _botonVerMapa(BuildContext context, Size size) {
    return RaisedButton.icon(
        label: Text('Ver mapa'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.height * 0.02)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        icon: Icon(Icons.map),
        onPressed: () async {
          bool cierreVerMapa = await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) {
                return MostrarMapaAlert();
              });
          if (cierreVerMapa) {
            setState(() {
              _loading = true;
            });
            String _direccion = await coordsTranslateProvider.latlng2Dir();
            setState(() {
              _controlConsultorio.text = _direccion;
              _loading = false;
            });
          } else {
            setState(() {
              _controlConsultorio.text = 'Sin dirección';
            });
          }
        });
  }

  void _submit(BuildContext context, Size size) async {
    if (!formKey.currentState.validate()) return;

    if (_controlConsultorio.text == 'Sin dirección') {
      utils.mostrarAlerta(context, 'Por favor, seleccione una dirección de consultorio válida', size);
      return;
    }

    formKey.currentState.save();

    setState(() {
      _guardando = true;
      _loading = true;
    });

    final List<String> resp = await personalSaludProvider.crearPersonalSalud(personalSalud);

    setState(() {
      _guardando = false;
      _loading = false;
    });


    if (resp[0] == 'Ok') {
      mostarSnackbar('Usuario creado exitosamente');
      _reset();

    } else {
      utils.mostrarAlerta(context, resp[1], size);
    }

  }

  void _reset() {
    formKey.currentState.reset();
    setState(() {
      _controlConsultorio.text = 'Sin dirección';
    });
  }

  Future mostarSnackbar(String mensaje) async {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
