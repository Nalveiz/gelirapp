import 'package:flutter/material.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/models/expense.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  AddExpenseScreenState createState() => AddExpenseScreenState();
}

class AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // Gelir/Gider türü seçimi için dropdown
  String selectedType = 'Gelir';

  bool _isLoading = false;

  @override
  void dispose() {
    categoryController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _submitExpense() async {
    final type = selectedType; // Dropdown'dan seçilen tür
    final category = categoryController.text.trim();
    final description = descriptionController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (category.isEmpty || description.isEmpty || amount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lütfen tüm alanları doldurun.')));
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kullanıcı oturumu bulunamadı.')));
      return;
    }

    final transaction = TransactionModel(
      type: type, // Gelir veya Gider
      category: category,
      description: description,
      amount: amount,
      date: DateTime.now(),
      userId: user.uid,
    );

    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<TransactionProvider>().addTransaction(transaction);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kayıt eklenemedi: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yeni Gider Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tür seçimi için Dropdown
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: double.infinity,
                child: DropdownButton<String>(
                  value: selectedType,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  itemHeight: 50,
                  menuWidth: 500,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue!;
                    });
                  },
                  items:
                      <String>['Gelir', 'Gider'].map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Açıklama'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Tutar'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitExpense,
              child:
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
