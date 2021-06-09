import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:losflores_flower_id/plant.dart';

void main() {
  runApp(MyApp());
}

final _biggerFont = TextStyle(fontSize: 18.0);

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Los Flores Plant Guide',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FlowerID(),
    );
  }
}

class FlowerID extends StatefulWidget
{
  FlowerID({Key? key}) : super(key: key);

  @override
  _FlowerIDState createState() => _FlowerIDState();
}

class _FlowerIDState extends State<FlowerID>
{
  List<Plant> list = [];

  @override
  void initState()
  {
    super.initState();

    buildList().then((value)
    {
      setState(()
      {
        list = value;
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    final tiles = list.map((Plant plant)
      {
        return getListElement(plant);
      },
    );
    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(context: context, tiles: tiles, color: Colors.black)
        .toList() : <Widget>[];

    return Scaffold(
        appBar: AppBar(
          title: Text('Los Flores Plant Guide'),
        ),
        body: ListView(children: divided),
    );
  }

  Future<List<Plant>> buildList() async
  {
    String rawList = await rootBundle.loadString('assets/plant_list.txt');
    List<String> lines = new LineSplitter().convert(rawList);

    List<Plant> list = [];

    for(int i = 0; i < lines.length; i+=4)
    {
      //print("adding: " + lines[i]);
      list.add(new Plant(lines[i], lines[i+1], lines[i+2], lines[i+3]));
    }
    return list;
  }

  Widget getListElement(Plant plant)
  {
    return InkWell(
      onTap: () {_gotoInfo(plant);},
      child: Container(
        height: 130,
        width: double.infinity,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: plant.getPhoto(),
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plant.getSciName(),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic, color: Colors.black)),
                      SizedBox(height: 10),
                      Text(plant.getCommonName(), style: TextStyle(fontSize: 18)),
                    ],
                  ),
                )
            )
          ],
        )
      ),
    );
  }

  void _gotoInfo(Plant plant) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => MoreInfo(plant))
    );
  }
}

class MoreInfo extends StatelessWidget
{
  final Plant plant;
  MoreInfo(this.plant);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.getSciName()),
        backgroundColor: Colors.green,
      ),
      body: GestureDetector(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  child: plant.getPhoto()
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                        plant.getSciName(),
                        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.black),
                        textAlign: TextAlign.center),
                    SizedBox(height: 20),
                    Text(plant.getCommonName(), style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
                  ],
                ),
              )
            ],
          ),
          onVerticalDragUpdate: (details)
          {
            //print(details.delta.dy);
            if(details.delta.dy > 8) {Navigator.pop(context);}
          },
        )
    );
  }
}