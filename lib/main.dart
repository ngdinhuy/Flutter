import 'dart:ffi';

import 'package:demo_app/Coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:intl/intl.dart';
import 'NetworkRequest.dart';
import 'Message.dart';
import 'MessageDatabase.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SafeArea(
          child: Scaffold(
        body: MyHomePage(),
      )),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  String countryName = "";
  String as = "";//nhà mạng
  String ip = "";
  TextEditingController textController = TextEditingController();
  // List<Message> messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // messages = DBProvider.db.getAllMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 30),
                child: const Text(
                  "Nguyen Huu Thanh",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                )),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: const Text(
                "Class A13 K71",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: const Divider(
                color: Color.fromARGB(255, 209, 0, 33),
                thickness: 2,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    countryName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 13),
                  ),
                  Text(
                    as,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Text(
                ip,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0), fontSize: 13),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: ElevatedButton(
                onPressed: clickButtonUpdateInfo,
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 209, 0, 33),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                child: const Text(
                  "Update Info",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: const Divider(
                color: Color.fromARGB(255, 209, 0, 33),
                thickness: 2,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextFormField(
                decoration: const InputDecoration(
                    hintText: "Message",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 234, 234, 235),
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 10)),
                controller: textController,
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: ElevatedButton(
                onPressed: clickButtonSendMessage,
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 209, 0, 33),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                child: const Text(
                  "Send",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: const Divider(
                color: Color.fromARGB(255, 209, 0, 33),
                thickness: 2,
              ),
            ),
            FutureBuilder<List<Message>>(
              future: DBProvider.db.getAllMessage(),
              builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ItemMessage(snapshot.data![index], index);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          thickness: 1,
                          color: Color.fromARGB(100, 80, 77, 77),
                        );
                      },
                    ),
                  );
                } else {
                  return const Text("Empty data");
                }
              },

            )
          ],
        ),
      ),
    );
  }

  void clickButtonSendMessage() async {
    Message message =
        Message(time: getCurrentDateTime(), content: textController.text);
    await DBProvider.db.newMessage(message);
    setState(() {
    });
  }

  void clickButtonUpdateInfo() {
    NestworkRequest.getCoinApi().then((dataFromServer) => {
          setState(() {
            if (dataFromServer != null) {
              countryName = 'Country :${dataFromServer.country_name.toString()}';
              as = 'Network provider: ${dataFromServer.as}';
              ip = 'Ip: ${dataFromServer.ip}';
            }
          })
        });
  }

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(now);
    return formattedDate;
  }
}

class ItemMessage extends StatelessWidget {
  late Message message;
  late int position;

  ItemMessage(this.message, this.position, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(
              message.time,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          Container(
            width: double.infinity,
            child: Text(
              message.content,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}

// class MyWidget1 extends StatelessWidget {
//   const MyWidget1({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Bitcoin',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15),
//           ),
//           Text(
//             'Price 631111',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15),
//           ),
//           Text(
//             'Rate float',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TextWidgetBlackFont15 extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return StateTextWidgetBlackFont15();
//   }
// }

// class StateTextWidgetBlackFont15 extends State<TextWidgetBlackFont15> {
//   static const String text = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return const Text(
//       text,
//       textAlign: TextAlign.center,
//       style: TextStyle(
//         color: Color.fromARGB(255, 0, 0, 0),
//         fontSize: 15,
//       ),
//     );
//   }
// }
//
// class MyWidget extends StatelessWidget {
//   MyWidget();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       color: Colors.green,
//       child: const Text(
//         'Nguyen Huu Thanh',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: Color.fromARGB(255, 0, 0, 0),
//           fontSize: 20,
//         ),
//       ),
//     );
//   }
// }
//
// class MyWidget2 extends StatefulWidget {
//   bool? loading;
//
//   MyWidget2({this.loading});
//
//   @override
//   State<StatefulWidget> createState() {
//     return MyWidget2State();
//   }
// }
//
// class MyWidget2State extends State<MyWidget2> {
//   bool? localLoading;
//
//   @override
//   void initState() {
//     super.initState();
//     //chay truoc ham build
//     localLoading = widget.loading;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (localLoading == true) {
//       return const CircularProgressIndicator();
//     } else {
//       return FloatingActionButton(onPressed: onClickButton);
//     }
//   }
//
//   void onClickButton() {
//     print("Click button");
//     setState(() {
//       localLoading = true;
//     });
//   }
// }
