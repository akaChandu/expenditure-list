import 'dart:io';

import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // this print is only for testing...
    print('Build() MyApp');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            subtitle2: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            button: const TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
          toolbarTextStyle: ThemeData.light()
              .textTheme
              .copyWith(
                subtitle2: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
              .bodyText2,
          titleTextStyle: ThemeData.light()
              .textTheme
              .copyWith(
                subtitle1: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
              .headline6,
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan)
            .copyWith(secondary: Colors.amber),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 'T1',
    //   title: 'New Shoes',
    //   amount: 45.99,
    //   time: DateTime.now(),
    // ),
    // Transaction(
    //   id: 'T2',
    //   title: 'New Chair',
    //   amount: 65.99,
    //   time: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.time.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      time: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        // return NewTransaction(_addNewTransaction);
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  // void _startAddNewTransactionWithFloatingDialogueBox(BuildContext ctx) {
  //   showDialog(
  //     context: ctx,
  //     builder: (_) {
  //         return AlertDialog(
  //           title: Text("Add Transaction"),
  //           content: NewTransaction(_addNewTransaction),
  //         );
  //     }
  //   );
  // }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
            activeColor: Colors.amber,
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {

    // this print is only for testing...
    print('Build() MyHomePage');
    final mediaQuery = MediaQuery.of(context);
    final islandscape = mediaQuery.orientation == Orientation.landscape;
    // final PreferredSizeWidget appbar = Platform.isIOS
    //     ? CupertinoNavigationBar(
    //         middle: const Text('Despesas Pessoais'),
    //         trailing: Row(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             GestureDetector(
    //               child: const Icon(CupertinoIcons.add),
    //               onTap: () => _startAddNewTransaction(context),
    //             )
    //           ],
    //         ),
    //       ) as PreferredSizeWidget
    //     : AppBar(
    //         title: const Text(
    //           'Despesas Pessoais',
    //         ),
    //         actions: [
    //           IconButton(
    //             icon: const Icon(Icons.add),
    //             onPressed: () => {
    //               _startAddNewTransaction(context),
    //             },
    //           ),
    //         ],
    //       );

    final dynamic appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              'Personal Expenses',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18.0,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            // centerTitle: true,
            title: const Text(
              'Personal Expenses',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18.0,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => {
                  _startAddNewTransaction(context),
                },
              ),
            ],
          );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (islandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
            if (!islandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            // navigationBar: appbar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => {
                      _startAddNewTransaction(context),
                    },
                  ),
          );
  }
}
