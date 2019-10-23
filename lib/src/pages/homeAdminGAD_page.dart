import 'package:flutter/material.dart';

import 'package:acpam/src/bloc/provider.dart';

class HomeAdminGADPage extends StatelessWidget {
  const HomeAdminGADPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Administrador de GAD'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Email: ${bloc.email}')
        ],
      ),
    );
  }
}