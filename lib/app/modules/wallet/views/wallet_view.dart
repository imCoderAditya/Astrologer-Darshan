import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color cardColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color dividerColor = isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'My Wallet',
          style: AppTextStyles.headlineMedium().copyWith(color: isDark ? AppColors.darkTextPrimary : AppColors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        flexibleSpace:
            isDark
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Balance Card
            _buildBalanceCard(isDark, cardColor, textColor, secondaryTextColor),
            const SizedBox(height: 10),

            // Quick Actions
            _buildSectionTitle("Quick Actions", textColor),
            _buildQuickActions(cardColor, textColor, isDark),
            const SizedBox(height: 10),

            // Transaction History Title
            _buildSectionTitle("Transaction History", textColor),
            const SizedBox(height: 10),

            // Transaction List (Example Data)
            _buildTransactionItem(
              icon: Icons.add_circle,
              iconColor: AppColors.sucessPrimary,
              title: "Wallet Top-up",
              subtitle: "Online Payment",
              amount: "+ Rs50.00",
              amountColor: AppColors.sucessPrimary,
              date: "Jul 28, 2025",
              cardColor: cardColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              dividerColor: dividerColor,
            ),
            _buildTransactionItem(
              icon: Icons.shopping_bag,
              iconColor: AppColors.red,
              title: "Product Purchase",
              subtitle: "Astrology Book 'Cosmic Guide'",
              amount: "- Rs25.00",
              amountColor: AppColors.red,
              date: "Jul 27, 2025",
              cardColor: cardColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              dividerColor: dividerColor,
            ),
            _buildTransactionItem(
              icon: Icons.remove_circle,
              iconColor: AppColors.red,
              title: "Withdrawal",
              subtitle: "Bank Transfer",
              amount: "- Rs10.00",
              amountColor: AppColors.red,
              date: "Jul 26, 2025",
              cardColor: cardColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              dividerColor: dividerColor,
            ),
            _buildTransactionItem(
              icon: Icons.lightbulb,
              iconColor: AppColors.secondaryPrimary, // Golden Yellow
              title: "Consultation Fee",
              subtitle: "Session with Astrologer Maya",
              amount: "- Rs15.00",
              amountColor: AppColors.red,
              date: "Jul 25, 2025",
              cardColor: cardColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              dividerColor: dividerColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(bool isDark, Color cardColor, Color textColor, Color secondaryTextColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDark ? [AppColors.darkSurface, AppColors.darkSurface] : [AppColors.primaryColor, AppColors.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
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
              color: isDark ? secondaryTextColor : AppColors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Rs",
                style: AppTextStyles.headlineLarge().copyWith(
                  color: isDark ? AppColors.secondaryPrimary : AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "125.75", // Example balance
                style: AppTextStyles.headlineLarge().copyWith(
                  fontSize: 48, // Larger font size for balance
                  color: isDark ? AppColors.secondaryPrimary : AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "Last updated: Jul 29, 2025", // Dynamic update time
              style: AppTextStyles.small().copyWith(
                color: isDark ? secondaryTextColor : AppColors.white.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(Color cardColor, Color textColor, bool isDark) {
    return Card(
      color: cardColor,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              Icons.account_balance_wallet,
              "Top Up",
              () {
                Get.snackbar("Top Up", "Navigate to top-up screen", snackPosition: SnackPosition.BOTTOM);
              },
              textColor,
              isDark,
            ),
            _buildActionButton(
              Icons.send,
              "Send Money",
              () {
                Get.snackbar("Send Money", "Navigate to send money screen", snackPosition: SnackPosition.BOTTOM);
              },
              textColor,
              isDark,
            ),
            _buildActionButton(
              Icons.history,
              "History",
              () {
                Get.snackbar("History", "View full transaction history", snackPosition: SnackPosition.BOTTOM);
              },
              textColor,
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap, Color textColor, bool isDark) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(isDark ? 0.2 : 0.1), // Lighter primary color
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 30),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.caption().copyWith(color: textColor)),
      ],
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

  Widget _buildTransactionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amount,
    required Color amountColor,
    required String date,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
    required Color dividerColor,
  }) {
    return Card(
      color: cardColor,
      elevation: 3, // Slightly less elevation than main cards
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0), // No horizontal margin, rely on parent padding
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15), // Light background for icon
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body().copyWith(color: textColor, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.caption().copyWith(color: secondaryTextColor)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amount, style: AppTextStyles.body().copyWith(color: amountColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(date, style: AppTextStyles.small().copyWith(color: secondaryTextColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
