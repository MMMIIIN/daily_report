import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowLicensePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(child: LicensePage()),
            Expanded(child: Column(
              children: [
                Row(
                  children: [
                    Text('')
                  ],
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
