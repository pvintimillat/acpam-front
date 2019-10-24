import 'package:acpam/src/bloc/provider.dart';
import 'package:acpam/src/providers/usuario_provider.dart';
import 'package:acpam/src/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usuarioProvider = new UsuarioProvider();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _crearFondo(context, size),
            _loginForm(context, size),
          ],
        ),
      )
    );
  }

  Widget _crearFondo(BuildContext context, Size size) {
    
    final fondoACPAM = Container(
      height: size.height * 0.47,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
    );

    return Stack(
      children: <Widget>[
        fondoACPAM,
        Container(
          padding: EdgeInsets.only(top: size.height*0.1),
          child: Column(
            children: <Widget>[
              Center(
                child: SvgPicture.asset('assets/images/acamDark.svg', height: size.height*0.25) ,
              ),
            ],
          )
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context, Size size) {

    final bloc = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: size.height * 0.3,
            )
          ),
          Container(
            width: size.width * 0.8,
            margin: EdgeInsets.symmetric(vertical:30.0),
            padding: EdgeInsets.symmetric(vertical: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('¡Bienvenido!', style: TextStyle(fontSize: 20.0, color: Theme.of(context).primaryColor, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                SizedBox(height: size.height*0.03,),
                _crearEmail(bloc, size),
                SizedBox(height: size.height*0.03,),
                _crearPassword(bloc, size),
                SizedBox(height: size.height*0.05,),
                _crearBoton(bloc, size),
              ],
            ),
          ),
          SizedBox(height: 50.0),
          _mostrarLoading(size),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc, Size size) {

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Theme.of(context).primaryColor),
              hintText: 'ejemplo@correo.com',
              errorText: snapshot.error
            ),
            onChanged: bloc.changeEmail,
          ),
        );  
      },
    );

  }

  Widget _crearPassword(LoginBloc bloc, Size size) {

    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
              labelText: 'Contraseña',
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc, Size size) {

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.2, vertical: size.height*0.02),
            child: Text('Iniciar Sesión'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          elevation: 0.0,
          color: Theme.of(context).primaryColor,
          textColor: Colors.white ,
          onPressed: snapshot.hasData && !loading ? () {
            setState(() {
              loading = true;
            });
            FocusScope.of(context).requestFocus(new FocusNode());
            _login(context, bloc, size);
          } : null,
        );
      },
    );
  }

  Widget _mostrarLoading(Size size) {
    if (loading) {
      return Container(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)
            ),
            width: size.width * 0.2,
            height: size.width * 0.2,
      );
    } else {
      return Container();
    }
  }          

  _login(BuildContext context, LoginBloc bloc, Size size) async {

    Map info = await usuarioProvider.login(bloc.email, bloc.password);

    loading = false;

    if (info['rol'] != null) {
      Navigator.pushReplacementNamed(context, info['rol']);
    } else {
      setState(() {});
      mostrarAlerta(context, info['mensaje'], size);
    }
  }
}