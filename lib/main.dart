import 'package:blockchain_sample/personalDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blockchain Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Blockchain Wallet'),
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
  
  Client httpClient;
  Web3Client ethClient;

  final myAddress = metamaskAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray300,
      body: ZStack([
        VxBox().blue600.size(context.screenWidth, context.percentHeight*30).make(),
        VStack([
          (context.percentHeight*10).heightBox,
          "Wallet".text.xl4.white.bold.makeCentered().py16(),
          (context.percentHeight*5).heightBox,
          VxBox(
            child: VStack([
              "Balance".text.gray700.xl2.semiBold.makeCentered(),

          ])).p16.white.size(context.screenWidth, context.percentHeight*30).rounded.shadowXl.make().p16(),
        ])
      ])
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
