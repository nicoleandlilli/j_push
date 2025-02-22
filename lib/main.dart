import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const JPushPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class JPushPage extends StatefulWidget {
  const JPushPage({super.key, required this.title});

  final String title;

  @override
  State<JPushPage> createState() => _JPushPageState();
}

class _JPushPageState extends State<JPushPage> {
  String? debugLable = 'Unknown';
  final JPush jpush = new JPush();

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
            print("flutter onReceiveNotification: $message");
            setState(() {
              debugLable = "flutter onReceiveNotification: $message";
            });
          }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        setState(() {
          debugLable = "flutter onOpenNotification: $message";
        });
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
        setState(() {
          debugLable = "flutter onReceiveMessage: $message";
        });
      }, onReceiveNotificationAuthorization:
          (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
        setState(() {
          debugLable = "flutter onReceiveNotificationAuthorization: $message";
        });
      }, onNotifyMessageUnShow: (Map<String, dynamic> message) async {
        print("flutter onNotifyMessageUnShow: $message");
        setState(() {
          debugLable = "flutter onNotifyMessageUnShow: $message";
        });
      }, onInAppMessageShow: (Map<String, dynamic> message) async {
        print("flutter onInAppMessageShow: $message");
        setState(() {
          debugLable = "flutter onInAppMessageShow: $message";
        });
      }, onCommandResult: (Map<String, dynamic> message) async {
        print("flutter onCommandResult: $message");
        setState(() {
          debugLable = "flutter onCommandResult: $message";
        });
      }, onInAppMessageClick: (Map<String, dynamic> message) async {
        print("flutter onInAppMessageClick: $message");
        setState(() {
          debugLable = "flutter onInAppMessageClick: $message";
        });
      }, onConnected: (Map<String, dynamic> message) async {
        print("flutter onConnected: $message");
        setState(() {
          debugLable = "flutter onConnected: $message";
        });
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setAuth(enable: true);
    jpush.setup(
      appKey: "xxxxx", //你自己应用的 AppKey
      channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
      });
    });

    // iOS要是使用应用内消息，请在页面进入离开的时候配置pageEnterTo 和  pageLeave 函数，参数为页面名。
    jpush.pageEnterTo("HomePage"); // 在离开页面的时候请调用 jpush.pageLeave("HomePage");

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

