import 'package:flutter/material.dart';

import 'package:acpam/src/bloc/mostrarMapaAlert.dart';
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
  TextEditingController controlConsultorio = new TextEditingController();

  String _tipoID = 'Cédula';
  bool _seleccion = false;
  bool _guardando = false;
  String _estudios = '';
  bool loading = false;

  @override
  void initState() {
    controlConsultorio.text = 'Sin dirección';
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
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _formulario(context, size),
            _mostrarLoading(size)
          ],
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
                    _crearTipoID(),
                    SizedBox(height: size.height * 0.02),
                    _crearNumeroID(context, size),
                    SizedBox(height: size.height * 0.02),
                    _crearEstudios(context, size),
                    SizedBox(height: size.height * 0.02),
                    _crearEspecialidad(context, size, personalSalud.especialidad),
                    SizedBox(height: size.height * 0.02),
                    _crearSenescyt(context, size),
                    SizedBox(height: size.height * 0.02),
                    _crearCelular(context, size),
                    SizedBox(height: size.height * 0.02),
                    _crearConsultorio(context, size),
                    SizedBox(height: size.height * 0.02),
                    _botonVerMapa(context, size),
                  ],
                ),
              ))),
    );
  }

  Widget _mostrarLoading(Size size) {
    if (loading) {
      return Container(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)
            ),
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

  Widget _crearConsultorio(BuildContext context, Size size) {
    return TextFormField(
      controller: controlConsultorio,
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
              loading = true;
            });
            String _direccion = await coordsTranslateProvider.latlng2Dir();
            setState(() {
              controlConsultorio.text = _direccion;
              loading = false;
            });
          } else {
            setState(() {
              controlConsultorio.text = 'Sin dirección';
            });
          }
        });
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
