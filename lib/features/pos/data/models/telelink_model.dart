/// Telelink Service Data Models and Constants
library;

enum TelinkServiceCategory {
  bills,
  balance,
  bundles,
  roaming,
  games;

  String get labelAr {
    return switch (this) {
      TelinkServiceCategory.bills => 'فواتير',
      TelinkServiceCategory.balance => 'رصيد',
      TelinkServiceCategory.bundles => 'حزم',
      TelinkServiceCategory.roaming => 'تجوال',
      TelinkServiceCategory.games => 'ألعاب',
    };
  }

  String get labelEn {
    return switch (this) {
      TelinkServiceCategory.bills => 'Bills',
      TelinkServiceCategory.balance => 'Balance',
      TelinkServiceCategory.bundles => 'Bundles',
      TelinkServiceCategory.roaming => 'Roaming',
      TelinkServiceCategory.games => 'Games',
    };
  }

  /// Get profit percentage for this category (based on 6-month dataset)
  double get profitPercent {
    return switch (this) {
      TelinkServiceCategory.bills => 1.5,
      TelinkServiceCategory.balance => 3.0,
      TelinkServiceCategory.bundles => 3.26,
      TelinkServiceCategory.roaming => 4.39,
      TelinkServiceCategory.games => 6.06,
    };
  }

  /// Check if this category gets a bonus
  bool get hasBonus => this == TelinkServiceCategory.games;

  /// Get bonus amount in ILS (only games get +1 ILS)
  double get bonusIls => hasBonus ? 1.0 : 0.0;
}

/// Represents a single Telelink service item (searchable)
class TelinkServiceItem {
  final String id;
  final String name;
  final String nameAr;
  final TelinkServiceCategory category;
  final double? estimatedCost;

  const TelinkServiceItem({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.category,
    this.estimatedCost,
  });
}

/// Profit calculation result for Telelink services
class TelinkProfitResult {
  final double percent; // Profit percentage used
  final int profitBaseCents; // Percentage-based profit (in cents)
  final int bonusProfitCents; // +1 ILS (100 cents) for games only
  final int finalProfitCents; // profitBase + bonusProfit
  final double profitPercentShown; // (finalProfit / amount) * 100
  final int estimatedCostCents; // amount - profitBase (for display)
  final bool isLowProfit; // finalProfit < 100 cents (1 ILS)
  final bool hasGameBonus; // category == games

  const TelinkProfitResult({
    required this.percent,
    required this.profitBaseCents,
    required this.bonusProfitCents,
    required this.finalProfitCents,
    required this.profitPercentShown,
    required this.estimatedCostCents,
    required this.isLowProfit,
    required this.hasGameBonus,
  });

  String getWarningMessage(bool isArabic) {
    if (isLowProfit) {
      return isArabic ? '⚠️ ربح منخفض' : '⚠️ Low profit';
    }
    return '';
  }
}

/// Pure calculation function for Telelink profit using fixed percentages
TelinkProfitResult calculateTelinkProfit({
  required int amountCents, // Amount in cents
  required TelinkServiceCategory category,
}) {
  // Validate inputs
  if (amountCents <= 0) {
    return TelinkProfitResult(
      percent: 0,
      profitBaseCents: 0,
      bonusProfitCents: 0,
      finalProfitCents: 0,
      profitPercentShown: 0,
      estimatedCostCents: 0,
      isLowProfit: true,
      hasGameBonus: false,
    );
  }

  // Calculate percentage-based profit
  final percent = category.profitPercent;
  final profitBaseCents = (amountCents * percent / 100).round();

  // Add bonus for games
  final hasGameBonus = category.hasBonus;
  final bonusProfitCents = hasGameBonus ? 100 : 0; // +1 ILS = 100 cents

  // Final profit
  final finalProfitCents = profitBaseCents + bonusProfitCents;

  // Profit percentage shown (final profit / amount * 100)
  final profitPercentShown = (finalProfitCents.toDouble() / amountCents.toDouble()) * 100;

  // Estimated cost (for display purposes)
  final estimatedCostCents = amountCents - profitBaseCents;

  // Warning
  final isLowProfit = finalProfitCents < 100; // Less than 1 ILS

  return TelinkProfitResult(
    percent: percent,
    profitBaseCents: profitBaseCents,
    bonusProfitCents: bonusProfitCents,
    finalProfitCents: finalProfitCents,
    profitPercentShown: profitPercentShown,
    estimatedCostCents: estimatedCostCents,
    isLowProfit: isLowProfit,
    hasGameBonus: hasGameBonus,
  );
}

