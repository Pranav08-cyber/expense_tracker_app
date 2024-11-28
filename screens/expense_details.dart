import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpenseDetails extends StatelessWidget {
  final DocumentSnapshot expense;

  ExpenseDetails({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Expense Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title: ${expense['title']}", style: TextStyle(fontSize: 20)),
            Text("Category: ${expense['category']}", style: TextStyle(fontSize: 20)),
            Text("Amount: ${expense['amount']}", style: TextStyle(fontSize: 20)),
            Text("Date: ${expense['date']}", style: TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('users').doc(expense['userId']).collection('expenses').doc(expense.id).delete();
                Navigator.pop(context);
              },
              child: Text("Delete Expense"),
            ),
          ],
        ),
      ),
    );
  }
}
