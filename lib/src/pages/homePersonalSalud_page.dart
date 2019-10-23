import 'package:flutter/material.dart';

import 'package:acpam/src/bloc/provider.dart';

class HomePersonalSaludPage extends StatelessWidget {
  const HomePersonalSaludPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Salud'),
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