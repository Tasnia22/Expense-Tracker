import 'package:flutter/material.dart';

import 'db_helper.dart';


class AddExpensescreen extends StatefulWidget {
  const AddExpensescreen({super.key});

  @override
  State<AddExpensescreen> createState() => _AddExpensescreenState();
}

class _AddExpensescreenState extends State<AddExpensescreen> {

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  Future<void> saveExpense() async {
    String title = titleController.text.trim();
    String amountText = amountController.text.trim();

    if (title.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    double? amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount')),
      );
      return;
    }

    // Save data to SQLite
    await DBHelper.insertExpense(title, amount);

    // Close AlertDialog and return to HomeScreen
    if (!mounted) return;
    Navigator.pop(context);
  }




  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Expense',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Expense Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: saveExpense,
          child: const Text('Save Expense'),
        ),
      ],
    );
  }
}