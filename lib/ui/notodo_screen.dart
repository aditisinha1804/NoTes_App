import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:notodo_app/model/nodo_item.dart';
import 'package:notodo_app/newPAge.dart';
import 'package:notodo_app/util/database_client.dart';
import 'package:notodo_app/util/date_formattter.dart';
import 'package:share/share.dart';


class NotoDoScreen extends StatefulWidget {
  @override
  _NotoDoScreenState createState() => _NotoDoScreenState();
}
class _NotoDoScreenState extends State<NotoDoScreen> {
  final TextEditingController _textEditingController2 = new TextEditingController();
  final TextEditingController _textEditingController = new TextEditingController();
  var db = new DatabaseHelper();
  String text = '';

  final List<NoDoItem> _itemList = <NoDoItem>[];

  @override
  void initState() {
    super.initState();
    _readNoDoList();
  }

  void _handleSubmitted(String text, String adi) async {
    _textEditingController.clear();
    NoDoItem noDoItem = new NoDoItem(text, dateFormatted(), adi);
    int savedItemId = await db.saveItem(noDoItem);
    NoDoItem addedItem = await db.getItem(savedItemId);
    setState(() {
      _itemList.insert(0, addedItem);
    });
    print(" Item saved id: $savedItemId");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          new Flexible(
              child: new GridView.builder(
                  padding: new EdgeInsets.all(7.0),
                  gridDelegate:
                  new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: _itemList.length,
                  itemBuilder: (_, int index) {
                    {
                      return new GestureDetector(
                        child: Container(

                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: ExactAssetImage('images/nn.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),


                          child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 30, 0, 0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: new Text(
                                        "${_itemList[index].itemName}"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 50, 0, 0),
                                  child: Text("${_itemList[index].datecreated}",
                                    textAlign: TextAlign.left,),
                                ),

                                new Builder(
                                  builder: (BuildContext context) {
                                    return new IconButton(
                                      icon: Icon(Icons.share),
                                      onPressed: text.isEmpty
                                          ? null
                                          : () {
                                        final RenderBox box = context
                                            .findRenderObject();
                                        Share.share(text,
                                            sharePositionOrigin:
                                            box.localToGlobal(Offset.zero) &
                                            box.size);
                                      },
                                    );
                                  },
                                ),

                              ]),
                        ),


                        onTap:()=>
                            _deleteNoDo(_itemList[index].id, index)
                           

                      );
                    }
                  })),
          new Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          tooltip: "ADD ITEM",
          backgroundColor: Colors.red,
          child: new ListTile(
            title: Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(

      content: new Row(
        children: <Widget>[
          new Expanded(
              child: Column(
                children: <Widget>[
                  new TextField(
                      controller: _textEditingController,
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: "Add :",
                          hintText: "Jot down your thoughts......",
                          icon: new Icon(Icons.note_add)),
                      onChanged: (String value) =>
                          setState(() {
                            text = value;
                          })
                  ),
                ],
              ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSubmitted(
                  _textEditingController.text, _textEditingController2.text);
              _textEditingController.clear();
              _textEditingController2.clear();
              _textEditingController.clear();
            },
            child: Text("Save")
        ),
        new FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel")),

      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readNoDoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      NoDoItem noDoItem = NoDoItem.map(item);
      setState(() {
        _itemList.add(NoDoItem.map(item));
      });
      print("Db items: ${noDoItem.itemName}");
    });
  }

  _deleteNoDo(int id, int index) async {
    debugPrint("deleted item!");
    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateItem(NoDoItem item, int index) {
    var alert = new AlertDialog(
      title: new Text("Update"),
      content: new Row(
        children: <Widget>[
          new Expanded(child: new TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "item",

                hintText: "eg. Dont buy stuff",
                icon: new Icon(Icons.update)
            ),))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              NoDoItem newItemUpdated = NoDoItem.fromMap(
                  {"itemName": _textEditingController.text,
                    "dateCreated": dateFormatted(),
                    "data": item.nyadata,
                    "id": item.id
                  });
              _handleSubmittedUpdate(index, item);
              await db.updateItem(newItemUpdated);
              setState(() {
                _readNoDoList();
              });
              Navigator.pop(context);
            },
            child: new Text("update")),
        new FlatButton(
          onPressed: () => Navigator.pop(context),
          child: new Text("cancel"),),
      ],
    );
    showDialog(
        context: context, builder: (_) {
      return alert;
    });
  }

  void _handleSubmittedUpdate(int index, NoDoItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == item.itemName;
      });
    });
  }
}