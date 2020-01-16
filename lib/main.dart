import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url2pdf/apikey.dart' as apiKey;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.white),
      home: MyHomePage(title: 'URL2PDF'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  var downloading = false;
  var progressString = "Please Wait";
  var fileName = "";

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getPerm();
  }

  TextEditingController controllerURL = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerFilename = new TextEditingController();
  Future sendEmail() async {
    var endpoint = "https://api.html2pdf.app/v1/generate?";
    var urlf = controllerURL.text.toString().startsWith("http")
        ? controllerURL.text
        : "http://" + controllerURL.text;

    final response = await http.get(endpoint +
        "url=" +
        urlf +
        "&apiKey=" +
        apiKey.apikey +
        "&email=" +
        controllerEmail.text);

    print(response.body.toString());
    if (response.statusCode == 202) {
      Fluttertoast.showToast(
        msg: "Document sent to Email Successfuly",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Document not sent to Email.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();

    var endpoint = "https://api.html2pdf.app/v1/generate?";
    var urlf = controllerURL.text.toString().startsWith("http")
        ? controllerURL.text
        : "http://" + controllerURL.text;
    var urlPath = endpoint + "url=" + urlf + "&apiKey=" + apiKey.apikey;

    try {
      setState(() {
        widget.downloading = true;
      });
      var dir = await DownloadsPathProvider.downloadsDirectory;
      print(dir.path);
      var filname =
          controllerFilename.text == "" ? "url2pdf" : controllerFilename.text;
      await dio.download(urlPath, "${dir.path}/${filname}.pdf",
          onReceiveProgress: (recd, total) {
        print("Rec : $recd , Total : $total");
        // FlutterAndroidDownloader.download(urlPath, "/ABC", "${controllerFilename.text}.pdf");
        setState(() {
          widget.downloading = true;
          widget.progressString =
              ((recd / total) * 100).toStringAsFixed(0) + "%";
          // widget.progressString = (("recd/total") * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      widget.downloading = false;
      widget.progressString = "Completed";
      Fluttertoast.showToast(
        msg: "Document Downloaded. Check Downloads folder.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    });

    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final downloadingWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 120,
          width: 200,
          child: Card(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Downloading File : ${widget.progressString}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );

    final bodyWidget = SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 25.0,
              ),
              Text('URL2PDF', style: Theme.of(context).textTheme.display1),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: controllerURL,
                decoration:
                    InputDecoration(hintText: "URL", labelText: "Enter URL"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: controllerEmail,
                decoration: InputDecoration(
                    hintText: "Email ID", labelText: "Enter Email ID"),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: controllerFilename,
                decoration: InputDecoration(
                    hintText: "File Name", labelText: "Enter File Name"),
              ),
              RaisedButton(
                onPressed: () {
                  sendEmail();
                },
                child: Text("Send To Email"),
              ),
              RaisedButton(
                onPressed: () {
                  downloadFile();
                },
                child: Text("Download"),
              )
            ],
          ),
        ),
      ),
    );
    return Scaffold(body: widget.downloading ? downloadingWidget : bodyWidget);
  }
}

Future<void> getPerm() async {
  PermissionStatus permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
}
