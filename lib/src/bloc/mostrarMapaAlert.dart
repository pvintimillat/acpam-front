import 'package:acpam/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'package:acpam/src/models/personalSalud_model.dart';

class MostrarMapaAlert extends StatefulWidget {
  @override
  _MostrarMapaAlertState createState() => _MostrarMapaAlertState();
}

class _MostrarMapaAlertState extends State<MostrarMapaAlert> {
  
  final map = new MapController();
  final prefs = new PreferenciasUsuario();
  
  PersonalSaludModel personalSalud = new PersonalSaludModel();
  LatLng _coords;

  @override
  void initState() {
    _coords = personalSalud.getLatLng();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _botonOk(context, size),
            SizedBox(width: size.width * 0.02),
            _botonCancel(context, size),
          ],
        ),
        SizedBox(height: size.height * 0.01),
        Container(
            decoration: BoxDecoration(
                border: new Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 5.0,
                    style: BorderStyle.solid),
                borderRadius: new BorderRadius.all(new Radius.circular(5.0))),
            height: size.height * 0.85,
            width: size.width * 0.95,
            child: FlutterMap(
                mapController: map,
                options: MapOptions(
                    center: _coords,
                    zoom: 10,
                    onPositionChanged: (posicion, valor) {
                      if (valor) {
                        setState(() {
                          _coords = posicion.center;
                          prefs.coords = ('${posicion.center.latitude.toString()},${posicion.center.longitude.toString()}');
                        });
                      }
                    }),
                layers: [
                  _crearMapa(),
                  _crearMarcadores(),
                ]),
          ),
      
      ],
    );
  }

  Widget _botonOk(BuildContext context, Size size) {
    return RaisedButton.icon(
      label: Text('Aceptar'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height * 0.02)),
      color: Colors.green,
      textColor: Colors.white,
      icon: Icon(Icons.check_circle),
      onPressed: () => Navigator.pop(context, true),
    );
  }

  Widget _botonCancel(BuildContext context, Size size) {
    return RaisedButton.icon(
      label: Text('Cancelar'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height * 0.02)),
      color: Colors.red,
      textColor: Colors.white,
      icon: Icon(Icons.check_circle),
      onPressed: () {
        prefs.coords = 'Sin dirección';
        Navigator.pop(context, false);
      } 
    );
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
              ))
    ]);
  }
}