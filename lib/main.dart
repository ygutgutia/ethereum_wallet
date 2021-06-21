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
  double myAmount = 0;
  bool data = false;

  final myAddress = metamaskAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray300,
      body: ZStack([
        VxBox().blue400.size(context.screenWidth, context.percentHeight*30).make(),
        VStack([
          (context.percentHeight*10).heightBox,
          "Wallet".text.xl4.white.bold.makeCentered().py16(),
          (context.percentHeight*5).heightBox,
          VxBox(
            child: VStack([
              "Balance".text.gray700.xl2.semiBold.makeCentered(),
              20.heightBox,
              data ? "1".text.bold.xl6.makeCentered() : CircularProgressIndicator().centered()
          ])).p16.white.size(context.screenWidth, context.percentHeight*25).rounded.shadowXl.make().p16(),
          30.heightBox,

           Slider(
            value: myAmount,
            min: 0,
            max: 100,
            divisions: 100,
            label: myAmount.round().toString(),
            onChanged: (double value) {
              setState(() {
                myAmount = value;
              });
            },
          ),
          
          HStack(
            [
              ElevatedButton.icon(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: Vx.rounded
                ),
                icon: Icon(Icons.refresh, color: Colors.white),
                label: "Refresh".text.white.make()
              ).h(50),
              ElevatedButton.icon(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: Vx.rounded,
                ),
                icon: Icon(Icons.call_made_outlined, color: Colors.white),
                label: "Deposit".text.white.make()
              ).h(50),
              ElevatedButton.icon(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: Vx.rounded
                ),
                icon: Icon(Icons.call_received_outlined, color: Colors.white),
                label: "Withdraw".text.white.make()
              ).h(50)
            ],
            alignment: MainAxisAlignment.spaceAround,
            axisSize: MainAxisSize.max
          ).p16()
        ])
      ])
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
