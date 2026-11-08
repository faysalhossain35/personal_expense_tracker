import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_expense_tracker/database/db_helper.dart';
import 'package:personal_expense_tracker/models/transaction_model.dart';

// Main Transaction Notifier managing state & CRUD side effects
class TransactionNotifier extends Notifier<List<TransactionModel>> {
  @override
  List<TransactionModel> build() {
    loadTransactions();
    return [];
  }

  Future<void> loadTransactions() async {
    state = await DatabaseHelper.instance.getAllTransactions();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.insertTransaction(transaction);
    await loadTransactions();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.updateTransaction(transaction);
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    await loadTransactions();
  }
}

// Provider definition
final transactionProvider =
    NotifierProvider<TransactionNotifier, List<TransactionModel>>(
      () => TransactionNotifier(),
    );

// Derived Providers for Summary calculations
final totalIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionProvider);
  return transactions
      .where((t) => t.type == 'Income')
      .fold(0.0, (sum, item) => sum + item.amount);
});

final totalExpenseProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionProvider);
  return transactions
      .where((t) => t.type == 'Expense')
      .fold(0.0, (sum, item) => sum + item.amount);
});

final currentBalanceProvider = Provider<double>((ref) {
  final income = ref.watch(totalIncomeProvider);
  final expense = ref.watch(totalExpenseProvider);
  return income - expense;
});
