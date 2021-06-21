import 'package:blockchain_sample/personalDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int currAmount = 0;
  bool data = false;
  var myData;

  final myAddress = metamaskAddress;

  @override
  void initState(){
    httpClient = Client();
    ethClient = Web3Client(infuraurl, httpClient);
    getBalance(myAddress);
    super.initState();
  }


  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = contractAdd;
    final contract = DeployedContract(ContractAbi.fromJson(abi, contractName), EthereumAddress.fromHex(contractAddress));
    return contract;
  }


  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(contract: contract, function: ethFunction, params: args);
    return result;
  }


  Future<void> getBalance(String targetAddress) async {
    setState(() { data = false; });
    // EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query("getBalance", []);
    myData = result[0];
    setState(() { data = true; });
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(metaMaskPvtKey); //EthPrivateKey.createRandom(random)(rng)
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(credentials,
                        Transaction.callContract(contract: contract, function: ethFunction, parameters: args),
                        chainId: 4);
    return result;
  }

  Future<String> depositBalance(String targetAddress) async {
    var amnt = BigInt.from(currAmount);
    var response = await submit("depositBalance", [amnt]);
    getBalance(targetAddress);
    return response; // Not used but returns hashID
  }

  Future<String> withdrawBalance(String targetAddress) async {
    var amnt = BigInt.from(currAmount);
    var response = await submit("withdrawBalance", [amnt]);
    getBalance(targetAddress);
    return response;
  }


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
              data ? "\$$myData".text.bold.xl6.makeCentered().shimmer() : CircularProgressIndicator().centered()
          ])).p16.white.size(context.screenWidth, context.percentHeight*25).rounded.shadowXl.make().p16(),
          30.heightBox,

           Slider(
            value: currAmount.toDouble(),
            min: 0,
            max: 100,
            divisions: 100,
            label: currAmount.toString(),
            onChanged: (double value) {
              setState(() {
                currAmount = value.round();
              });
            },
          ),
          
          HStack(
            [
              ElevatedButton.icon(
                onPressed: () => getBalance(myAddress),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: Vx.rounded
                ),
                icon: Icon(Icons.refresh, color: Colors.white),
                label: "Refresh".text.white.make()
              ).h(50),
              ElevatedButton.icon(
                onPressed: () => depositBalance(myAddress),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: Vx.rounded,
                ),
                icon: Icon(Icons.call_made_outlined, color: Colors.white),
                label: "Deposit".text.white.make()
              ).h(50),
              ElevatedButton.icon(
                onPressed: () => withdrawBalance(myAddress),
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