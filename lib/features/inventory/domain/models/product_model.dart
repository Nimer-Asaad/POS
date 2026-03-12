import 'package:drift/drift.dart' as drift;
import '../../../../data/db/app_database.dart';

/// Product model for Supabase
/// Represents a product in the cloud database
class ProductModel {
  final String id;
  final String name;
  final String? barcode;
  final String category;
  final String? supplierId;
  final int sellPrice;
  final int costPrice;
  final int qty;
  final bool trackImei;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    this.barcode,
    required this.category,
    this.supplierId,
    required this.sellPrice,
    required this.costPrice,
    required this.qty,
    required this.trackImei,
    this.imagePath,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create from Supabase JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String?,
      category: json['category'] as String,
      supplierId: json['supplier_id'] as String?,
      sellPrice: (json['sell_price'] as num).toInt(),
      costPrice: (json['cost_price'] as num).toInt(),
      qty: (json['qty'] as num).toInt(),
      trackImei: json['track_imei'] as bool,
      imagePath: json['image_path'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'category': category,
      'supplier_id': supplierId,
      'sell_price': sellPrice,
      'cost_price': costPrice,
      'qty': qty,
      'track_imei': trackImei,
      'image_path': imagePath,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// Create from Drift Product entity
  factory ProductModel.fromDrift(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      barcode: product.barcode,
      category: product.category,
      supplierId: product.supplierId,
      sellPrice: product.sellPrice,
      costPrice: product.costPrice,
      qty: product.qty,
      trackImei: product.trackImei,
      imagePath: product.imagePath,
      createdAt: product.createdAt,
      updatedAt: null, // Drift doesn't have updatedAt
    );
  }

  /// Convert to Drift Product Companion for insert/update
  ProductsCompanion toDriftCompanion() {
    return ProductsCompanion(
      id: drift.Value(id),
      name: drift.Value(name),
      barcode: drift.Value(barcode),
      category: drift.Value(category),
      supplierId: drift.Value(supplierId),
      sellPrice: drift.Value(sellPrice),
      costPrice: drift.Value(costPrice),
      qty: drift.Value(qty),
      trackImei: drift.Value(trackImei),
      imagePath: drift.Value(imagePath),
      createdAt: drift.Value(createdAt),
    );
  }

  /// Convert to Drift Product entity
  Product toDrift() {
    return Product(
      id: id,
      name: name,
      barcode: barcode,
      category: category,
      supplierId: supplierId,
      sellPrice: sellPrice,
      costPrice: costPrice,
      qty: qty,
      trackImei: trackImei,
      imagePath: imagePath,
      createdAt: createdAt,
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? barcode,
    String? category,
    String? supplierId,
    int? sellPrice,
    int? costPrice,
    int? qty,
    bool? trackImei,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      supplierId: supplierId ?? this.supplierId,
      sellPrice: sellPrice ?? this.sellPrice,
      costPrice: costPrice ?? this.costPrice,
      qty: qty ?? this.qty,
      trackImei: trackImei ?? this.trackImei,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
