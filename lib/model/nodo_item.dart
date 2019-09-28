import 'package:flutter/material.dart';

class NoDoItem extends StatelessWidget {
  String _itemName;
  String _dateCreated;
  int _id;
  String _data;

  NoDoItem(this._itemName,this._dateCreated,this._data);
  NoDoItem.map(dynamic obj){
    this._itemName = obj["itemName"];
    this._data= obj["data"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }
  String get itemName => _itemName;
  String get nyadata => _data;
  String get datecreated => _dateCreated;
  int get id=> _id;
  Map<String,dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map["itemName"]= _itemName;
    map["data"]=_data;
    map["dateCreated"]= _dateCreated;
    if(_id != null){
      map["id"]= _id;
    }
  return map;
  }
    NoDoItem.fromMap (Map<String,dynamic> map){
      this._itemName = map["itemName"];
      this._data=map["data"];
      this._dateCreated = map["dateCreated"];
      this._id= map["id"];
     }
  @override
  Widget build(BuildContext context) {
    return Container();

  }
}
