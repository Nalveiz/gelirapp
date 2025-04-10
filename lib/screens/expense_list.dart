import 'package:flutter/material.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/screens/add_expense.dart';
import 'package:provider/provider.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ExpenseListScreenState createState() => ExpenseListScreenState();
}

class ExpenseListScreenState extends State<ExpenseListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpenseScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          final transactions = transactionProvider.transactions;

          // Veriler henüz yüklenmediyse gösterilecek içerik
          if (transactions.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                title: Text(transaction.category),
                subtitle: Text('${transaction.description} - ${transaction.amount} TL'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Gideri sil
                    Provider.of<TransactionProvider>(
                      context,
                      listen: false,
                    ).deleteTransaction(transaction.id!);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
