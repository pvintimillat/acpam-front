import 'package:flutter/material.dart';

import 'package:acpam/src/pages/admin_pages/admin_personalSalud_pages/adminPersonalSalud_page.dart';
import 'package:acpam/src/pages/admin_pages/admin_personalSalud_pages/crearPersonalSalud_page.dart';
import 'package:acpam/src/pages/admin_pages/crearAdminGAD_page.dart';
import 'package:acpam/src/pages/admin_pages/crearAdmin_page.dart';
import 'package:acpam/src/pages/admin_pages/crearGAD_page.dart';
import 'package:acpam/src/pages/admin_pages/homeAdmin_page.dart';
import 'package:acpam/src/pages/homeAdminGAD_page.dart';
import 'package:acpam/src/pages/homePersonalSalud_page.dart';
import 'package:acpam/src/pages/login_page.dart';

Map<String, WidgetBuilder> getApplicationToutes() {
  return <String, WidgetBuilder>{
    'login': (BuildContext context) => LoginPage(),
    
    'adminRoot': (BuildContext context) => HomeAdminPage(),
    'adminGAD': (BuildContext context) => HomeAdminGADPage(),
    'personalSalud': (BuildContext context) => HomePersonalSaludPage(),
    'crearAdmin': (BuildContext context) => CrearAdminPage(),
    'crearAdminGAD': (BuildContext context) => CrearAdminGADPage(),
    'crearGAD': (BuildContext context) => CrearGADPage(),
          
    'adminPersonalSalud': (BuildContext context) => AdminPersonalSaludPage(),
    'crearPersonalSalud': (BuildContext context) => CrearPersonalSaludPage(),
  };
}
