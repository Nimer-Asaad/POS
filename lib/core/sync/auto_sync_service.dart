import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';
import '../../data/db/app_database.dart';

/// Auto-sync service that syncs local changes to Supabase automatically
/// Listens to database changes and replicates them to cloud
class AutoSyncService {
  final SupabaseClient _supabase;
  bool _isEnabled = true;

  AutoSyncService({required AppDatabase database, SupabaseClient? supabase})
    : _supabase = supabase ?? SupabaseConfig.client;

  /// Check if auto-sync is available
  bool get isAvailable => SupabaseConfig.isInitialized && _isEnabled;

  /// Enable auto-sync
  void enable() => _isEnabled = true;

  /// Disable auto-sync (useful for bulk operations)
  void disable() => _isEnabled = false;

  /// Sync a product after insert/update
  Future<void> syncProduct(Product product) async {
    if (!isAvailable) return;

    try {
      final data = {
        'id': product.id,
        'name': product.name,
        'barcode': product.barcode,
        'category': product.category,
        'supplier_id': product.supplierId,
        'sell_price': product.sellPrice,
        'cost_price': product.costPrice,
        'qty': product.qty,
        'track_imei': product.trackImei,
        'image_path': product.imagePath,
        'created_at': product.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('products').upsert(data);
      print('✅ Auto-synced product: ${product.name}');
    } catch (e) {
      print('⚠️  Auto-sync failed for product ${product.id}: $e');
      // Don't throw - local operation already succeeded
    }
  }

  /// Sync a customer after insert/update
  Future<void> syncCustomer(Customer customer) async {
    if (!isAvailable) return;

    try {
      final data = {
        'id': customer.id,
        'name': customer.name,
        'phone': customer.phone,
        'balance': customer.balance,
        'created_at': customer.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('customers').upsert(data);
      print('✅ Auto-synced customer: ${customer.name}');
    } catch (e) {
      print('⚠️  Auto-sync failed for customer ${customer.id}: $e');
    }
  }

  /// Sync a sale after insert/update
  Future<void> syncSale(Sale sale, List<SaleItem> items) async {
    if (!isAvailable) return;

    try {
      // Sync sale header
      final saleData = {
        'id': sale.id,
        'customer_id': sale.customerId,
        'total': sale.total,
        'discount': sale.discount,
        'paid': sale.paid,
        'payment_type': sale.paymentType,
        'created_at': sale.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('sales').upsert(saleData);

      // Sync sale items
      for (final item in items) {
        final itemData = {
          'id': item.id,
          'sale_id': item.saleId,
          'product_id': item.productId,
          'qty': item.qty,
          'unit_price': item.unitPrice,
          'line_total': item.lineTotal,
          'created_at': DateTime.now().toIso8601String(),
        };

        await _supabase.from('sale_items').upsert(itemData);
      }

      print('✅ Auto-synced sale: ${sale.id} with ${items.length} items');
    } catch (e) {
      print('⚠️  Auto-sync failed for sale ${sale.id}: $e');
    }
  }

  /// Sync a repair after insert/update
  Future<void> syncRepair(Repair repair, List<RepairPart> parts) async {
    if (!isAvailable) return;

    try {
      // Sync repair header
      final repairData = {
        'id': repair.id,
        'customer_id': repair.customerId,
        'customer_name': repair.customerName,
        'customer_phone': repair.customerPhone,
        'device': repair.device,
        'model': repair.model,
        'imei': repair.imei,
        'issue': repair.issue,
        'status': repair.status,
        'estimated_cost': repair.estimatedCost,
        'final_cost': repair.finalCost,
        'discount': repair.discount,
        'paid_at_receive': repair.paidAtReceive,
        'paid_at_delivery': repair.paidAtDelivery,
        'total_paid': repair.totalPaid,
        'created_at': repair.createdAt.toIso8601String(),
        'updated_at': repair.updatedAt.toIso8601String(),
      };

      await _supabase.from('repairs').upsert(repairData);

      // Sync repair parts
      for (final part in parts) {
        final partData = {
          'id': part.id,
          'repair_id': part.repairId,
          'product_id': part.productId,
          'qty': part.qty,
          'unit_price': part.unitPrice,
          'line_total': part.lineTotal,
          'created_at': DateTime.now().toIso8601String(),
        };

        await _supabase.from('repair_parts').upsert(partData);
      }

      print('✅ Auto-synced repair: ${repair.id} with ${parts.length} parts');
    } catch (e) {
      print('⚠️  Auto-sync failed for repair ${repair.id}: $e');
    }
  }

  /// Sync supplier
  Future<void> syncSupplier(Supplier supplier) async {
    if (!isAvailable) return;

    try {
      final data = {
        'id': supplier.id,
        'name': supplier.name,
        'phone': supplier.phone,
        'address': supplier.address,
        'created_at': supplier.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('suppliers').upsert(data);
      print('✅ Auto-synced supplier: ${supplier.name}');
    } catch (e) {
      print('⚠️  Auto-sync failed for supplier ${supplier.id}: $e');
    }
  }

  /// Sync payment
  Future<void> syncPayment(Payment payment) async {
    if (!isAvailable) return;

    try {
      final data = {
        'id': payment.id,
        'customer_id': payment.customerId,
        'amount': payment.amount,
        'direction': payment.direction,
        'note': payment.note,
        'created_at': payment.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('payments').upsert(data);
      print('✅ Auto-synced payment: ${payment.id}');
    } catch (e) {
      print('⚠️  Auto-sync failed for payment ${payment.id}: $e');
    }
  }

  /// Sync debt
  Future<void> syncDebt(Debt debt) async {
    if (!isAvailable) return;

    try {
      final data = {
        'id': debt.id,
        'customer_id': debt.customerId,
        'customer_name': debt.customerName,
        'customer_phone': debt.customerPhone,
        'source_type': debt.sourceType,
        'source_id': debt.sourceId,
        'amount': debt.amount,
        'due_date': debt.dueDate?.toIso8601String(),
        'note': debt.note,
        'created_at': debt.createdAt.toIso8601String(),
        'is_settled': debt.isSettled,
        'settled_at': debt.settledAt?.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('debts').upsert(data);
      print('✅ Auto-synced debt: ${debt.id}');
    } catch (e) {
      print('⚠️  Auto-sync failed for debt ${debt.id}: $e');
    }
  }

  /// Delete record from Supabase
  Future<void> syncDelete(String table, String id) async {
    if (!isAvailable) return;

    try {
      await _supabase.from(table).delete().eq('id', id);
      print('✅ Auto-synced delete from $table: $id');
    } catch (e) {
      print('⚠️  Auto-sync delete failed for $table/$id: $e');
    }
  }

  /// Sync multiple records (for bulk operations)
  Future<void> syncBulk(
    String table,
    List<Map<String, dynamic>> records,
  ) async {
    if (!isAvailable || records.isEmpty) return;

    try {
      // Disable auto-sync temporarily to avoid recursion
      final wasEnabled = _isEnabled;
      _isEnabled = false;

      await _supabase.from(table).upsert(records);
      print('✅ Auto-synced ${records.length} records to $table');

      _isEnabled = wasEnabled;
    } catch (e) {
      print('⚠️  Auto-sync bulk failed for $table: $e');
      _isEnabled = true;
    }
  }
}