/// Sample Telelink services for each category
final telinkServicesData = {
  TelinkServiceCategory.bills: [
    TelinkServiceItem(
      id: 'bill_1',
      name: 'Internet Bill',
      nameAr: 'فاتورة الإنترنت',
      category: TelinkServiceCategory.bills,
    ),
    TelinkServiceItem(
      id: 'bill_2',
      name: 'TV Bill',
      nameAr: 'فاتورة التلفاز',
      category: TelinkServiceCategory.bills,
    ),
    TelinkServiceItem(
      id: 'bill_3',
      name: 'Mobile Bill',
      nameAr: 'فاتورة الجوال',
      category: TelinkServiceCategory.bills,
    ),
  ],
  TelinkServiceCategory.balance: [
    TelinkServiceItem(
      id: 'balance_10',
      name: 'Balance 10 ILS',
      nameAr: 'رصيد 10 شيكل',
      category: TelinkServiceCategory.balance,
      estimatedCost: 9.70,
    ),
    TelinkServiceItem(
      id: 'balance_25',
      name: 'Balance 25 ILS',
      nameAr: 'رصيد 25 شيكل',
      category: TelinkServiceCategory.balance,
      estimatedCost: 24.25,
    ),
    TelinkServiceItem(
      id: 'balance_50',
      name: 'Balance 50 ILS',
      nameAr: 'رصيد 50 شيكل',
      category: TelinkServiceCategory.balance,
      estimatedCost: 48.50,
    ),
  ],
  TelinkServiceCategory.bundles: [
    TelinkServiceItem(
      id: 'bundle_1',
      name: 'Data Bundle 1GB',
      nameAr: 'حزمة بيانات 1 جيجا',
      category: TelinkServiceCategory.bundles,
    ),
    TelinkServiceItem(
      id: 'bundle_2',
      name: 'Data Bundle 5GB',
      nameAr: 'حزمة بيانات 5 جيجا',
      category: TelinkServiceCategory.bundles,
    ),
    TelinkServiceItem(
      id: 'bundle_3',
      name: 'Mixed Bundle',
      nameAr: 'حزمة مختلطة',
      category: TelinkServiceCategory.bundles,
    ),
  ],
  TelinkServiceCategory.roaming: [
    TelinkServiceItem(
      id: 'roaming_1',
      name: 'Roaming Egypt',
      nameAr: 'تجوال مصر',
      category: TelinkServiceCategory.roaming,
    ),
    TelinkServiceItem(
      id: 'roaming_2',
      name: 'Roaming EU',
      nameAr: 'تجوال أوروبا',
      category: TelinkServiceCategory.roaming,
    ),
    TelinkServiceItem(
      id: 'roaming_3',
      name: 'Roaming USA',
      nameAr: 'تجوال أمريكا',
      category: TelinkServiceCategory.roaming,
    ),
  ],
  TelinkServiceCategory.games: [
    TelinkServiceItem(
      id: 'game_1',
      name: 'Game Points 100',
      nameAr: 'نقاط لعبة 100',
      category: TelinkServiceCategory.games,
    ),
    TelinkServiceItem(
      id: 'game_2',
      name: 'Game Points 500',
      nameAr: 'نقاط لعبة 500',
      category: TelinkServiceCategory.games,
    ),
    TelinkServiceItem(
      id: 'game_3',
      name: 'Game Points 1000',
      nameAr: 'نقاط لعبة 1000',
      category: TelinkServiceCategory.games,
    ),
  ],
};

/// Get services for a specific category
List<TelinkServiceItem> getTelinkServicesByCategory(
  TelinkServiceCategory category,
) {
  return telinkServicesData[category] ?? [];
}

/// Search Telelink services
List<TelinkServiceItem> searchTelinkServices(
  List<TelinkServiceItem> services,
  String query,
) {
  if (query.isEmpty) return services;

  final lowerQuery = query.toLowerCase();
  return services
      .where(
        (service) =>
            service.name.toLowerCase().contains(lowerQuery) ||
            service.nameAr.contains(query),
      )
      .toList();
}
