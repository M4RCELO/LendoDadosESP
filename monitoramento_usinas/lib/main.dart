import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase/firebase.dart' as firebase;

void main() {

  if (firebase.apps.length==0) {
    firebase.initializeApp(
      apiKey: "AIzaSyCUPlI04giphZW0NPJ73P8UiZcHwKCieSI",
      authDomain: "testes-a00da.firebaseapp.com",
      databaseURL: "https://testes-a00da-default-rtdb.firebaseio.com",
      projectId: "testes-a00da",
      storageBucket: "testes-a00da.appspot.com",
    );
  }else {
    firebase.app();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LineChartSample(),
    );
  }
}

class LineChartSample extends StatefulWidget {
  @override
  _LineChartSampleState createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {

  double mX = 2;
  Timer timer;
  DatabaseReference _firebase = firebase.database().ref('Geral/Dados');
  List<FlSpot> dados = [FlSpot(0, 0),FlSpot(1, 0)];
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => atualizarDados());
  }

  void atualizarDados(){
    dados = [];
    double cont = 0;
    _firebase.once('value').then((snapshot){
      if(snapshot.snapshot.val()==null){
        dados = [FlSpot(0, 0),FlSpot(1, 0)];
        cont = 2;
      }else{
        snapshot.snapshot.val().forEach((k,v){
          dados.add(FlSpot(cont, v));
          cont+=1;
        });
      }
      if(cont==1){
        cont = 2;
        dados.add(FlSpot(1, dados[0].y));
      }
      setState(() {
        mX = cont;
        dados = dados;
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(color: Color(0xffD3D3D3)),
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height/2,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: Color(0xff232d37)),
            child: Padding(
              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/30, left: MediaQuery.of(context).size.width/45, top: MediaQuery.of(context).size.height/20, bottom: MediaQuery.of(context).size.height/20),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        )
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.transparent,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: false,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 10:
                return '10';
              case 20:
                return '20';
              case 30:
                return '30';
              case 40:
                return '40';
              case 50:
                return '50';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: (mX-1),
      minY: 0,
      maxY: 50,
      lineBarsData: [
        LineChartBarData(
          spots: dados,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

}

