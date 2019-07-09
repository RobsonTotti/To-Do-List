import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_de_compras/model/constants.dart';

final Firestore db = Firestore();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController controlItem = new TextEditingController();
  final TextEditingController controlUpdtItem = new TextEditingController();

  void adicionarItem() {
    //Consulta com condição
//    Firestore.instance
//        .collection('listas')
//        //.where("item", isEqualTo: "euxcnck")
//        .snapshots()
//        .listen((data) {
//      data.documents.forEach((doc) {
//        String item = doc["item"];
//        print(doc["item"]);
//      });
//    });


    var alert = AlertDialog(
      backgroundColor: Colors.black12,
      content: Column(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controlItem,
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
            //adicionar valores em subcoleções
            //Firestore.instance.collection('usuarios').document('5LllM3eh57a9Fnx5v8pD').collection('usuario').add({"teste": "123"});
            //Firestore.instance.collection('usuarios/5LllM3eh57a9Fnx5v8pD/usuario').add({"teste": "1234"});

            if (controlItem.text.isNotEmpty) {
              String item = controlItem.text;

              Firestore.instance
                  .collection('listas')
                  .add({'item': item, 'comprado': false});
              controlItem.clear();
            }
            Navigator.pop(context);
          },
          child: Text("Salvar"),
        ),
        FlatButton(
          onPressed: () {
            controlItem.clear();
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
  }

  void alterarItem(document, reference) {
    var alert = SimpleDialog(
      backgroundColor: Colors.black12,
      title: const Text(
        'O que deseja fazer?',
        style: TextStyle(color: Colors.white, fontSize: 30.0),
      ),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Atualizar',
            style: TextStyle(color: Colors.white, fontSize: 25.0),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
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

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    bool _comprado = document['comprado'];
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                document['item'],
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
                child: Checkbox(
              value: _comprado,
              onChanged: null,
              checkColor: Colors.white,
              activeColor: Colors.white,
            )
                //Text(document['comprado'].toString()),

                ),
          ],
        ),
      ),
      onTap: () {
        _comprado = document['comprado'];

        if (_comprado == false) {
          document.reference.updateData({'comprado': true});
        } else {
          document.reference.updateData({'comprado': false});
        }
      },
      onLongPress: () {
        //alterarItem();
        var alert = SimpleDialog(
          backgroundColor: Colors.black12,
          title: const Text(
            'O que deseja fazer?',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
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
                        if (controlItem.text.isNotEmpty) {
                          String item = controlItem.text;
                          document.reference.updateData({"item": item});

//                          Firestore.instance
//                              .collection('listas')
//                              .add({'item': item, 'comprado': false});
                          controlItem.clear();
                        }
                        Navigator.pop(context);
                      },
                      child: Text("Atualizar"),
                    ),
                    FlatButton(
                      onPressed: () {
                        controlItem.clear();
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(1000, 105, 105, 105),
      appBar: AppBar(
          backgroundColor: Color.fromARGB(1000, 54, 54, 54),
          title: Text("Lista de Compras"),
          actions: <Widget>[
            PopupMenuButton(
                onSelected: choiceAction,
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                })
          ]),
      body: StreamBuilder(
          stream: Firestore.instance.collection('listas').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                    key: UniqueKey(), backgroundColor: Colors.black),
              );
            return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    _buildListItem(context, snapshot.data.documents[index]));
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: adicionarItem,
        tooltip: 'Adicionar Item',
        child: Icon(Icons.add),
      ),
    );
  }
}

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
