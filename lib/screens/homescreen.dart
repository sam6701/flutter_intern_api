import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api/models/data.dart';
import 'package:hexcolor/hexcolor.dart';
//import 'package:webview_flutter/webview_flutter.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class TransictionScreen extends StatefulWidget {
  const TransictionScreen({super.key});

  @override
  State<TransictionScreen> createState() => _TransictionScreenState();
}

class _TransictionScreenState extends State<TransictionScreen> {
  List<Welcome> users = [];
  //List<dynamic> v = [];
  List<Welcome> apiuser = [];
  List<List<Welcome>> us = [];
  List<Vin> vi = [];
  //List<Vout> vo = [];
  //String lastseen = "";
  var url = '';
  int curp = 1;
  int itemsPerPage = 10;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetuser();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has reached the end of the list
      fetchMoreData();
    }
  }

  void fetchMoreData() async {
    setState(() {
      isLoading = true;
      // curp++;
      //fetuser();
    });
    await Future.delayed(const Duration(seconds: 1));
    await apiModify();
  }

  Future<void> apiModify() async {
    var u =
        "https://mempool.space/testnet/api/address/tb1qv2rlpsge5zx7jdkyt3wcpjrlqkzkxawhg9z9f3/txs";

    if (users.isNotEmpty) {
      u += "/chain/${users.last.txid}";
    }

    final uriapi = Uri.parse(u);
    final response = await http.get(uriapi);
    final bodyapi = response.body;
    final resdatapi = json.decode(bodyapi);
    final respapi = welcomeFromJson(bodyapi);
    apiuser = respapi;
    setState(() {
      if (users.isNotEmpty) {
        // Exclude the last user as it will be duplicated
        apiuser = respapi.sublist(0);
      } else {
        apiuser = respapi;
      }
      users.addAll(apiuser);
      print("hello");
      isLoading = false;
    });
  }

  Future<void> openAppWebView(String appurl) async {
    if (!await launchUrl(Uri.parse(appurl), mode: LaunchMode.inAppWebView)) {
      throw Exception("could not launch $appurl");
    }
  }

  Widget _buildTransactionRow(
      {required IconData icon,
      required String address,
      required String amount,
      required Color color,
      required Color textcolor}) {
    String shortAddress =
        address.length >= 10 ? address.substring(0, 10) : address;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /*Icon(icon, color: color),
        SizedBox(width: 8),*/
        SizedBox(
          height: 20, //MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                '$shortAddress...',
                style: TextStyle(
                  color: textcolor,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    /*String lastseen =
        "https://mempool.space/testnet/api/address/tb1qv2rlpsge5zx7jdkyt3wcpjrlqkzkxawhg9z9f3/txs/chain/users[users.length-1].txid";
    setState(() {
      url = lastseen;
    });*/
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 9, 16),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'API INTEGRATION',
          style: TextStyle(color: Colors.white),
        ),
      ),
      //floatingActionButton: FloatingActionButton(onPressed: fetuser),

      body: ListView.builder(
        controller: _scrollController,
        itemCount: users.length + 1,
        itemBuilder: (context, index) {
          if (index == users.length) {
            // Show loading indicator
            return isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)))
                : const SizedBox(); // Return an empty SizedBox if not loading
          }
          final user = users[index];
          final tx = user.txid;
          final a = users[index].weight;
          int t = user.locktime;
          int v = user.vin.length;
          int vo = user.vout.length;
          bool condition = user.status.confirmed;
          int ufee = user.fee;
          double uweight = (user.weight) / 4;
          double vb = ufee / uweight;
          String rvb = vb.toStringAsFixed(2);
          //print(lastseen);
          int vintotal = 0;
          int vouttotal = 0;
          //int ta = 0;
          //final vu = v[0].txid;
          String txshort = tx.length >= 10 ? tx.substring(0, 10) : tx;
          for (var vin in user.vin) {
            vintotal += vin.prevout.value;
          }

          // Calculate vouttotal
          for (var vou in user.vout) {
            vouttotal += vou.value;
          }

          // Calculate ta
          final ta = (vouttotal - vintotal) / 100000000;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              // height: 300,
              width: MediaQuery.of(context).size.width * 1,
              color: HexColor("#1D1F31"),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () {
                        String appu = "https://mempool.space/testnet/tx";
                        appu += "/${tx}";
                        openAppWebView(appu);
                        print("YO");
                      },
                      child: Text(
                        '$txshort....',
                        style: TextStyle(
                          color: HexColor('#1bd8f4'),
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      Container(
                        width: double.infinity,
                        color: const Color.fromARGB(255, 1, 9, 16),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: v,
                          itemBuilder: (context, vinIndex) {
                            final Vin vin = user.vin[vinIndex];
                            //vintotal = vintotal + vin.prevout.value;
                            return _buildTransactionRow(
                              icon: Icons.arrow_circle_right_outlined,
                              address: vin.prevout.scriptpubkeyAddress,
                              amount: '${vin.prevout.value / 100000000} BTC',
                              color: Colors.red,
                              textcolor: HexColor('#1bd8f4'),
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      Container(
                        width: double.infinity,
                        color: const Color.fromARGB(255, 1, 9, 16),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vo,
                          itemBuilder: (context, voutIndex) {
                            final Vout vou = user.vout[voutIndex];
                            //vouttotal = vouttotal + vou.value;
                            return _buildTransactionRow(
                              icon: Icons.arrow_circle_right_outlined,
                              address: vou.scriptpubkeyAddress,
                              amount: '${vou.value / 100000000} BTC',
                              color: Colors.green,
                              textcolor: HexColor('#1bd8f4'),
                            );
                          },
                        ),
                      ),
                    ]),
                  ),

                  // Fee Information
                  const SizedBox(
                    width: double.infinity,
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '$rvb sat/vB – ${ufee} sat',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            /*Text(
                                '\$0.0',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                ),
                              ),*/
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle confirmation button press
                              },
                              style: condition
                                  ? ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            1), // Adjust the radius to make it a square
                                      ),
                                      minimumSize: const Size(30, 25),
                                    )
                                  : ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            1), // Adjust the radius to make it a square
                                      ),
                                      minimumSize: const Size(30, 25),
                                    ),
                              child: Text(
                                condition ? 'Conformations' : 'Unconform',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                            // ta=((vintotal-vouttotal)/100000000);

                            ElevatedButton(
                              onPressed: () {
                                // Handle confirmation button press
                              },
                              style: ta >= 0
                                  ? ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            1), // Adjust the radius to make it a square
                                      ),
                                      minimumSize: const Size(30, 25),
                                    )
                                  : ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            1), // Adjust the radius to make it a square
                                      ),
                                      minimumSize: const Size(30, 25),
                                    ),
                              child: Text(
                                '${ta}BTC',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void fetuser() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    var url =
        'https://mempool.space/testnet/api/address/tb1qv2rlpsge5zx7jdkyt3wcpjrlqkzkxawhg9z9f3/txs';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final resdata = json.decode(response.body);
    final resp = welcomeFromJson(response.body);
    setState(() {
      users = resp;
      isLoading = false;
    });
  }
}
