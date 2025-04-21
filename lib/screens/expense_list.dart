import 'package:flutter/material.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/screens/add_expense.dart';
import 'package:myapp/screens/piechart.dart';
import 'package:myapp/screens/piechart_2.dart';
import 'package:myapp/utils/string_utils.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/screens/login_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreen();
}

class _ExpenseListScreen extends State<ExpenseListScreen> {
  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<TransactionProvider>().listenToTransactions(userId);
        }
      });
    }
  }

  Future<void> _logOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text(StringUtils.appName)),
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
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.grey[800]),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email?.split('@').first ??
                    'Guest',
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.black,
                child: Text(
                  FirebaseAuth.instance.currentUser?.email?.substring(0, 1) ??
                      'G',
                  style: const TextStyle(fontSize: 40.0, color: Colors.white),
                ),
              ),
              accountName: null,
            ),
            ListTile(title: const Text('Log Out'), onTap: _logOut),
          ],
        ),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          final transactions = transactionProvider.transactions;

          // Eğer liste boşsa
          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: Colors.grey, size: 50),
                  SizedBox(height: 10),
                  Text(
                    StringUtils.emptyData,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddExpenseScreen(),
                        ),
                      );
                    },
                    child: Text(StringUtils.addData),
                  ),
                ],
              ),
            );
          }

          double totalIncome = 0;
          double totalExpense = 0;

          for (var transaction in transactions) {
            if (transaction.type == 'Income') {
              totalIncome += transaction.amount; // Gelirler pozitif
            } else if (transaction.type == 'Expense') {
              totalExpense -= transaction.amount; // Giderler negatif
            }
          }

          double total = totalIncome + totalExpense;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  surfaceTintColor: total < 0 ? Colors.red : Colors.green,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IncomeExpensePieChart(
                    income: totalIncome,
                    expense: totalExpense,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return ListTile(
                      title: Text(transaction.category),
                      subtitle: Text(
                        '${transaction.description} - ${transaction.amount} TL',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          if (transaction.id == null) return;
                          context.read<TransactionProvider>().deleteTransaction(
                            transaction.id!,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${StringUtils.income} ${totalIncome.toStringAsFixed(2)} TL',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '${StringUtils.expense} ${totalExpense.toStringAsFixed(2)} TL',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Divider(),
                        SizedBox(height: 8.0),
                        Text(
                          'Total: ${total.toStringAsFixed(2)} TL',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: total >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