// 编写视图
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('JPush app'),
        ),

        body: new Center(
            child: new Column(children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                color: Colors.brown,
                child: Text(debugLable ?? "Unknown"),
                width: 350,
                height: 100,
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(" "),
                    new CustomButton(
                        title: "发本地推送",
                        onPressed: () {
                          // 三秒后出发本地推送
                          var fireDate = DateTime.fromMillisecondsSinceEpoch(
                              DateTime.now().millisecondsSinceEpoch + 3000);
                          var localNotification = LocalNotification(
                              id: 234,
                              title: 'fadsfa',
                              buildId: 1,
                              content: 'fdas',
                              fireTime: fireDate,
                              subtitle: 'fasf',
                              badge: 5,
                              extra: {"fa": "0"});
                          jpush
                              .sendLocalNotification(localNotification)
                              .then((res) {
                            setState(() {
                              debugLable = res;
                            });
                          });
                        }),
                    new Text(" "),
                    new CustomButton(
                        title: "getLaunchAppNotification",
                        onPressed: () {
                          jpush.getLaunchAppNotification().then((map) {
                            print("flutter getLaunchAppNotification:$map");
                            setState(() {
                              debugLable = "getLaunchAppNotification success: $map";
                            });
                          }).catchError((error) {
                            setState(() {
                              debugLable = "getLaunchAppNotification error: $error";
                            });
                          });
                        }),
                  ]),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(" "),
                    new CustomButton(
                        title: "setTags",
                        onPressed: () {
                          jpush.setTags(["lala", "haha"]).then((map) {
                            var tags = map['tags'];
                            setState(() {
                              debugLable = "set tags success: $map $tags";
                            });
                          }).catchError((error) {
                            setState(() {
                              debugLable = "set tags error: $error";
                            });
                          });
                        }),
                    new Text(" "),
                    new CustomButton(
                        title: "addTags",
                        onPressed: () {
                          jpush.addTags(["lala", "haha"]).then((map) {
                            var tags = map['tags'];
                            setState(() {
                              debugLable = "addTags success: $map $tags";
                            });
                          }).catchError((error) {
                            setState(() {
                              debugLable = "addTags error: $error";
                            });
                          });
                        }),
                    new Text(" "),
                    new CustomButton(
                        title: "deleteTags",
                        onPressed: () {
                          jpush.deleteTags(["lala", "haha"]).then((map) {
                            var tags = map['tags'];
                            setState(() {
                              debugLable = "deleteTags success: $map $tags";
                            });
                          }).catchError((error) {
                            setState(() {
                              debugLable = "deleteTags error: $error";
                            });
                          });
                        }),
                  ]),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(" "),
                    new CustomButton(
                        title: "getAllTags",
                        onPressed: () {
                          jpush.getAllTags().then((map) {
                            setState(() {
                              debugLable = "getAllTags success: $map";
                            });
                          }).catchError((error) {
                            setState(() {
                              debugLable = "getAllTags error: $error";
                            });
                          });
                        }),
                    new Text(" "),
                    new CustomButton(
                        title: "cleanTags",
                        onPressed: () {
                          jpush.cleanTags().then((map) {
                            var tags = map['tags'];
                            setState(() {
                              debugLable = "cleanTags success: $map $tags";
                            });
                          }).catchError((error) {
                            setState(() {
                              debugLable = "cleanTags error: $error";
                            });
                          });
                        }),
                  ]),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(" "),
                    new CustomButton(
                        title: "setAlias",
                        onPressed: () {
                          jpush.setAlias("thealias11").then((map) {
                            setState(() {
                              debugLable = "setAlias success: $map";
                            });
                          }).catchError((error) {
                            setState(() {
                              debugLable = "setAlias error: $error";
                            });
                          });
                        }),
                    new Text(" "),
                    new CustomButton(
                        title: "deleteAlias",
                        onPressed: () {
                          jpush.deleteAlias().then((map) {
                            setState(() {
                              debugLable = "deleteAlias success: $map";
                            });
                          }).catchError((error) {
                            setState(() {
                              debugLable = "deleteAlias error: $error";
                            });
                          });
                        }),
                    new Text(" "),
                    new CustomButton(
                        title: "getAlias",
                        onPressed: () {
                          jpush.getAlias().then((map) {
                            setState(() {
                              debugLable = "getAlias success: $map";
                            });
                          }).catchError((error) {
                            setState(() {
                              debugLable = "getAlias error: $error";
                            });
                          });
                        }),
                  ]),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(" "),
                  new CustomButton(
                      title: "stopPush",
                      onPressed: () {
                        jpush.stopPush();
                      }),
                  new Text(" "),
                  new CustomButton(
                      title: "resumePush",
                      onPressed: () {
                        jpush.resumePush();
                      }),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(" "),
                  new CustomButton(
                      title: "clearAllNotifications",
                      onPressed: () {
                        jpush.clearAllNotifications();
                      }),
                  new Text(" "),
                  new CustomButton(
                      title: "setBadge",
                      onPressed: () {
                        jpush.setBadge(66).then((map) {
                          setState(() {
                            debugLable = "setBadge success: $map";
                          });
                        }).catchError((error) {
                          setState(() {
                            debugLable = "setBadge error: $error";
                          });
                        });
                      }),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(" "),
                  new CustomButton(
                      title: "通知授权是否打开",
                      onPressed: () {
                        jpush.isNotificationEnabled().then((bool value) {
                          setState(() {
                            debugLable = "通知授权是否打开: $value";
                          });
                        }).catchError((onError) {
                          setState(() {
                            debugLable = "通知授权是否打开: ${onError.toString()}";
                          });
                        });
                      }),
                  new Text(" "),
                  new CustomButton(
                      title: "打开系统设置",
                      onPressed: () {
                        jpush.openSettingsForNotification();
                      }),
                ],
              ),
            ])),
      ),
    );
  }
}


/// 封装控件
class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? title;

  const CustomButton({@required this.onPressed, @required this.title});

  @override
  Widget build(BuildContext context) {
    return new TextButton(
      onPressed: onPressed,
      child: new Text("$title"),
      style: new ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        overlayColor: MaterialStateProperty.all(Color(0xff888888)),
        backgroundColor: MaterialStateProperty.all(Color(0xff585858)),
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(10, 5, 10, 5)),
      ),
    );
  }
}