/// Service Profit Calculation System
///
/// This module provides pure, reusable profit calculations for service transactions
/// based on provider cost, service type, and special business rules.
library;

/// Input parameters for profit calculation
class ServiceProfitInput {
  final int amountCents; // Total amount customer pays
  final int providerCostCents; // What we pay to the provider
  final String
  serviceType; // 'bills', 'balance', 'games', 'roaming', 'bundle', 'internet', 'minutes'
  final String provider; // 'telelink', 'farahnet', 'fawry', etc.
  final String? subService; // Optional sub-service identifier

  const ServiceProfitInput({
    required this.amountCents,
    required this.providerCostCents,
    required this.serviceType,
    required this.provider,
    this.subService,
  });
}

/// Output structure for profit calculation
class ServiceProfitOutput {
  final int baseProfit; // amount - provider_cost
  final int bonusProfit; // Additional profit (e.g., games +1 ILS)
  final int finalProfit; // baseProfit + bonusProfit
  final double profitPercent; // (finalProfit / amount) * 100
  final bool isLoss; // finalProfit < 0
  final bool isLow; // finalProfit < 100 (1 ILS)
  final bool hasBonus; // bonusProfit > 0
  final String warning; // Warning message if applicable

  const ServiceProfitOutput({
    required this.baseProfit,
    required this.bonusProfit,
    required this.finalProfit,
    required this.profitPercent,
    required this.isLoss,
    required this.isLow,
    required this.hasBonus,
    this.warning = '',
  });

  /// Get warning emoji if applicable
  String get warningEmoji {
    if (isLoss) return '⚠️';
    if (isLow) return '⚠️';
    return '';
  }

  /// Get text description of profit status (Arabic/English)
  String getStatusText(bool isArabic) {
    if (isLoss) {
      return isArabic ? 'العملية بخسارة' : 'This transaction is a loss';
    }
    if (isLow) {
      return isArabic ? 'ربح قليل جداً' : 'Very low profit';
    }
    return '';
  }
}

/// Pure calculation function - NO side effects
///
/// CRITICAL RULES:
/// 1. Base profit = amount - provider_cost (always real difference)
/// 2. Games get +1 ILS (100 cents) bonus
/// 3. Other services use base profit only
/// 4. Profit % is for display only
/// 5. Warning if finalProfit < 0
ServiceProfitOutput calculateServiceProfit(ServiceProfitInput input) {
  // Validate input
  if (input.amountCents <= 0) {
    return ServiceProfitOutput(
      baseProfit: 0,
      bonusProfit: 0,
      finalProfit: 0,
      profitPercent: 0,
      isLoss: true,
      isLow: true,
      hasBonus: false,
      warning: 'Invalid amount',
    );
  }

  if (input.providerCostCents < 0) {
    return ServiceProfitOutput(
      baseProfit: 0,
      bonusProfit: 0,
      finalProfit: 0,
      profitPercent: 0,
      isLoss: true,
      isLow: true,
      hasBonus: false,
      warning: 'Invalid provider cost',
    );
  }

  // Rule 1: Calculate base profit (real difference)
  final baseProfit = input.amountCents - input.providerCostCents;

  // Rule 2: Add bonus for games service
  int bonusProfit = 0;
  bool hasBonus = false;

  if (input.serviceType.toLowerCase() == 'games') {
    bonusProfit = 100; // +1 ILS = 100 cents
    hasBonus = true;
  }

  // Rule 3: Calculate final profit
  final finalProfit = baseProfit + bonusProfit;

  // Rule 4: Calculate profit percentage (for display/analytics only)
  final profitPercent = input.amountCents > 0
      ? (finalProfit.toDouble() / input.amountCents.toDouble()) * 100
      : 0.0;

  // Rule 5: Check for warnings
  final isLoss = finalProfit < 0;
  final isLow = finalProfit > 0 && finalProfit < 100; // Less than 1 ILS

  String warning = '';
  if (isLoss) {
    warning = 'Loss transaction - cost exceeds revenue';
  } else if (isLow) {
    warning = 'Profit is very low (less than 1 ILS)';
  }

  return ServiceProfitOutput(
    baseProfit: baseProfit,
    bonusProfit: bonusProfit,
    finalProfit: finalProfit,
    profitPercent: profitPercent,
    isLoss: isLoss,
    isLow: isLow,
    hasBonus: hasBonus,
    warning: warning,
  );
}

/// Get expected profit percentage for display purposes only
/// These are estimates for UI/analytics - actual profit depends on provider cost
double getExpectedProfitPercent(String serviceType, String provider) {
  // Bills (فواتير) - ~1.5%
  if (serviceType == 'bills') return 1.5;

  // Balance (رصيد) - ~3%
  if (serviceType == 'balance') return 3.0;

  // Roaming - ~4.39%
  if (serviceType == 'roaming') return 4.39;

  // Games (العاب) - ~6-7% (plus +1 ILS bonus)
  if (serviceType == 'games') return 6.5;

  // Bundles / Internet / Minutes - ~3.26%
  if (['bundle', 'internet', 'minutes'].contains(serviceType)) return 3.26;

  // Default estimates by provider
  if (provider == 'telelink') return 2.5;
  if (provider == 'farahnet') return 2.0;
  if (provider == 'fawry') return 1.5;
  if (provider == 'platform') return 3.0;
  if (provider == 'electricity') return 1.5;
  if (provider == 'mada') return 0.5;

  return 2.0; // Default fallback
}

/// Get display label for service type (Arabic/English)
String getServiceTypeLabel(String serviceType, bool isArabic) {
  final labels = {
    'bills': isArabic ? 'فواتير' : 'Bills',
    'balance': isArabic ? 'رصيد' : 'Balance',
    'games': isArabic ? 'ألعاب' : 'Games',
    'roaming': isArabic ? 'تجوال' : 'Roaming',
    'bundle': isArabic ? 'حزمة' : 'Bundle',
    'internet': isArabic ? 'إنترنت' : 'Internet',
    'minutes': isArabic ? 'دقائق' : 'Minutes',
  };

  return labels[serviceType] ?? serviceType;
}

/// Format profit display with optional warning
String formatProfitDisplay(ServiceProfitOutput profit, bool isArabic) {
  final sign = profit.finalProfit >= 0 ? '+' : '';
  final ils = (profit.finalProfit / 100).toStringAsFixed(2);

  if (isArabic) {
    return '$sign₪$ils (${profit.profitPercent.toStringAsFixed(2)}%)';
  } else {
    return '$sign₪$ils (${profit.profitPercent.toStringAsFixed(2)}%)';
  }
}
