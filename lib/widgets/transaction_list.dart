import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';
import '../main.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {

    // this print is only for testing...
    print('Build() TransactionList');
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  Text(
                    'No transaction added yet!!',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TransactionItem(
                transaction: transactions[index],
                deleteTx: deleteTx,
              );
            },
            itemCount: transactions.length,
          );
  }
}
