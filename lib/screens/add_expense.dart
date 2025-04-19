
import 'package:flutter/material.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/utils/form_validators.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  AddExpenseScreenState createState() => AddExpenseScreenState();
}

class AddExpenseScreenState extends State<AddExpenseScreen> {
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  final _categoryFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _amountFocus = FocusNode();

  String _selectedType = 'Gelir';
  bool _isLoading = false;

  @override
  void dispose() {
    _categoryController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();

    _categoryFocus.dispose();
    _descriptionFocus.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  Future<void> _submitExpense() async {
    final category = _categoryController.text.trim();
    final description = _descriptionController.text.trim();
    final rawAmount = _amountController.text;

    final amount = AmountFormatter.parse(rawAmount);
    if (category.isEmpty || description.isEmpty || amount == null) {
      _showMessage('Lütfen tüm alanları doğru doldurun.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showMessage('Kullanıcı oturumu bulunamadı.');
      return;
    }

    final transaction = TransactionModel(
      type: _selectedType,
      category: category,
      description: description,
      amount: amount,
      date: DateTime.now(),
      userId: user.uid,
    );

    setState(() => _isLoading = true);
    try {
      await context.read<TransactionProvider>().addTransaction(transaction);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showMessage('Kayıt eklenemedi: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yeni Gider Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedType,
              onChanged: (value) => setState(() => _selectedType = value!),
              items:
                  ['Gelir', 'Gider']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
              isExpanded: true,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _categoryController,
              _categoryFocus,
              _descriptionFocus,
              'Kategori',
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _descriptionController,
              _descriptionFocus,
              _amountFocus,
              'Açıklama',
            ),
            const SizedBox(height: 20),
            _buildAmountField(),
            const SizedBox(height: 20),
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

  Widget _buildTextField(
    TextEditingController controller,
    FocusNode currentFocus,
    FocusNode nextFocus,
    String label,
  ) {
    return TextField(
      controller: controller,
      focusNode: currentFocus,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => FocusScope.of(context).requestFocus(nextFocus),
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      focusNode: _amountFocus,
      maxLength: 20,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Tutar'),
      inputFormatters: [MoneyInputFormatter()],
    );
  }
}

