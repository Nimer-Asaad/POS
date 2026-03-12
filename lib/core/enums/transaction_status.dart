/// Transaction status for soft reversal support
enum TransactionStatus {
  /// Normal active transaction (default)
  normal,
  
  /// Transaction has been reversed/refunded
  reversed,
}

/// Extension to convert TransactionStatus to/from string for database storage
extension TransactionStatusExtension on TransactionStatus {
  String toDbString() {
    switch (this) {
      case TransactionStatus.normal:
        return 'normal';
      case TransactionStatus.reversed:
        return 'reversed';
    }
  }
  
  static TransactionStatus fromDbString(String value) {
    switch (value) {
      case 'reversed':
        return TransactionStatus.reversed;
      case 'normal':
      default:
        return TransactionStatus.normal;
    }
  }
}
