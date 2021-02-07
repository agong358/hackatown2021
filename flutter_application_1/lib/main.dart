//import 'dart:html';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: PantryScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/*----------------------------------------------------------------------------*/

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PantryScreen extends StatefulWidget {
  @override
  PantryScreenState createState() => PantryScreenState();
}

class PantryScreenState extends State<PantryScreen> {
  final items = CheckBoxListTileModel.getIngredient();

  List<CheckboxListTile> addIngredient = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.orange[300],
        appBar: AppBar(
          title: const Text('FoodPantry'),
          backgroundColor: Colors.blueGrey[600],
          elevation: 5,
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index].ingredientName;

            return Dismissible(
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              key: Key(item),
              // Provide a function that tells the app
              // what to do after an item has been swiped away.
              onDismissed: (direction) {
                // Remove the item from the data source.
                setState(() {
                  items.removeAt(index);
                });
              },
              // Show a red background as the item is swiped away.
              background: Container(
                color: Colors.red,
                margin: EdgeInsets.all(10),
              ),
              child: Card(
                  elevation: 5,
                  margin: EdgeInsets.all(5),
                  child: new CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.orange[300],
                      dense: true,
                      title: new Text(
                        items[index].ingredientName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: null,
                        ),
                      ),
                      subtitle: new Text(
                        items[index].date,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          height: null,
                        ),
                      ),
                      value: items[index].isCheck,
                      onChanged: (bool val) {
                        itemChange(val, index);
                      })),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blueGrey[600],
          onPressed: () {
            showDialog(
                context: context,
                child: new SimpleDialog(
                  title: new Text("Add Ingredient"),
                ));
          },
        ),
      ),
    );
  }

  void itemChange(bool val, int index) {
    setState(() {
      items[index].isCheck = val;
    });
  }
}

// class PantryScreenState extends State<PantryScreen> {
//   List<CheckBoxListTileModel> ingredientList =
//       CheckBoxListTileModel.getIngredient();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.orange[300],
//       appBar: AppBar(
//         title: const Text('FoodPantry'),
//         backgroundColor: Colors.blueGrey[600],
//         actions: <Widget>[
//           IconButton(
//               icon: const Icon(Icons.border_color),
//               tooltip: 'Edit',
//               color: Colors.orange,
//               onPressed: () {})
//         ],
//       ),
//       body: new ListView.builder(
//           itemCount: ingredientList.length,
//           itemBuilder: (BuildContext context, int index) {
//             return new Card(
//               child: new Container(
//                 height: 65,
//                 child: Column(
//                   children: <Widget>[
//                     new CheckboxListTile(
//                         controlAffinity: ListTileControlAffinity.leading,
//                         activeColor: Colors.orange[300],
//                         dense: true,
//                         title: new Text(
//                           ingredientList[index].ingredientName,
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             height: null,
//                           ),
//                         ),
//                         subtitle: new Text(
//                           ingredientList[index].date,
//                           style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                             height: null,
//                           ),
//                         ),
//                         value: ingredientList[index].isCheck,
//                         onChanged: (bool val) {
//                           itemChange(val, index);
//                         })
//                   ],
//                 ),
//               ),
//             );
//           }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Add your onPressed code here!
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.blueGrey[600],
//         elevation: 4,
//         mini: true,
//       ),
//     );
//   }

//   void itemChange(bool val, int index) {
//     setState(() {
//       ingredientList[index].isCheck = val;
//     });
//   }
// }

class CheckBoxListTileModel {
  String ingredientName;
  String date;
  bool isCheck;

  CheckBoxListTileModel({this.ingredientName, this.date, this.isCheck});

  static List<CheckBoxListTileModel> getIngredient() {
    return <CheckBoxListTileModel>[
      CheckBoxListTileModel(
        ingredientName: 'Milk',
        date: 'July 7 1999',
        isCheck: false,
      ),
      CheckBoxListTileModel(
        ingredientName: 'Ketchup',
        date: 'June 4 1999',
        isCheck: false,
      ),
      CheckBoxListTileModel(
        ingredientName: 'Panna Cotta',
        date: 'April 24 1999',
        isCheck: false,
      ),
      CheckBoxListTileModel(
        ingredientName: 'Opera',
        date: 'December 23 1998',
        isCheck: false,
      ),
      CheckBoxListTileModel(
        ingredientName: 'Milk',
        date: 'July 7 1999',
        isCheck: false,
      ),
      CheckBoxListTileModel(
        ingredientName: 'Ketchup',
        date: 'June 4 1999',
        isCheck: false,
      ),
      CheckBoxListTileModel(
        ingredientName: 'Panna Cotta',
        date: 'April 24 1999',
        isCheck: false,
      ),
      CheckBoxListTileModel(
        ingredientName: 'Opera',
        date: 'December 23 1998',
        isCheck: false,
      ),
    ];
  }
}
