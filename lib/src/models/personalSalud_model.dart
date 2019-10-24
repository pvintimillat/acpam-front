import 'dart:convert';

import 'package:latlong/latlong.dart';

PersonalSaludModel personalSaludModelFromJson(String str) => PersonalSaludModel.fromJson(json.decode(str));

String personalSaludModelToJson(PersonalSaludModel data) => json.encode(data.toJson());

class PersonalSaludModel {
    String estudios;
    String senescyt;
    String id;
    String nombres;
    String apellidos;
    String tipoId;
    String numeroId;
    String especialidad;
    String celular;
    String consultorio;
    String usuarioID;
    String email;
    String password;
    String rol;

    PersonalSaludModel({
        this.estudios,
        this.senescyt,
        this.id,
        this.nombres,
        this.apellidos,
        this.tipoId,
        this.numeroId,
        this.especialidad,
        this.celular,
        this.consultorio,
        this.usuarioID,
        this.email,
        this.password,
        this.rol = 'personalSalud',
    });

    factory PersonalSaludModel.fromJson(Map<String, dynamic> json) => PersonalSaludModel(
        estudios: json["estudios"],
        senescyt: json["senescyt"],
        id: json["_id"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        tipoId: json["tipoID"],
        numeroId: json["numeroID"],
        especialidad: json["especialidad"],
        celular: json["celular"],
        consultorio: json["consultorio"],
        usuarioID: json["usuarioID"],
        email: json["email"]
    );

    Map<String, dynamic> toJson() => {
        "estudios": "$estudios",
        "senescyt": "$senescyt",
        "_id": "$id",
        "nombres": "$nombres",
        "apellidos": "$apellidos",
        "tipoID": "$tipoId",
        "numeroID": "$numeroId",
        "especialidad": "$especialidad",
        "celular": "$celular",
        "consultorio": "$consultorio",
        "usuarioID": "$usuarioID",
        "email": "$email",
        "password": "$password",
        "rol": "$rol",
    };

    LatLng getLatLng() {

      String _valor = '-2.8968987,-78.9373582';
      final lalo = _valor.split(',');
      final lat = double.parse(lalo[0]);
      final lng = double.parse(lalo[1]);

      return LatLng(lat, lng);

    }
}