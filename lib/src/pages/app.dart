import 'package:daily_report/src/pages/chart/chart_page.dart';
import 'package:daily_report/src/pages/home.dart';
import 'package:daily_report/src/pages/home/controller/home_controller.dart';
import 'package:daily_report/src/pages/home/homepage.dart';
import 'package:daily_report/src/pages/list/list_page.dart';
import 'package:daily_report/src/pages/settings/settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Container(
            child: Center(
              child: Text('loading error'),
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.done){
          return Home();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
