// import 'dart:math';
//
// import 'package:daily_report/color.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:get/get.dart';
//
// class ChartController extends GetxController{
//   var chartList = <PieChartSectionData>[].obs;
//
//   void setInitList() {
//     chartList([
//       PieChartSectionData(
//         title: '15%',
//         color: Colors.red,
//         value: 15,
//         radius: 60,
//       ),
//       PieChartSectionData(
//         title: '20%',
//         color: Colors.blue,
//         value: 20,
//         radius: 60,
//       ),
//     ]);
//   }
//
//
//   void addListData(String title, double value){
//     chartList.add(PieChartSectionData(
//       title: title,
//       value: value,
//       color: colorList[Random().nextInt(colorList.length)]
//     ));
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     setInitList();
//   }
// }