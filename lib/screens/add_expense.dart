import 'package:flutter/material.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/models/expense.dart';
import 'package:provider/provider.dart';

class AddExpenseScreen extends StatefulWidget {
  AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  bool _isLoading = false; // İşlem yükleniyor mu durumunu takip eden değişken

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () async {  // Buton yalnızca işlem yapılırken devre dışı bırakılır
                setState(() {
                  _isLoading = true; // İşlem başladığında yükleniyor durumu true
                });

                final type = typeController.text;
                final category = categoryController.text;
                final description = descriptionController.text;
                final amount = double.tryParse(amountController.text);

                if (category.isNotEmpty &&
                    type.isNotEmpty &&
                    description.isNotEmpty &&
                    amount != null) {
                  final expense = TransactionModel(
                    type: type,
                    category: category,
                    description: description,
                    amount: amount,
                    date: DateTime.now(),
                  );

                  try {
                    // Veriyi provider üzerinden eklemeye çalışıyoruz
                    await context.read<TransactionProvider>().addTransaction(expense);

                    // Veriyi ekledikten sonra sayfayı geri al
                    Navigator.pop(context);
                  } catch (e) {
                    // Hata durumunda kullanıcıya bilgi ver
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add expense: $e')),
                    );
                  }
                }

                setState(() {
                  _isLoading = false; // İşlem tamamlandığında yükleniyor durumu false
                });
              },
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white) // Yükleniyorsa butonun yerine loading göstergesi
                  : Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
