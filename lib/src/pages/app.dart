import 'dart:async';
import 'package:daily_report/src/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(
              child: Text('loading error'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Timer(Duration(milliseconds: 2000), () {
            Get.off(() => Home());
          });
        }
        return loadingSplash(context);
      },
    );
  }

  Widget loadingSplash(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          width: context.mediaQuery.size.height * 0.19,
          height: context.mediaQuery.size.height * 0.19,
          decoration: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Container(
              alignment: Alignment.center,
              width: context.mediaQuery.size.height * 0.15,
              height: context.mediaQuery.size.height * 0.15,
              child: Text(
                'DAILY REPORT',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: (context.mediaQuery.size.height * 0.15) * 0.24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: '',
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
