import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future _abrirCaixa() async {  
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  return await Hive.openBox('minhaCaixa');
}

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Exemplo hive',
    home: FutureBuilder(
    future: _abrirCaixa(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.error != null) {
          return Scaffold(
            body: Center(
              child: Text('Algo deu errado :('),
            ),
          );
        } else {
          return MinhaPagina();
        }
      } else {
        return CircularProgressIndicator();
      }
    },
  ),
  );
}
}

class MinhaPagina extends StatefulWidget {
  @override
  _MinhaPaginaState createState() => _MinhaPaginaState();
}
class _MinhaPaginaState extends State<MinhaPagina> {
  Box _caixa;
  @override
  void initState() {
    _caixa = Hive.box('minhaCaixa');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplo hive'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Reinicie o aplicativo para testar'),
            SizedBox(height: 8),
            Text('You have pushed the button this many times:'),
            WatchBoxBuilder(
              box: _caixa,
              builder: (context, box) {
                return Text(
                  box.get('contador', defaultValue: 0).toString(),
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _caixa.put(
          'contador', 
          _caixa.get('contador', defaultValue: 0) + 1);
        },
        tooltip: 'Aumentar',
        child: Icon(Icons.add),
      ),);
}}