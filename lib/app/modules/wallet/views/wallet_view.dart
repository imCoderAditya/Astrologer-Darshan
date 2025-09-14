// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color cardColor =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color dividerColor =
        isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return GetBuilder<WalletController>(
      init: WalletController(),
      builder: (controller) {
    
        final wallet = controller.walletModel.value;
        
        // Loading state
        if (controller.isLoading.value) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: _buildAppBar(isDark),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Error state
        if (wallet?.status == false) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: _buildAppBar(isDark),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: secondaryTextColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    wallet?.message ?? 'Something went wrong',
                    style: AppTextStyles.body().copyWith(color: textColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchWallet(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: _buildAppBar(isDark),
          body: RefreshIndicator(
            onRefresh: () => controller.fetchWallet(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Balance Card
                    _buildBalanceCard(
                      isDark,
                      cardColor,
                      textColor,
                      secondaryTextColor,
                      wallet,
                    ),
                    const SizedBox(height: 10),

                    // Summary Cards
                    if (wallet?.summary != null) ...[
                      _buildSummaryCards(
                        wallet!.summary!,
                        isDark,
                        cardColor,
                        textColor,
                        secondaryTextColor,
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Transaction History
                    if (wallet?.transactions?.isNotEmpty == true) ...[
                      _buildSectionTitle("Transaction History", textColor),
                      _buildTransactionsList(
                        wallet!.transactions!,
                        cardColor,
                        textColor,
                        secondaryTextColor,
                        dividerColor,
                      ),
                    ] else ...[
                      _buildEmptyTransactions(textColor, secondaryTextColor),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(bool isDark) {
    return AppBar(
      title: Text(
        'My Wallet',
        style: AppTextStyles.headlineMedium().copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
      flexibleSpace: isDark
          ? null
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.headerGradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
      elevation: 0,
    );
  }

  Widget _buildBalanceCard(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
    dynamic wallet,
  ) {
    final summary = wallet?.summary;
    final transactions = wallet?.transactions;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.darkSurface, AppColors.darkSurface]
              : [AppColors.primaryColor, AppColors.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.5)
                : Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Current Balance",
            style: AppTextStyles.caption().copyWith(
              color: isDark
                  ? secondaryTextColor
                  : AppColors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Rs ",
                style: AppTextStyles.headlineLarge().copyWith(
                  color: isDark ? AppColors.secondaryPrimary : AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  "${summary?.availableBalance?.toStringAsFixed(2) ?? "0.00"}",
                  style: AppTextStyles.headlineLarge().copyWith(
                    fontSize: 48,
                    color: isDark ? AppColors.secondaryPrimary : AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "Last updated: ${_getLastUpdateTime(transactions)}",
              style: AppTextStyles.small().copyWith(
                color: isDark
                    ? secondaryTextColor
                    : AppColors.white.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(
    dynamic summary,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                "Total Income",
                "Rs ${summary.overallIncome?.toStringAsFixed(2) ?? "0.00"}",
                Icons.trending_up,
                AppColors.sucessPrimary,
                isDark,
                cardColor,
                textColor,
                secondaryTextColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSummaryCard(
                "Total Withdrawn",
                "Rs ${summary.totalWithdrawAmount?.toStringAsFixed(2) ?? "0.00"}",
                Icons.trending_down,
                AppColors.red,
                isDark,
                cardColor,
                textColor,
                secondaryTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                "Pending Withdraw",
                "Rs ${summary.totalPendingWithdraw?.toStringAsFixed(2) ?? "0.00"}",
                Icons.hourglass_empty,
                AppColors.yellow,
                isDark,
                cardColor,
                textColor,
                secondaryTextColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSummaryCard(
                "Cancelled Withdraw",
                "Rs ${summary.totalCancelledWithdraw?.toStringAsFixed(2) ?? "0.00"}",
                Icons.cancel,
                AppColors.red.withOpacity(0.7),
                isDark,
                cardColor,
                textColor,
                secondaryTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String amount,
    IconData icon,
    Color iconColor,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.caption().copyWith(
              color: secondaryTextColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: AppTextStyles.body().copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(
    List<dynamic> transactions,
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
    Color dividerColor,
  ) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionItem(
          transaction: transaction,
          cardColor: cardColor,
          textColor: textColor,
          secondaryTextColor: secondaryTextColor,
          dividerColor: dividerColor,
        );
      },
    );
  }

  Widget _buildTransactionItem({
    required dynamic transaction,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
    required Color dividerColor,
  }) {
    // Determine transaction properties
    final transactionType = transaction.transactionType ?? 'Unknown';
    final amount = transaction.amount ?? 0.0;
    final description = transaction.description ?? 'No description';
    final status = transaction.status ?? 'Unknown';
    final createdAt = transaction.createdAt ?? '';
    final reference = transaction.reference ?? '';

    // Determine icon and colors based on transaction type and status
    IconData icon;
    Color iconColor;
    Color amountColor;
    String amountText;

    switch (transactionType.toLowerCase()) {
      case 'credit':
      case 'deposit':
      case 'topup':
      case 'top-up':
      case 'add':
        icon = Icons.add_circle;
        iconColor = AppColors.sucessPrimary;
        amountColor = AppColors.sucessPrimary;
        amountText = "+ Rs${amount.toStringAsFixed(2)}";
        break;
      case 'debit':
      case 'withdraw':
      case 'withdrawal':
      case 'subtract':
        icon = Icons.remove_circle;
        iconColor = AppColors.red;
        amountColor = AppColors.red;
        amountText = "- Rs${amount.toStringAsFixed(2)}";
        break;
      case 'transfer':
        icon = Icons.swap_horiz;
        iconColor = AppColors.yellow;
        amountColor = AppColors.yellow;
        amountText = "Rs${amount.toStringAsFixed(2)}";
        break;
      default:
        icon = Icons.account_balance_wallet;
        iconColor = AppColors.primaryColor;
        amountColor = textColor;
        amountText = "Rs${amount.toStringAsFixed(2)}";
    }

    // Adjust colors based on status
    if (status.toLowerCase() == 'cancelled' || status.toLowerCase() == 'failed') {
      iconColor = iconColor.withOpacity(0.5);
      amountColor = amountColor.withOpacity(0.5);
    } else if (status.toLowerCase() == 'pending') {
      iconColor = AppColors.yellow;
      amountColor = AppColors.yellow;
    }

    return Card(
      color: cardColor,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatTransactionTitle(transactionType),
                    style: AppTextStyles.body().copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.caption().copyWith(
                      color: secondaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (reference.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      "Ref: $reference",
                      style: AppTextStyles.small().copyWith(
                        color: secondaryTextColor.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amountText,
                  style: AppTextStyles.body().copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppDateUtils.extractDate(createdAt, 4),
                  style: AppTextStyles.small().copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                if (status.toLowerCase() != 'completed' && status.toLowerCase() != 'success') ...[
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: AppTextStyles.small().copyWith(
                        color: _getStatusColor(status),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTransactions(Color textColor, Color secondaryTextColor) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: secondaryTextColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Transactions Yet',
            style: AppTextStyles.headlineLarge().copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your transaction history will appear here once you start using your wallet.',
            style: AppTextStyles.body().copyWith(
              color: secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: AppTextStyles.caption().copyWith(
            fontWeight: FontWeight.w700,
            color: color.withOpacity(0.85),
            letterSpacing: 0.8,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  String _formatTransactionTitle(String transactionType) {
    switch (transactionType.toLowerCase()) {
      case 'credit':
      case 'deposit':
      case 'topup':
      case 'top-up':
        return 'Wallet Top-up';
      case 'debit':
      case 'withdraw':
      case 'withdrawal':
        return 'Wallet Withdrawal';
      case 'transfer':
        return 'Money Transfer';
      default:
        return transactionType.split('').first.toUpperCase() + 
               transactionType.substring(1).toLowerCase();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
      case 'successful':
        return AppColors.sucessPrimary;
      case 'pending':
      case 'processing':
        return AppColors.secondaryPrimary;
      case 'failed':
      case 'cancelled':
      case 'rejected':
        return AppColors.red;
      default:
        return AppColors.primaryColor;
    }
  }

  String _getLastUpdateTime(List<dynamic>? transactions) {
    if (transactions?.isNotEmpty == true) {
      final lastTransaction = transactions!.last;
      return AppDateUtils.extractDate(lastTransaction.createdAt, 4);
    }
    return 'No transactions';
  }
}