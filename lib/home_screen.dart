import 'package:flutter/material.dart';

import 'db_helper.dart';
import 'add_expenseScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  List<Map<String,dynamic>> expenses=[];



  @override

  void initState(){
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async{
    final data = await DBHelper.getExpense();
    setState(() {
      expenses= data;
    });
  }

  double get totalExpenses{
    return expenses.fold(0.0,
        (sum,item) =>  sum+(item['amount'] as num ).toDouble());
  }
  Widget build(BuildContext context) {
    return Scaffold(

appBar: AppBar(
  title: Text("Expense Tracker",
  style: TextStyle(fontWeight: FontWeight.bold,
  fontSize: 24),),
  backgroundColor: Theme.of(context).colorScheme.primary,),

      body:
      Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text("Total Expenses",style: TextStyle(fontSize: 20),),
                SizedBox(height: 10),
                Text(
                    "৳ ${totalExpenses.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 28,
              fontWeight: FontWeight.bold),
                ),
              ],
            ),),
          ),
    Expanded(
      child: ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context,index){
            final expense = expenses[index];

            return Card(
    margin: EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 5
    ),


    child:  ListTile(
    title: Text(expense['title']),
    subtitle:Text('৳ ${expense['amount']}'),
    trailing:  IconButton(
    icon: Icon(Icons.delete,
    color: Colors.red),
    onPressed: () async
    {
      await DBHelper.deleteExpense(expense['id']);

      loadExpenses();
      },),
    ),
    );
    },
          ),
    )],
      ),

      floatingActionButton: FloatingActionButton(onPressed: () async{
        await showDialog(
          context: context,
          barrierColor: Colors.white.withValues(alpha: 0.7),
          builder: (context) => const AddExpensescreen(),
        );
        loadExpenses();
      },
      child: Icon(Icons.add),),




    );
  }
}
