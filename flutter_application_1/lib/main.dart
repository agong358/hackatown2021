import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class Recipe {
  final int id;
  final String image;
  final int likes;
  // final List<String> missedIngredients;
  final String title;

  Recipe({this.id, this.image, this.likes, this.title});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
        id: json['id'],
        image: json['image'],
        likes: json['likes'],
        // missedIngredients: json['missedIngredients'],
        title: json['title']);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green[200],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
                onPressed: () {
                  // searchRecipes();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyRecipes()));
                },
                color: Colors.green[200],
                child: Text('Generate Recipes',
                    style: TextStyle(color: Colors.white, fontSize: 16)))
          ],
        ),
      ),
    );
  }
}

Future<List<Recipe>> searchRecipes() async {
  // final response = await widget.dio.get('https://api.spoonacular.com/recipes/findByIngredients', queryParameters: { 'q' : query } );
  final response = await http.get(
      'https://api.spoonacular.com/recipes/findByIngredients?ingredients=chicken&number=15&apiKey=' +
          DotEnv().env['SPOONACULAR_API_KEY']);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var arr = json.decode(response.body) as List;
    return arr.map((e) => Recipe.fromJson(e)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load recipes');
  }
}

class MyRecipes extends StatefulWidget {
  // MyRecipes({Key key}) : super(key: key);

  // final dio = Dio(
  //   BaseOptions(
  //       baseUrl:
  // 'https://api.spoonacular.com/recipes/findByIngredients?ingredients=apples,+flour,+sugar&number=2&apiKey=' +
  //     DotEnv().env['SPOONACULAR_API_KEY']),
  // );

  @override
  _MyRecipesState createState() => _MyRecipesState();
}

class _MyRecipesState extends State<MyRecipes> {
  Future<List<Recipe>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = searchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        backgroundColor: Colors.blueGrey[600],
      ),
      backgroundColor: Colors.orange[300],
      body: Center(
        child: FutureBuilder<List<Recipe>>(
          future: futureRecipes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                      margin: EdgeInsets.all(10),
                      child: Column(children: <Widget>[
                        Text(
                          snapshot.data[index].title,
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(fontSizeFactor: 1.5),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.all(30),
                          child: Image.network(snapshot.data[index].image),
                        ),
                        Row(children: <Widget>[
                          Icon(
                            Icons.favorite,
                            color: Colors.pink,
                            size: 24.0,
                          ),
                          Text(snapshot.data[index].likes.toString()),
                        ]),
                      ]));
                },
              );
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
          // child: Card(
          //   child: InkWell(
          //     splashColor: Colors.blue.withAlpha(30),
          //     onTap: () {
          //       searchRecipes();
          //     },
          //     child: Container(
          //       width: 300,
          //       height: 100,
          //       child: Text('A card that can be tapped'),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
