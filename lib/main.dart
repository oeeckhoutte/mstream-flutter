import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'player_widget.dart';
import 'package:path/path.dart' as path;

typedef void OnError(Exception exception);

const kUrl1 = 'http://www.rxlabz.com/labz/audio.mp3';
const kUrl2 = 'http://www.rxlabz.com/labz/audio2.mp3';
String  actionText = "Default";

var queueList = [];
var serverList = [];
var currentServer = {
  'url': 'https://demo.mstream.io/',
  'username': '',
  'jwt': '',
  'password': ''
};

void main() {
  runApp(new MaterialApp(home: new ExampleApp()));
}

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => new _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  AudioCache audioCache = new AudioCache();
  AudioPlayer advancedPlayer = new AudioPlayer();
  String localFilePath;
  List displayList = new List();

  Future _loadFile() async {
    final bytes = await http.readBytes(kUrl1);
    final dir = await getApplicationDocumentsDirectory();
    final file = new File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      setState(() {
        localFilePath = file.path;
      });
    }
  }

  Widget _tab(List<Widget> children) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(0.0),
        child: Column(
          children: children
              .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
              .toList(),
        ),
      ),
    );
  }

  Widget _btn(String txt, VoidCallback onPressed) {
    return ButtonTheme(
        minWidth: 48.0,
        child: RaisedButton(child: Text(txt), onPressed: onPressed));
  }

  // Loal File Screen
  Widget localFile() {
    return new Column(children: <Widget>[
      new Row(children: <Widget>[
        new IconButton(icon: Icon(Icons.arrow_back), tooltip: 'Go Back', onPressed: () {
          print('BACK');
        }),
        Expanded(child: TextField(decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search'
        )))
      ]),
      Expanded(
        child: SizedBox(
          child: new ListView.builder( // LOL Holy Shit: https://stackoverflow.com/questions/52801201/flutter-renderbox-was-not-laid-out
            physics: const AlwaysScrollableScrollPhysics (),
            itemCount: displayList.length,
            itemBuilder: (BuildContext context, int index) {
              print('XXX');
              print(displayList[index]);
              return new ListTile(
                title: Text(displayList[index]['name'].toString()),
                onTap: () {
                  print(displayList[index]['directory']);
                  if(displayList[index]['type'] == 'directory') {
                    getFileList(displayList[index]['directory']);
                  }
                },
              );
            }
          )
        )
      )
    ]);
  }

  Future<void> getFileList(String directory) async {
    var url = "https://demo.mstream.io/dirparser";
    var response = await http.post(url, body: {"dir": directory});
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    var res = jsonDecode(response.body);
    print(res['contents']);
    displayList.clear();
    res['contents'].forEach((e) {
      print(e);
      setState(() {
        displayList.add({
          'type': e['type'],
          'name': e['name'],
          'directory': path.join(res['path'], e['name'])
        });
      });
    });
  }

  // Advanced Screen
  Widget advanced() {
    return _tab([
      Column(children: [
        Text('Source Url'),
        Row(children: [
          _btn('Audio 1', () => advancedPlayer.setUrl(kUrl1)),
          _btn('Audio 2', () => advancedPlayer.setUrl(kUrl2)),
        ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
      ]),
      Column(children: [
        Text('Release Mode'),
        Row(children: [
          _btn('STOP', () => advancedPlayer.setReleaseMode(ReleaseMode.STOP)),
          _btn('LOOP', () => advancedPlayer.setReleaseMode(ReleaseMode.LOOP)),
          _btn('RELEASE',
              () => advancedPlayer.setReleaseMode(ReleaseMode.RELEASE)),
        ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
      ]),
      new Column(children: [
        Text('Volume'),
        Row(children: [
          _btn('0.0', () => advancedPlayer.setVolume(0.0)),
          _btn('0.5', () => advancedPlayer.setVolume(0.5)),
          _btn('1.0', () => advancedPlayer.setVolume(1.0)),
          _btn('2.0', () => advancedPlayer.setVolume(2.0)),
        ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
      ]),
      new Column(children: [
        Text('Control'),
        Row(children: [
          _btn('resume', () => advancedPlayer.resume()),
          _btn('pause', () => advancedPlayer.pause()),
          _btn('stop', () => advancedPlayer.stop()),
          _btn('release', () => advancedPlayer.release()),
        ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
      ]),
      // End of Advanced Player

      // // Other Examples
      // Text('Play Local Asset \'audio.mp3\':'),
      // _btn('Play', () => audioCache.play('audio.mp3')),
      // Text('File: $kUrl1'),
      // _btn('Download File to your Device', () => _loadFile()),
      // // Text('Current local file path: $localFilePath'),
      // localFilePath == null
      //     ? Container()
      //     : PlayerWidget(url: localFilePath, isLocal: true),
    ]);
  }

  @override
  void initState() {
    getFileList("");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Local File'),
              Tab(text: 'Now Playing'),
            ],
          ),
          title: Text('mStream'),
          actions: <Widget> [
            new IconButton (
              icon: new Icon(Icons.add_comment),
              onPressed: (){
                setState(() {
                  actionText = "New Text";
                });
              }
            ),
            new IconButton (
              icon: new Icon(Icons.remove),
              onPressed: (){
                setState(() {
                  actionText = "Default";
                });
              }
            ),
          ]
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget> [
              new DrawerHeader(child: new Text('Header'),),
              new ListTile(
                title: new Text('File Explorer'),
                onTap: () {
                  getFileList("");
                  Navigator.of(context).pop();
                },
              ),
              new ListTile(
                title: new Text('Playlists'),
                onTap: () {},
              ),
              new ListTile(
                title: new Text('Albums'),
                onTap: () {},
              ),
              new ListTile(
                title: new Text('Artists'),
                onTap: () {},
              ),
              new Divider(),
              new ListTile(
                title: new Text('About'),
                onTap: () {},
              ),
            ],
          )
        ),
        body: TabBarView(
          children: [localFile(), advanced()],
        ),
      ),
    );
  }
}
