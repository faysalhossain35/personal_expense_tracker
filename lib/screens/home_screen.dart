import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_tracker/providers/providers.dart';
import 'package:personal_expense_tracker/screens/transaction_detail_screen.dart';
import 'package:personal_expense_tracker/screens/transaction_form_screen.dart';
import 'package:personal_expense_tracker/widgets/build_summary_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  static const List<String> _categoryFilters = [
    'All',
    'Food',
    'Transport',
    'Bills',
    'Entertainment',
    'Salary',
    'Investment',
    'Other',
  ];

  String _selectedCategory = 'All';

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text(
          'Are you sure you want to delete this transaction?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(transactionProvider.notifier).deleteTransaction(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);
    final totalIncome = ref.watch(totalIncomeProvider);
    final totalExpense = ref.watch(totalExpenseProvider);
    final currentBalance = ref.watch(currentBalanceProvider);
    final filteredTransactions = _selectedCategory == 'All'
        ? transactions
        : transactions
              .where((item) => item.category == _selectedCategory)
              .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        elevation: 0,
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.read(transactionProvider.notifier).loadTransactions(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildSummaryCard(
                title: 'Current Balance',
                amount: '\$${currentBalance.toStringAsFixed(2)}',
                color: currentBalance >= 0
                    ? const Color(0xFF12B886)
                    : const Color(0xFFEA580C),
                icon: currentBalance >= 0
                    ? Icons.account_balance_wallet_rounded
                    : Icons.warning_amber_rounded,
                isFeatured: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: BuildSummaryCard(
                      title: 'Income',
                      amount: '\$${totalIncome.toStringAsFixed(2)}',
                      color: const Color(0xFF22C55E),
                      icon: Icons.arrow_downward_rounded,
                      isFeatured: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BuildSummaryCard(
                      title: 'Expense',
                      amount: '\$${totalExpense.toStringAsFixed(2)}',
                      color: const Color(0xFFEF4444),
                      icon: Icons.arrow_upward_rounded,
                      isFeatured: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _selectedCategory = 'All'),
                    icon: const Icon(Icons.filter_list_rounded, size: 18),
                    label: const Text('All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _categoryFilters.map((category) {
                    final isSelected = _selectedCategory == category;
                    return FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = category),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),

              filteredTransactions.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                        child: Text('No transactions in this category yet.'),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final item = filteredTransactions[index];
                        final isIncome = item.type == 'Income';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isIncome
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              child: Icon(
                                isIncome
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                            ),
                            title: Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${item.category} • ${DateFormat('yyyy-MM-dd').format(item.date)}',
                            ),
                            trailing: Text(
                              '${isIncome ? '+' : '-'}\$${item.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: isIncome ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionDetailScreen(
                                    transaction: item,
                                    onDelete: () =>
                                        _confirmDelete(context, item.id!),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
