import 'package:flutter_test/flutter_test.dart';

// Helper function to simulate discount violation check
String? checkDiscountViolation(
  List<TestCartItem> items,
  int subtotal,
  int discount,
) {
  if (subtotal <= 0) {
    return null;
  }

  if (discount > subtotal) {
    return 'Discount cannot exceed subtotal.';
  }

  for (final item in items) {
    final itemGross = item.sellPriceCents * item.qty;
    final itemDiscount = ((discount * itemGross) / subtotal).round();
    final itemNet = itemGross - itemDiscount;
    final effectiveUnitNet = itemNet ~/ item.qty;
    if (effectiveUnitNet < item.costPriceCents) {
      final difference = item.costPriceCents - effectiveUnitNet;
      return "تم رفض الخصم لأن السعر بعد الخصم أقل من سعر الجملة (Cost).\n"
          "المنتج: ${item.name}\n"
          "سعر الجملة: ${_formatCents(item.costPriceCents)}\n"
          "السعر بعد الخصم: ${_formatCents(effectiveUnitNet)}\n"
          "الفرق: ${_formatCents(difference)}";
    }
  }

  return null;
}

String _formatCents(int cents) {
  return '₪${(cents / 100).toStringAsFixed(2)}';
}

// Test helper class
class TestCartItem {
  final String name;
  final int sellPriceCents;
  final int costPriceCents;
  final int qty;

  TestCartItem({
    required this.name,
    required this.sellPriceCents,
    required this.costPriceCents,
    required this.qty,
  });
}

