import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_compras/model/constants.dart';

final Firestore db = Firestore();
//
final TextEditingController controlItem = new TextEditingController();
final TextEditingController controlUpdtItem = new TextEditingController();
//
void choiceAction(String choice) {
  if (choice == Constants.removerTudo) {
    //deletar tudo
    var results = db.collection('listas');
    results.getDocuments().then((query){
      query.documents.forEach((doc){
        doc.reference.delete();
      });
    });
  }
}
//
onLongPressLista(document, context){
  var alert = SimpleDialog(
    backgroundColor: Colors.black12,
    title: const Text(
      'O que deseja fazer?',
      style: TextStyle(color: Colors.white, fontSize: 30.0),
    ),
    children: <Widget>[
      SimpleDialogOption(
        onPressed: () {
          atualizarItem(document, context);
          Navigator.pop(context);
        },
        child: const Text(
          'Atualizar',
          style: TextStyle(color: Colors.white, fontSize: 25.0),
        ),
      ),
      SimpleDialogOption(
        onPressed: () {
          document.reference.delete();
          Navigator.pop(context);
        },
        child: const Text(
          'deletar',
          style: TextStyle(color: Colors.white, fontSize: 25.0),
        ),
      ),
    ],
  );
  showDialog(
      context: context,
      builder: (_) {
        return alert;
      });
}

atualizarItem(document, context){
  var alert = AlertDialog(
    backgroundColor: Colors.black12,
    content: Column(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: controlUpdtItem,
            autofocus: true,
            decoration: InputDecoration(
                labelText: 'Item',
                //fillColor: Colors.white,
                //filled: true,
                //hintText: 'item',
                icon: Icon(Icons.title)),
            style: new TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          if (controlUpdtItem.text.isNotEmpty) {
            String item = controlUpdtItem.text;
            document.reference.updateData({"item": item});

//                          Firestore.instance
//                              .collection('listas')
//                              .add({'item': item, 'comprado': false});
            controlUpdtItem.clear();
          }
          Navigator.pop(context);
        },
        child: Text("Atualizar"),
      ),
      FlatButton(
        onPressed: () {
          controlUpdtItem.clear();
          Navigator.pop(context);
        },
        child: Text("Cancelar"),
      )
    ],
  );
  showDialog(
      context: context,
      builder: (_) {
        return alert;
      });

  Navigator.pop(context);
}