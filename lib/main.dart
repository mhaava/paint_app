import 'package:flutter/material.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  Color lineColor = Colors.black;

  void _select(Choice choice) {
    setState(() {
      switch (choice.title) {
        case "white":
          lineColor = Colors.blueGrey[50];
        break;
        case "black":
          lineColor = Colors.black;
        break;
        case "blue":
          lineColor = Colors.blue;
        break;
        case "red":
          lineColor = Colors.red;
        break;
        case "green":
          lineColor = Colors.green;
        break;
        case "orange":
          lineColor = Colors.orange;
        break;
        case "pink":
          lineColor = Colors.pink;
          break;
      }
    });
  }
  List<Offset> points = <Offset>[];
  List<Color> colors = <Color>[];
  @override
  Widget build(BuildContext context) {
    final Container sketchArea = Container(
      margin: EdgeInsets.all(4.0),
      alignment: Alignment.topLeft,
      color: Colors.blueGrey[50],
      child: CustomPaint(
        painter: Sketcher(points, colors),
      ),

    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Sketcher'),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.power_input),
                tooltip: 'Undo',
                onPressed: () {
                  _select(choices[0]);
                },
            ),
            // overflow menu
            PopupMenuButton<Choice>(
              icon: new Icon(Icons.palette),
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.skip(1).map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
          ],
      ),
      body: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            RenderBox box = context.findRenderObject();
            Offset point = box.globalToLocal(details.globalPosition);
            point = point.translate(0.0, -(AppBar().preferredSize.height));

            points = List.from(points)..add(point);
            colors = List.from(colors)..add(lineColor);
          });
        },
        onPanEnd: (DragEndDetails details) {
          points.add(null);
        },
        child: sketchArea,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'clear screen',
        backgroundColor: Colors.red,
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() => points.clear());
        },
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'white'),
  const Choice(title: 'black'),
  const Choice(title: 'blue'),
  const Choice(title: 'red'),
  const Choice(title: 'green'),
  const Choice(title: 'orange'),
  const Choice(title: 'pink'),
];

class Sketcher extends CustomPainter {
  final List<Offset> points;
  final List<Color> colors;
  Sketcher(this.points, this.colors);
  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return oldDelegate.points != points;
  }
    void paint(Canvas canvas, Size size) {

    for (int i=0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        Paint paint = Paint()
          ..color = colors[i]
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 4.0;
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }

  }

}