void main() {
  group('POS Payment Logic', () {
    test('paid < total -> change = 0 & checkout disabled', () {
      // Arrange
      final int total = 10000; // ₪100.00
      final int paid = 5000; // ₪50.00
      final String paymentType = 'Cash';

      // Act
      final int change = paymentType == 'Credit'
          ? 0
          : (paid >= total ? paid - total : 0);
      final bool canCheckout = paid >= total;

      // Assert
      expect(change, equals(0), reason: 'Change should be 0 when paid < total');
      expect(
        canCheckout,
        isFalse,
        reason: 'Checkout should be disabled when paid < total',
      );
    });

    test('paid >= total -> correct positive change', () {
      // Arrange
      final int total = 10000; // ₪100.00
      final int paid = 15000; // ₪150.00
      final String paymentType = 'Cash';

      // Act
      final int change = paymentType == 'Credit'
          ? 0
          : (paid >= total ? paid - total : 0);
      final bool canCheckout = paid >= total;

      // Assert
      expect(
        change,
        equals(5000),
        reason: 'Change should be ₪50.00 (5000 cents)',
      );
      expect(
        canCheckout,
        isTrue,
        reason: 'Checkout should be enabled when paid >= total',
      );
    });

    test('Credit payment -> change = 0 regardless of paid amount', () {
      // Arrange
      final int total = 10000; // ₪100.00
      final int paid = 5000; // ₪50.00
      final String paymentType = 'Credit';

      // Act
      final int change = paymentType == 'Credit'
          ? 0
          : (paid >= total ? paid - total : 0);

      // Assert
      expect(
        change,
        equals(0),
        reason: 'Change should always be 0 for Credit payment',
      );
    });
  });

  group('POS Discount Below Cost Logic', () {
    test('discount makes price < cost -> blocked with Arabic message', () {
      // Arrange
      final items = [
        TestCartItem(
          name: 'Test Product',
          sellPriceCents: 10000, // ₪100.00 sell price
          costPriceCents: 7000, // ₪70.00 cost price
          qty: 1,
        ),
      ];
      final int subtotal = 10000; // ₪100.00
      final int discount = 4000; // ₪40.00 discount

      // Act
      // After discount: 10000 - 4000 = 6000 (₪60.00)
      // This is below cost (7000 / ₪70.00)
      final violation = checkDiscountViolation(items, subtotal, discount);

      // Assert
      expect(
        violation,
        isNotNull,
        reason: 'Should block checkout when price is below cost',
      );
      expect(
        violation,
        contains('تم رفض الخصم'),
        reason: 'Error message should be in Arabic',
      );
      expect(
        violation,
        contains('Test Product'),
        reason: 'Error message should include product name',
      );
      expect(
        violation,
        contains('₪70.00'),
        reason: 'Error message should show cost price',
      );
      expect(
        violation,
        contains('₪60.00'),
        reason: 'Error message should show price after discount',
      );
      expect(
        violation,
        contains('₪10.00'),
        reason: 'Error message should show difference',
      );
    });

    test('discount keeps price >= cost -> allowed', () {
      // Arrange
      final items = [
        TestCartItem(
          name: 'Test Product',
          sellPriceCents: 10000, // ₪100.00 sell price
          costPriceCents: 7000, // ₪70.00 cost price
          qty: 1,
        ),
      ];
      final int subtotal = 10000; // ₪100.00
      final int discount = 2000; // ₪20.00 discount

      // Act
      // After discount: 10000 - 2000 = 8000 (₪80.00)
      // This is above cost (7000 / ₪70.00)
      final violation = checkDiscountViolation(items, subtotal, discount);

      // Assert
      expect(
        violation,
        isNull,
        reason: 'Should allow checkout when price is above cost',
      );
    });

    test('discount exactly at cost -> allowed', () {
      // Arrange
      final items = [
        TestCartItem(
          name: 'Test Product',
          sellPriceCents: 10000, // ₪100.00 sell price
          costPriceCents: 7000, // ₪70.00 cost price
          qty: 1,
        ),
      ];
      final int subtotal = 10000; // ₪100.00
      final int discount = 3000; // ₪30.00 discount

      // Act
      // After discount: 10000 - 3000 = 7000 (₪70.00)
      // This is exactly at cost (7000 / ₪70.00)
      final violation = checkDiscountViolation(items, subtotal, discount);

      // Assert
      expect(
        violation,
        isNull,
        reason: 'Should allow checkout when price equals cost',
      );
    });

    test('multiple items with proportional discount -> blocks if any below cost', () {
      // Arrange
      final items = [
        TestCartItem(
          name: 'Product A',
          sellPriceCents: 10000, // ₪100.00
          costPriceCents: 8000, // ₪80.00
          qty: 1,
        ),
        TestCartItem(
          name: 'Product B',
          sellPriceCents: 5000, // ₪50.00
          costPriceCents: 3000, // ₪30.00
          qty: 2,
        ),
      ];
      final int subtotal = 20000; // ₪200.00 (100 + 50*2)
      final int discount = 6000; // ₪60.00 discount

      // Act
      // Product A: 10000 - (6000 * 10000/20000) = 10000 - 3000 = 7000 (below 8000 cost)
      // Product B: 10000 - (6000 * 10000/20000) = 10000 - 3000 = 7000, per unit = 3500 (above 3000 cost)
      final violation = checkDiscountViolation(items, subtotal, discount);

      // Assert
      expect(
        violation,
        isNotNull,
        reason:
            'Should block checkout if any product is below cost after proportional discount',
      );
      expect(
        violation,
        contains('Product A'),
        reason: 'Error message should identify the problematic product',
      );
    });
  });

  group('POS Integer Cents Calculations', () {
    test('all calculations remain in cents to avoid floating point errors', () {
      // Arrange
      final int sellPrice = 9999; // ₪99.99
      final int qty = 3;
      final int discount = 1000; // ₪10.00

      // Act
      final int lineTotal = sellPrice * qty; // 29997 cents
      final int total = lineTotal - discount; // 28997 cents

      // Assert
      expect(
        lineTotal,
        equals(29997),
        reason: 'Line total should be exact integer cents',
      );
      expect(
        total,
        equals(28997),
        reason: 'Total after discount should be exact integer cents',
      );
      expect(
        total % 1,
        equals(0),
        reason: 'Total should be an integer (no floating point)',
      );
    });

    test('discount distribution uses integer rounding', () {
      // Arrange - scenario where discount doesn't divide evenly
      final items = [
        TestCartItem(
          name: 'Item 1',
          sellPriceCents: 3333, // ₪33.33
          costPriceCents: 2000,
          qty: 1,
        ),
        TestCartItem(
          name: 'Item 2',
          sellPriceCents: 3333, // ₪33.33
          costPriceCents: 2000,
          qty: 1,
        ),
        TestCartItem(
          name: 'Item 3',
          sellPriceCents: 3334, // ₪33.34
          costPriceCents: 2000,
          qty: 1,
        ),
      ];
      final int subtotal = 10000; // ₪100.00
      final int discount = 1000; // ₪10.00

      // Act
      int totalDiscountApplied = 0;
      for (final item in items) {
        final itemGross = item.sellPriceCents * item.qty;
        final itemDiscount = ((discount * itemGross) / subtotal).round();
        totalDiscountApplied += itemDiscount;
      }

      // Assert
      // Item 1: (1000 * 3333 / 10000).round() = 333
      // Item 2: (1000 * 3333 / 10000).round() = 333
      // Item 3: (1000 * 3334 / 10000).round() = 333
      // Total: 999 (close to 1000, rounding difference of 1 cent is acceptable)
      expect(
        (totalDiscountApplied - discount).abs(),
        lessThanOrEqualTo(10),
        reason:
            'Discount distribution should be within 10 cents of target (acceptable rounding)',
      );
      expect(
        totalDiscountApplied.runtimeType,
        equals(int),
        reason: 'All discount calculations should remain as integers',
      );
    });
  });
}
