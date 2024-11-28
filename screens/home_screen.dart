import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'expense_details.dart';

class HomeScreen extends StatelessWidget {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    
    return Scaffold(
      appBar: AppBar(title: Text("Expense Tracker")),
      body: Column(
        children: [
          TextField(controller: _titleController, decoration: InputDecoration(hintText: "Title")),
          TextField(controller: _categoryController, decoration: InputDecoration(hintText: "Category")),
          TextField(controller: _amountController, decoration: InputDecoration(hintText: "Amount")),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty && _categoryController.text.isNotEmpty && _amountController.text.isNotEmpty) {
                FirebaseFirestore.instance.collection('users').doc(userId).collection('expenses').add({
                  'title': _titleController.text,
                  'category': _categoryController.text,
                  'amount': _amountController.text,
                  'date': DateTime.now().toString(),
                  'status': 'Active',
                });
                _titleController.clear();
                _categoryController.clear();
                _amountController.clear();
              }
            },
            child: Text("Add Expense"),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('expenses')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var expenses = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    var expense = expenses[index];
                    return ListTile(
                      title: Text(expense['title']),
                      subtitle: Text("${expense['category']} - ${expense['amount']}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ExpenseDetails(expense: expense)),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
