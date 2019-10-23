import 'package:flutter/material.dart';

void mostrarAlerta(BuildContext context, String mensaje, Size size) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('¡Advertencia!',
              style: TextStyle(
                  fontSize: size.height * 0.03,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.error,
                color: Colors.redAccent,
                size: size.height * 0.1,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Text(mensaje,
                  style: TextStyle(
                      fontSize: size.height * 0.025,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

bool isEmail(String email) {
  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);

  return (regExp.hasMatch(email)) ? true : false;
}

bool isCedula(String cedula, String tipo) {
  if (tipo == 'Cédula') {
    if (cedula.length == 10) {
      String digitoRegion = cedula.substring(0, 2);

      if (int.parse(digitoRegion) >= 1 && int.parse(digitoRegion) <= 24) {
        String ultimoDigito = cedula.substring(9, 10);

        int pares = 0;
        for (int i = 1; i < 5; i++) {
          pares = pares + int.parse(cedula.substring(i * 2 - 1, i * 2));
        }

        int impares = 0;
        for (int i = 0; i < 5; i++) {
          if ((int.parse(cedula.substring(i * 2, i * 2 + 1)) * 2) > 9) {
            impares = impares +
                (int.parse(cedula.substring(i * 2, i * 2 + 1)) * 2) -
                9;
          } else {
            impares =
                impares + (int.parse(cedula.substring(i * 2, i * 2 + 1)) * 2);
          }
        }

        String sumaTotal = (pares + impares).toString();

        int primerDigitoSuma = int.parse((sumaTotal).substring(0, 1));
        int decena = (primerDigitoSuma + 1) * 10;
        int digitoValidador = decena - int.parse(sumaTotal);

        if (digitoValidador == 10) digitoValidador = 0;

        if (digitoValidador.toString() == ultimoDigito) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    return true;
  }
}

bool isCelular(String celular) {
  
  Pattern pattern = r'[0][9][0-9]{8}\b';
  RegExp regExp = new RegExp(pattern);

  return (regExp.hasMatch(celular)) ? true : false;
}

bool isSenescyt(String senescyt) {
  
  Pattern pattern = r'\b[0-9]{4}\b-\b[0-9]{4}\b-\b[0-9]{7}\b';
  RegExp regExp = new RegExp(pattern);

  return (regExp.hasMatch(senescyt)) ? true : false;
}

