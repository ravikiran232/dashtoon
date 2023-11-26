import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_card/image_card.dart';
import 'apirequest.dart';
import 'image_card.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  HttpClient client = newUniversalHttpClient();
  List<TextEditingController> textcontrollers =
      List.generate(10, (index) => TextEditingController());
  List imagecontrollers = List.generate(10, (index) => null);
  List imageduplicates = List.generate(10, (index) => null);
  List loading = List.generate(10, (index) => false);

  void dispose() {
    client.close();
    for (int i = 0; i < 10; i++) {
      textcontrollers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double heig = MediaQuery.of(context).size.height;
    int gridcount = 0;
    if (wid > 1300) {
      gridcount = 4;
    } else if (900 < wid && wid <= 1300) {
      gridcount = 3;
    } else if (600 < wid && wid <= 900) {
      gridcount = 2;
    } else {
      gridcount = 1;
    }
    return Builder(
        builder: (context) => Scaffold(
              // backgroundColor: Color(0xFFDDEFFF),
              backgroundColor: Color.fromRGBO(35, 45, 63, 1),
              appBar: AppBar(
                actions: [
                  TextButton(
                      onPressed: () => popupdialog(context, wid, heig),
                      child: const Row(
                        children: [
                          Text(
                            "prompts",
                            style: TextStyle(
                                color: Color.fromRGBO(221, 219, 203, 1)),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Icon(
                            Icons.edit,
                            color: Color.fromRGBO(221, 219, 203, 1),
                          )
                        ],
                      )),
                  gridcount >= 2
                      ? const SizedBox(
                          width: 10,
                        )
                      : const SizedBox.shrink(),
                  gridcount >= 2
                      ? TextButton(
                          onPressed: () {
                            launchUrl(Uri.parse(
                                "https://firebasestorage.googleapis.com/v0/b/flutter-surveys.appspot.com/o/app-release.apk?alt=media&token=c199d371-068b-427a-b231-803262032509"));
                          },
                          child: const Text(
                            "Download App",
                            style: TextStyle(
                                color: Color.fromRGBO(221, 219, 203, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ))
                      : const SizedBox.shrink(),
                  const SizedBox(
                    width: 10,
                  )
                ],
                backgroundColor: const Color.fromRGBO(0, 128, 128, 1),
                title: const Text(
                  "Cartoons Generator",
                  style: TextStyle(color: Color.fromRGBO(221, 219, 203, 1)),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: wid * 0.05, vertical: heig * 0.05),
                child: GridView.count(
                  crossAxisCount: gridcount,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: wid / gridcount / 380,
                  children: List.generate(10, (index) {
                    return
                        // Stack(children: [
                        FillImageCard(
                      isloading: loading[index],
                      color: const Color.fromRGBO(35, 45, 63, 1),
                      imageProvider: imagecontrollers[index] != null
                          ? Image.memory(
                              imagecontrollers[index],
                              height: 256,
                              width: 256,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "images/empty.jpeg",
                              width: 256,
                              height: 256,
                              fit: BoxFit.cover,
                            ),
                      title: SizedBox(
                        width: 256,
                        height: 50,
                        child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            onSubmitted: (value) => imageSubmit(index),
                            controller: textcontrollers[index],
                            autocorrect: false,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffix: loading[index]
                                  ? const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: CircularProgressIndicator(
                                        color: Color.fromRGBO(0, 128, 128, 1),
                                        strokeWidth: 3,
                                      ))
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        imageSubmit(index);
                                      },
                                    ),
                              labelText: "Enter your prompt here",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2),
                              ),
                            )),
                      ),
                    );
                  }),
                ),
              ),
            ));
  }

  imageSubmit(int index) {
    if (textcontrollers[index].text != "") {
      setState(() {
        loading[index] = true;
      });
      apirequest(client, textcontrollers[index].text).then((value) {
        setState(() {
          imagecontrollers[index] = value;
          loading[index] = false;
        });
      });
    } else {
      Fluttertoast.showToast(
          timeInSecForIosWeb: 3,
          webBgColor: "#b22222",
          msg: "prompt can't be empty",
          backgroundColor: Colors.red[300]);
    }
  }

  popupdialog(BuildContext ct, double width, double height) {
    return showDialog(
        context: ct,
        builder: (ct) => AlertDialog(
              backgroundColor: const Color.fromRGBO(35, 45, 63, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: IconButton(
                  onPressed: () => Navigator.pop(ct),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  )),
              content: Container(
                width: width * 0.7,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(11, (index) {
                        if (index < 10) {
                          return inputbox(textcontrollers[index]);
                        } else {
                          return ElevatedButton(
                            onPressed: () {
                              for (int i = 0; i < 10; i++) {
                                if (textcontrollers[i].text != "") {
                                  setState(() {
                                    loading[i] = true;
                                  });
                                  apirequest(client, textcontrollers[i].text)
                                      .then((value) {
                                    setState(() {
                                      imagecontrollers[i] = value;
                                      loading[i] = false;
                                    });
                                  });
                                }
                              }
                              Navigator.pop(ct);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(0, 128, 128, 1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Generate"),
                          );
                        }
                      })),
                ),
              ),
            ));
  }

  Widget inputbox(TextEditingController ctrl) {
    return Column(children: [
      TextField(
          controller: ctrl,
          autocorrect: false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Enter your prompt here",
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
          )),
      const SizedBox(
        height: 10,
      ),
    ]);
  }
}
