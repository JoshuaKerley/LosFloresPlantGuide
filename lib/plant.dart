import 'package:flutter/material.dart';

class Plant
{
  String sciName;
  String commonName;
  String filename;
  late Widget photo;
  String color;
  String type;
  Plant(this.sciName, this.commonName, this.filename, this.color, this.type)
  {
    photo = Hero(
      tag: filename,
      child: Image.asset("assets/$filename", fit: BoxFit.fitWidth),
    );
  }

  String getSciName()
  {
    return sciName;
  }
  Widget getSciNameWidget(TextStyle style)
  {
    return Hero(
        tag: filename+"S",
        child: Text(
          sciName,
          style: style
        )
    );
  }

  String getCommonName()
  {
    return commonName;
  }
  Widget getCommonNameWidget(TextStyle style)
  {
    return Hero(
        tag: filename+"C",
        child: Text(
            commonName,
            style: style
        )
    );
  }

  String getFileName()
  {
    return filename;
  }

  Widget getPhoto()
  {
    return photo;
  }

  String getColor()
  {
    return color;
  }
}