// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sellPriceMeta = const VerificationMeta(
    'sellPrice',
  );
  @override
  late final GeneratedColumn<int> sellPrice = GeneratedColumn<int>(
    'sell_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costPriceMeta = const VerificationMeta(
    'costPrice',
  );
  @override
  late final GeneratedColumn<int> costPrice = GeneratedColumn<int>(
    'cost_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackImeiMeta = const VerificationMeta(
    'trackImei',
  );
  @override
  late final GeneratedColumn<bool> trackImei = GeneratedColumn<bool>(
    'track_imei',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("track_imei" IN (0, 1))',
    ),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    barcode,
    category,
    supplierId,
    sellPrice,
    costPrice,
    qty,
    trackImei,
    imagePath,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('sell_price')) {
      context.handle(
        _sellPriceMeta,
        sellPrice.isAcceptableOrUnknown(data['sell_price']!, _sellPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_sellPriceMeta);
    }
    if (data.containsKey('cost_price')) {
      context.handle(
        _costPriceMeta,
        costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_costPriceMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('track_imei')) {
      context.handle(
        _trackImeiMeta,
        trackImei.isAcceptableOrUnknown(data['track_imei']!, _trackImeiMeta),
      );
    } else if (isInserting) {
      context.missing(_trackImeiMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      sellPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sell_price'],
      )!,
      costPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_price'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      trackImei: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}track_imei'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
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
  const Product({
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
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    map['sell_price'] = Variable<int>(sellPrice);
    map['cost_price'] = Variable<int>(costPrice);
    map['qty'] = Variable<int>(qty);
    map['track_imei'] = Variable<bool>(trackImei);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      category: Value(category),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      sellPrice: Value(sellPrice),
      costPrice: Value(costPrice),
      qty: Value(qty),
      trackImei: Value(trackImei),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      createdAt: Value(createdAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      category: serializer.fromJson<String>(json['category']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      sellPrice: serializer.fromJson<int>(json['sellPrice']),
      costPrice: serializer.fromJson<int>(json['costPrice']),
      qty: serializer.fromJson<int>(json['qty']),
      trackImei: serializer.fromJson<bool>(json['trackImei']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'barcode': serializer.toJson<String?>(barcode),
      'category': serializer.toJson<String>(category),
      'supplierId': serializer.toJson<String?>(supplierId),
      'sellPrice': serializer.toJson<int>(sellPrice),
      'costPrice': serializer.toJson<int>(costPrice),
      'qty': serializer.toJson<int>(qty),
      'trackImei': serializer.toJson<bool>(trackImei),
      'imagePath': serializer.toJson<String?>(imagePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    Value<String?> barcode = const Value.absent(),
    String? category,
    Value<String?> supplierId = const Value.absent(),
    int? sellPrice,
    int? costPrice,
    int? qty,
    bool? trackImei,
    Value<String?> imagePath = const Value.absent(),
    DateTime? createdAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    barcode: barcode.present ? barcode.value : this.barcode,
    category: category ?? this.category,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    sellPrice: sellPrice ?? this.sellPrice,
    costPrice: costPrice ?? this.costPrice,
    qty: qty ?? this.qty,
    trackImei: trackImei ?? this.trackImei,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    createdAt: createdAt ?? this.createdAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      category: data.category.present ? data.category.value : this.category,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      sellPrice: data.sellPrice.present ? data.sellPrice.value : this.sellPrice,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      qty: data.qty.present ? data.qty.value : this.qty,
      trackImei: data.trackImei.present ? data.trackImei.value : this.trackImei,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('category: $category, ')
          ..write('supplierId: $supplierId, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('qty: $qty, ')
          ..write('trackImei: $trackImei, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    barcode,
    category,
    supplierId,
    sellPrice,
    costPrice,
    qty,
    trackImei,
    imagePath,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.barcode == this.barcode &&
          other.category == this.category &&
          other.supplierId == this.supplierId &&
          other.sellPrice == this.sellPrice &&
          other.costPrice == this.costPrice &&
          other.qty == this.qty &&
          other.trackImei == this.trackImei &&
          other.imagePath == this.imagePath &&
          other.createdAt == this.createdAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> barcode;
  final Value<String> category;
  final Value<String?> supplierId;
  final Value<int> sellPrice;
  final Value<int> costPrice;
  final Value<int> qty;
  final Value<bool> trackImei;
  final Value<String?> imagePath;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.barcode = const Value.absent(),
    this.category = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.sellPrice = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.qty = const Value.absent(),
    this.trackImei = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String name,
    this.barcode = const Value.absent(),
    required String category,
    this.supplierId = const Value.absent(),
    required int sellPrice,
    required int costPrice,
    required int qty,
    required bool trackImei,
    this.imagePath = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       sellPrice = Value(sellPrice),
       costPrice = Value(costPrice),
       qty = Value(qty),
       trackImei = Value(trackImei),
       createdAt = Value(createdAt);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? barcode,
    Expression<String>? category,
    Expression<String>? supplierId,
    Expression<int>? sellPrice,
    Expression<int>? costPrice,
    Expression<int>? qty,
    Expression<bool>? trackImei,
    Expression<String>? imagePath,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (category != null) 'category': category,
      if (supplierId != null) 'supplier_id': supplierId,
      if (sellPrice != null) 'sell_price': sellPrice,
      if (costPrice != null) 'cost_price': costPrice,
      if (qty != null) 'qty': qty,
      if (trackImei != null) 'track_imei': trackImei,
      if (imagePath != null) 'image_path': imagePath,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? barcode,
    Value<String>? category,
    Value<String?>? supplierId,
    Value<int>? sellPrice,
    Value<int>? costPrice,
    Value<int>? qty,
    Value<bool>? trackImei,
    Value<String?>? imagePath,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (sellPrice.present) {
      map['sell_price'] = Variable<int>(sellPrice.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<int>(costPrice.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (trackImei.present) {
      map['track_imei'] = Variable<bool>(trackImei.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('category: $category, ')
          ..write('supplierId: $supplierId, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('qty: $qty, ')
          ..write('trackImei: $trackImei, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<int> balance = GeneratedColumn<int>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, phone, balance, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final String name;
  final String? phone;
  final int balance;
  final DateTime createdAt;
  const Customer({
    required this.id,
    required this.name,
    this.phone,
    required this.balance,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['balance'] = Variable<int>(balance);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      balance: Value(balance),
      createdAt: Value(createdAt),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      balance: serializer.fromJson<int>(json['balance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'balance': serializer.toJson<int>(balance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Customer copyWith({
    String? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    int? balance,
    DateTime? createdAt,
  }) => Customer(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    balance: balance ?? this.balance,
    createdAt: createdAt ?? this.createdAt,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      balance: data.balance.present ? data.balance.value : this.balance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('balance: $balance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, balance, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.balance == this.balance &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<int> balance;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.balance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String name,
    this.phone = const Value.absent(),
    this.balance = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<int>? balance,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (balance != null) 'balance': balance,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<int>? balance,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (balance.present) {
      map['balance'] = Variable<int>(balance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('balance: $balance, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    amount,
    direction,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final String id;
  final String customerId;
  final int amount;
  final String direction;
  final String? note;
  final DateTime createdAt;
  const Payment({
    required this.id,
    required this.customerId,
    required this.amount,
    required this.direction,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_id'] = Variable<String>(customerId);
    map['amount'] = Variable<int>(amount);
    map['direction'] = Variable<String>(direction);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      customerId: Value(customerId),
      amount: Value(amount),
      direction: Value(direction),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String>(json['customerId']),
      amount: serializer.fromJson<int>(json['amount']),
      direction: serializer.fromJson<String>(json['direction']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String>(customerId),
      'amount': serializer.toJson<int>(amount),
      'direction': serializer.toJson<String>(direction),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Payment copyWith({
    String? id,
    String? customerId,
    int? amount,
    String? direction,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => Payment(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    amount: amount ?? this.amount,
    direction: direction ?? this.direction,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      amount: data.amount.present ? data.amount.value : this.amount,
      direction: data.direction.present ? data.direction.value : this.direction,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('amount: $amount, ')
          ..write('direction: $direction, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, customerId, amount, direction, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.amount == this.amount &&
          other.direction == this.direction &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<String> id;
  final Value<String> customerId;
  final Value<int> amount;
  final Value<String> direction;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.amount = const Value.absent(),
    this.direction = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String id,
    required String customerId,
    required int amount,
    required String direction,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId),
       amount = Value(amount),
       direction = Value(direction),
       createdAt = Value(createdAt);
  static Insertable<Payment> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<int>? amount,
    Expression<String>? direction,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (amount != null) 'amount': amount,
      if (direction != null) 'direction': direction,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? customerId,
    Value<int>? amount,
    Value<String>? direction,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      amount: amount ?? this.amount,
      direction: direction ?? this.direction,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('amount: $amount, ')
          ..write('direction: $direction, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<int> paid = GeneratedColumn<int>(
    'paid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentTypeMeta = const VerificationMeta(
    'paymentType',
  );
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
    'payment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _reversedAtMeta = const VerificationMeta(
    'reversedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reversedAt = GeneratedColumn<DateTime>(
    'reversed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    total,
    discount,
    paid,
    paymentType,
    createdAt,
    status,
    reversedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    } else if (isInserting) {
      context.missing(_discountMeta);
    }
    if (data.containsKey('paid')) {
      context.handle(
        _paidMeta,
        paid.isAcceptableOrUnknown(data['paid']!, _paidMeta),
      );
    } else if (isInserting) {
      context.missing(_paidMeta);
    }
    if (data.containsKey('payment_type')) {
      context.handle(
        _paymentTypeMeta,
        paymentType.isAcceptableOrUnknown(
          data['payment_type']!,
          _paymentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('reversed_at')) {
      context.handle(
        _reversedAtMeta,
        reversedAt.isAcceptableOrUnknown(data['reversed_at']!, _reversedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount'],
      )!,
      paid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid'],
      )!,
      paymentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      reversedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reversed_at'],
      ),
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final String id;
  final String? customerId;
  final int total;
  final int discount;
  final int paid;
  final String paymentType;
  final DateTime createdAt;
  final String status;
  final DateTime? reversedAt;
  const Sale({
    required this.id,
    this.customerId,
    required this.total,
    required this.discount,
    required this.paid,
    required this.paymentType,
    required this.createdAt,
    required this.status,
    this.reversedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['total'] = Variable<int>(total);
    map['discount'] = Variable<int>(discount);
    map['paid'] = Variable<int>(paid);
    map['payment_type'] = Variable<String>(paymentType);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reversedAt != null) {
      map['reversed_at'] = Variable<DateTime>(reversedAt);
    }
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      total: Value(total),
      discount: Value(discount),
      paid: Value(paid),
      paymentType: Value(paymentType),
      createdAt: Value(createdAt),
      status: Value(status),
      reversedAt: reversedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reversedAt),
    );
  }

  factory Sale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      total: serializer.fromJson<int>(json['total']),
      discount: serializer.fromJson<int>(json['discount']),
      paid: serializer.fromJson<int>(json['paid']),
      paymentType: serializer.fromJson<String>(json['paymentType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      reversedAt: serializer.fromJson<DateTime?>(json['reversedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String?>(customerId),
      'total': serializer.toJson<int>(total),
      'discount': serializer.toJson<int>(discount),
      'paid': serializer.toJson<int>(paid),
      'paymentType': serializer.toJson<String>(paymentType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'reversedAt': serializer.toJson<DateTime?>(reversedAt),
    };
  }

  Sale copyWith({
    String? id,
    Value<String?> customerId = const Value.absent(),
    int? total,
    int? discount,
    int? paid,
    String? paymentType,
    DateTime? createdAt,
    String? status,
    Value<DateTime?> reversedAt = const Value.absent(),
  }) => Sale(
    id: id ?? this.id,
    customerId: customerId.present ? customerId.value : this.customerId,
    total: total ?? this.total,
    discount: discount ?? this.discount,
    paid: paid ?? this.paid,
    paymentType: paymentType ?? this.paymentType,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    reversedAt: reversedAt.present ? reversedAt.value : this.reversedAt,
  );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      total: data.total.present ? data.total.value : this.total,
      discount: data.discount.present ? data.discount.value : this.discount,
      paid: data.paid.present ? data.paid.value : this.paid,
      paymentType: data.paymentType.present
          ? data.paymentType.value
          : this.paymentType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      reversedAt: data.reversedAt.present
          ? data.reversedAt.value
          : this.reversedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('total: $total, ')
          ..write('discount: $discount, ')
          ..write('paid: $paid, ')
          ..write('paymentType: $paymentType, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    total,
    discount,
    paid,
    paymentType,
    createdAt,
    status,
    reversedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.total == this.total &&
          other.discount == this.discount &&
          other.paid == this.paid &&
          other.paymentType == this.paymentType &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.reversedAt == this.reversedAt);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<String> id;
  final Value<String?> customerId;
  final Value<int> total;
  final Value<int> discount;
  final Value<int> paid;
  final Value<String> paymentType;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<DateTime?> reversedAt;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.total = const Value.absent(),
    this.discount = const Value.absent(),
    this.paid = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    required String id,
    this.customerId = const Value.absent(),
    required int total,
    required int discount,
    required int paid,
    required String paymentType,
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       total = Value(total),
       discount = Value(discount),
       paid = Value(paid),
       paymentType = Value(paymentType),
       createdAt = Value(createdAt);
  static Insertable<Sale> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<int>? total,
    Expression<int>? discount,
    Expression<int>? paid,
    Expression<String>? paymentType,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<DateTime>? reversedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (total != null) 'total': total,
      if (discount != null) 'discount': discount,
      if (paid != null) 'paid': paid,
      if (paymentType != null) 'payment_type': paymentType,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (reversedAt != null) 'reversed_at': reversedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith({
    Value<String>? id,
    Value<String?>? customerId,
    Value<int>? total,
    Value<int>? discount,
    Value<int>? paid,
    Value<String>? paymentType,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<DateTime?>? reversedAt,
    Value<int>? rowid,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      total: total ?? this.total,
      discount: discount ?? this.discount,
      paid: paid ?? this.paid,
      paymentType: paymentType ?? this.paymentType,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      reversedAt: reversedAt ?? this.reversedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    if (paid.present) {
      map['paid'] = Variable<int>(paid.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reversedAt.present) {
      map['reversed_at'] = Variable<DateTime>(reversedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('total: $total, ')
          ..write('discount: $discount, ')
          ..write('paid: $paid, ')
          ..write('paymentType: $paymentType, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineTotalMeta = const VerificationMeta(
    'lineTotal',
  );
  @override
  late final GeneratedColumn<int> lineTotal = GeneratedColumn<int>(
    'line_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    productId,
    qty,
    unitPrice,
    lineTotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('line_total')) {
      context.handle(
        _lineTotalMeta,
        lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price'],
      )!,
      lineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_total'],
      )!,
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  final String id;
  final String saleId;
  final String productId;
  final int qty;
  final int unitPrice;
  final int lineTotal;
  const SaleItem({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['product_id'] = Variable<String>(productId);
    map['qty'] = Variable<int>(qty);
    map['unit_price'] = Variable<int>(unitPrice);
    map['line_total'] = Variable<int>(lineTotal);
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      qty: Value(qty),
      unitPrice: Value(unitPrice),
      lineTotal: Value(lineTotal),
    );
  }

  factory SaleItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String>(json['productId']),
      qty: serializer.fromJson<int>(json['qty']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      lineTotal: serializer.fromJson<int>(json['lineTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String>(productId),
      'qty': serializer.toJson<int>(qty),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'lineTotal': serializer.toJson<int>(lineTotal),
    };
  }

  SaleItem copyWith({
    String? id,
    String? saleId,
    String? productId,
    int? qty,
    int? unitPrice,
    int? lineTotal,
  }) => SaleItem(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    productId: productId ?? this.productId,
    qty: qty ?? this.qty,
    unitPrice: unitPrice ?? this.unitPrice,
    lineTotal: lineTotal ?? this.lineTotal,
  );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      qty: data.qty.present ? data.qty.value : this.qty,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('qty: $qty, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, saleId, productId, qty, unitPrice, lineTotal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.qty == this.qty &&
          other.unitPrice == this.unitPrice &&
          other.lineTotal == this.lineTotal);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> productId;
  final Value<int> qty;
  final Value<int> unitPrice;
  final Value<int> lineTotal;
  final Value<int> rowid;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.qty = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    required String id,
    required String saleId,
    required String productId,
    required int qty,
    required int unitPrice,
    required int lineTotal,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleId = Value(saleId),
       productId = Value(productId),
       qty = Value(qty),
       unitPrice = Value(unitPrice),
       lineTotal = Value(lineTotal);
  static Insertable<SaleItem> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<int>? qty,
    Expression<int>? unitPrice,
    Expression<int>? lineTotal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (qty != null) 'qty': qty,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (lineTotal != null) 'line_total': lineTotal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? saleId,
    Value<String>? productId,
    Value<int>? qty,
    Value<int>? unitPrice,
    Value<int>? lineTotal,
    Value<int>? rowid,
  }) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      qty: qty ?? this.qty,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<int>(lineTotal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('qty: $qty, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseInvoicesTable extends PurchaseInvoices
    with TableInfo<$PurchaseInvoicesTable, PurchaseInvoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseInvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierMeta = const VerificationMeta(
    'supplier',
  );
  @override
  late final GeneratedColumn<String> supplier = GeneratedColumn<String>(
    'supplier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceNumber,
    supplier,
    total,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseInvoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('supplier')) {
      context.handle(
        _supplierMeta,
        supplier.isAcceptableOrUnknown(data['supplier']!, _supplierMeta),
      );
    } else if (isInserting) {
      context.missing(_supplierMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseInvoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseInvoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      )!,
      supplier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PurchaseInvoicesTable createAlias(String alias) {
    return $PurchaseInvoicesTable(attachedDatabase, alias);
  }
}

class PurchaseInvoice extends DataClass implements Insertable<PurchaseInvoice> {
  final String id;
  final String invoiceNumber;
  final String supplier;
  final int total;
  final DateTime createdAt;
  const PurchaseInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.supplier,
    required this.total,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['supplier'] = Variable<String>(supplier);
    map['total'] = Variable<int>(total);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PurchaseInvoicesCompanion toCompanion(bool nullToAbsent) {
    return PurchaseInvoicesCompanion(
      id: Value(id),
      invoiceNumber: Value(invoiceNumber),
      supplier: Value(supplier),
      total: Value(total),
      createdAt: Value(createdAt),
    );
  }

  factory PurchaseInvoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseInvoice(
      id: serializer.fromJson<String>(json['id']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      supplier: serializer.fromJson<String>(json['supplier']),
      total: serializer.fromJson<int>(json['total']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'supplier': serializer.toJson<String>(supplier),
      'total': serializer.toJson<int>(total),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PurchaseInvoice copyWith({
    String? id,
    String? invoiceNumber,
    String? supplier,
    int? total,
    DateTime? createdAt,
  }) => PurchaseInvoice(
    id: id ?? this.id,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    supplier: supplier ?? this.supplier,
    total: total ?? this.total,
    createdAt: createdAt ?? this.createdAt,
  );
  PurchaseInvoice copyWithCompanion(PurchaseInvoicesCompanion data) {
    return PurchaseInvoice(
      id: data.id.present ? data.id.value : this.id,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      supplier: data.supplier.present ? data.supplier.value : this.supplier,
      total: data.total.present ? data.total.value : this.total,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseInvoice(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('supplier: $supplier, ')
          ..write('total: $total, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, invoiceNumber, supplier, total, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseInvoice &&
          other.id == this.id &&
          other.invoiceNumber == this.invoiceNumber &&
          other.supplier == this.supplier &&
          other.total == this.total &&
          other.createdAt == this.createdAt);
}

class PurchaseInvoicesCompanion extends UpdateCompanion<PurchaseInvoice> {
  final Value<String> id;
  final Value<String> invoiceNumber;
  final Value<String> supplier;
  final Value<int> total;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PurchaseInvoicesCompanion({
    this.id = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.supplier = const Value.absent(),
    this.total = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseInvoicesCompanion.insert({
    required String id,
    required String invoiceNumber,
    required String supplier,
    required int total,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       invoiceNumber = Value(invoiceNumber),
       supplier = Value(supplier),
       total = Value(total),
       createdAt = Value(createdAt);
  static Insertable<PurchaseInvoice> custom({
    Expression<String>? id,
    Expression<String>? invoiceNumber,
    Expression<String>? supplier,
    Expression<int>? total,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (supplier != null) 'supplier': supplier,
      if (total != null) 'total': total,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseInvoicesCompanion copyWith({
    Value<String>? id,
    Value<String>? invoiceNumber,
    Value<String>? supplier,
    Value<int>? total,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PurchaseInvoicesCompanion(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      supplier: supplier ?? this.supplier,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (supplier.present) {
      map['supplier'] = Variable<String>(supplier.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseInvoicesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('supplier: $supplier, ')
          ..write('total: $total, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseInvoiceItemsTable extends PurchaseInvoiceItems
    with TableInfo<$PurchaseInvoiceItemsTable, PurchaseInvoiceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseInvoiceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseInvoiceIdMeta = const VerificationMeta(
    'purchaseInvoiceId',
  );
  @override
  late final GeneratedColumn<String> purchaseInvoiceId =
      GeneratedColumn<String>(
        'purchase_invoice_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<int> purchasePrice = GeneratedColumn<int>(
    'purchase_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salePriceMeta = const VerificationMeta(
    'salePrice',
  );
  @override
  late final GeneratedColumn<int> salePrice = GeneratedColumn<int>(
    'sale_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineTotalMeta = const VerificationMeta(
    'lineTotal',
  );
  @override
  late final GeneratedColumn<int> lineTotal = GeneratedColumn<int>(
    'line_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseInvoiceId,
    productId,
    qty,
    purchasePrice,
    salePrice,
    lineTotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_invoice_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseInvoiceItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('purchase_invoice_id')) {
      context.handle(
        _purchaseInvoiceIdMeta,
        purchaseInvoiceId.isAcceptableOrUnknown(
          data['purchase_invoice_id']!,
          _purchaseInvoiceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseInvoiceIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasePriceMeta);
    }
    if (data.containsKey('sale_price')) {
      context.handle(
        _salePriceMeta,
        salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta),
      );
    } else if (isInserting) {
      context.missing(_salePriceMeta);
    }
    if (data.containsKey('line_total')) {
      context.handle(
        _lineTotalMeta,
        lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseInvoiceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseInvoiceItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      purchaseInvoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_invoice_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_price'],
      )!,
      salePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sale_price'],
      )!,
      lineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_total'],
      )!,
    );
  }

  @override
  $PurchaseInvoiceItemsTable createAlias(String alias) {
    return $PurchaseInvoiceItemsTable(attachedDatabase, alias);
  }
}

class PurchaseInvoiceItem extends DataClass
    implements Insertable<PurchaseInvoiceItem> {
  final String id;
  final String purchaseInvoiceId;
  final String productId;
  final int qty;
  final int purchasePrice;
  final int salePrice;
  final int lineTotal;
  const PurchaseInvoiceItem({
    required this.id,
    required this.purchaseInvoiceId,
    required this.productId,
    required this.qty,
    required this.purchasePrice,
    required this.salePrice,
    required this.lineTotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['purchase_invoice_id'] = Variable<String>(purchaseInvoiceId);
    map['product_id'] = Variable<String>(productId);
    map['qty'] = Variable<int>(qty);
    map['purchase_price'] = Variable<int>(purchasePrice);
    map['sale_price'] = Variable<int>(salePrice);
    map['line_total'] = Variable<int>(lineTotal);
    return map;
  }

  PurchaseInvoiceItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseInvoiceItemsCompanion(
      id: Value(id),
      purchaseInvoiceId: Value(purchaseInvoiceId),
      productId: Value(productId),
      qty: Value(qty),
      purchasePrice: Value(purchasePrice),
      salePrice: Value(salePrice),
      lineTotal: Value(lineTotal),
    );
  }

  factory PurchaseInvoiceItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseInvoiceItem(
      id: serializer.fromJson<String>(json['id']),
      purchaseInvoiceId: serializer.fromJson<String>(json['purchaseInvoiceId']),
      productId: serializer.fromJson<String>(json['productId']),
      qty: serializer.fromJson<int>(json['qty']),
      purchasePrice: serializer.fromJson<int>(json['purchasePrice']),
      salePrice: serializer.fromJson<int>(json['salePrice']),
      lineTotal: serializer.fromJson<int>(json['lineTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'purchaseInvoiceId': serializer.toJson<String>(purchaseInvoiceId),
      'productId': serializer.toJson<String>(productId),
      'qty': serializer.toJson<int>(qty),
      'purchasePrice': serializer.toJson<int>(purchasePrice),
      'salePrice': serializer.toJson<int>(salePrice),
      'lineTotal': serializer.toJson<int>(lineTotal),
    };
  }

  PurchaseInvoiceItem copyWith({
    String? id,
    String? purchaseInvoiceId,
    String? productId,
    int? qty,
    int? purchasePrice,
    int? salePrice,
    int? lineTotal,
  }) => PurchaseInvoiceItem(
    id: id ?? this.id,
    purchaseInvoiceId: purchaseInvoiceId ?? this.purchaseInvoiceId,
    productId: productId ?? this.productId,
    qty: qty ?? this.qty,
    purchasePrice: purchasePrice ?? this.purchasePrice,
    salePrice: salePrice ?? this.salePrice,
    lineTotal: lineTotal ?? this.lineTotal,
  );
  PurchaseInvoiceItem copyWithCompanion(PurchaseInvoiceItemsCompanion data) {
    return PurchaseInvoiceItem(
      id: data.id.present ? data.id.value : this.id,
      purchaseInvoiceId: data.purchaseInvoiceId.present
          ? data.purchaseInvoiceId.value
          : this.purchaseInvoiceId,
      productId: data.productId.present ? data.productId.value : this.productId,
      qty: data.qty.present ? data.qty.value : this.qty,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseInvoiceItem(')
          ..write('id: $id, ')
          ..write('purchaseInvoiceId: $purchaseInvoiceId, ')
          ..write('productId: $productId, ')
          ..write('qty: $qty, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('lineTotal: $lineTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    purchaseInvoiceId,
    productId,
    qty,
    purchasePrice,
    salePrice,
    lineTotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseInvoiceItem &&
          other.id == this.id &&
          other.purchaseInvoiceId == this.purchaseInvoiceId &&
          other.productId == this.productId &&
          other.qty == this.qty &&
          other.purchasePrice == this.purchasePrice &&
          other.salePrice == this.salePrice &&
          other.lineTotal == this.lineTotal);
}

class PurchaseInvoiceItemsCompanion
    extends UpdateCompanion<PurchaseInvoiceItem> {
  final Value<String> id;
  final Value<String> purchaseInvoiceId;
  final Value<String> productId;
  final Value<int> qty;
  final Value<int> purchasePrice;
  final Value<int> salePrice;
  final Value<int> lineTotal;
  final Value<int> rowid;
  const PurchaseInvoiceItemsCompanion({
    this.id = const Value.absent(),
    this.purchaseInvoiceId = const Value.absent(),
    this.productId = const Value.absent(),
    this.qty = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseInvoiceItemsCompanion.insert({
    required String id,
    required String purchaseInvoiceId,
    required String productId,
    required int qty,
    required int purchasePrice,
    required int salePrice,
    required int lineTotal,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       purchaseInvoiceId = Value(purchaseInvoiceId),
       productId = Value(productId),
       qty = Value(qty),
       purchasePrice = Value(purchasePrice),
       salePrice = Value(salePrice),
       lineTotal = Value(lineTotal);
  static Insertable<PurchaseInvoiceItem> custom({
    Expression<String>? id,
    Expression<String>? purchaseInvoiceId,
    Expression<String>? productId,
    Expression<int>? qty,
    Expression<int>? purchasePrice,
    Expression<int>? salePrice,
    Expression<int>? lineTotal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseInvoiceId != null) 'purchase_invoice_id': purchaseInvoiceId,
      if (productId != null) 'product_id': productId,
      if (qty != null) 'qty': qty,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (salePrice != null) 'sale_price': salePrice,
      if (lineTotal != null) 'line_total': lineTotal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseInvoiceItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? purchaseInvoiceId,
    Value<String>? productId,
    Value<int>? qty,
    Value<int>? purchasePrice,
    Value<int>? salePrice,
    Value<int>? lineTotal,
    Value<int>? rowid,
  }) {
    return PurchaseInvoiceItemsCompanion(
      id: id ?? this.id,
      purchaseInvoiceId: purchaseInvoiceId ?? this.purchaseInvoiceId,
      productId: productId ?? this.productId,
      qty: qty ?? this.qty,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      lineTotal: lineTotal ?? this.lineTotal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (purchaseInvoiceId.present) {
      map['purchase_invoice_id'] = Variable<String>(purchaseInvoiceId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<int>(purchasePrice.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<int>(salePrice.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<int>(lineTotal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseInvoiceItemsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseInvoiceId: $purchaseInvoiceId, ')
          ..write('productId: $productId, ')
          ..write('qty: $qty, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, phone, address, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final String id;
  final String name;
  final String? phone;
  final String? address;
  final DateTime createdAt;
  const Supplier({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      createdAt: Value(createdAt),
    );
  }

  factory Supplier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Supplier copyWith({
    String? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    DateTime? createdAt,
  }) => Supplier(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    createdAt: createdAt ?? this.createdAt,
  );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, address, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.createdAt == this.createdAt);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SuppliersCompanion.insert({
    required String id,
    required String name,
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Supplier> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SuppliersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? address,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, Purchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<int> paid = GeneratedColumn<int>(
    'paid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    supplierId,
    invoiceNumber,
    total,
    paid,
    discount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<Purchase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('paid')) {
      context.handle(
        _paidMeta,
        paid.isAcceptableOrUnknown(data['paid']!, _paidMeta),
      );
    } else if (isInserting) {
      context.missing(_paidMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Purchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Purchase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      ),
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      paid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }
}

class Purchase extends DataClass implements Insertable<Purchase> {
  final String id;
  final String? supplierId;
  final String? invoiceNumber;
  final int total;
  final int paid;
  final int discount;
  final DateTime createdAt;
  const Purchase({
    required this.id,
    this.supplierId,
    this.invoiceNumber,
    required this.total,
    required this.paid,
    required this.discount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    if (!nullToAbsent || invoiceNumber != null) {
      map['invoice_number'] = Variable<String>(invoiceNumber);
    }
    map['total'] = Variable<int>(total);
    map['paid'] = Variable<int>(paid);
    map['discount'] = Variable<int>(discount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      invoiceNumber: invoiceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceNumber),
      total: Value(total),
      paid: Value(paid),
      discount: Value(discount),
      createdAt: Value(createdAt),
    );
  }

  factory Purchase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Purchase(
      id: serializer.fromJson<String>(json['id']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      invoiceNumber: serializer.fromJson<String?>(json['invoiceNumber']),
      total: serializer.fromJson<int>(json['total']),
      paid: serializer.fromJson<int>(json['paid']),
      discount: serializer.fromJson<int>(json['discount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'supplierId': serializer.toJson<String?>(supplierId),
      'invoiceNumber': serializer.toJson<String?>(invoiceNumber),
      'total': serializer.toJson<int>(total),
      'paid': serializer.toJson<int>(paid),
      'discount': serializer.toJson<int>(discount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Purchase copyWith({
    String? id,
    Value<String?> supplierId = const Value.absent(),
    Value<String?> invoiceNumber = const Value.absent(),
    int? total,
    int? paid,
    int? discount,
    DateTime? createdAt,
  }) => Purchase(
    id: id ?? this.id,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    invoiceNumber: invoiceNumber.present
        ? invoiceNumber.value
        : this.invoiceNumber,
    total: total ?? this.total,
    paid: paid ?? this.paid,
    discount: discount ?? this.discount,
    createdAt: createdAt ?? this.createdAt,
  );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      total: data.total.present ? data.total.value : this.total,
      paid: data.paid.present ? data.paid.value : this.paid,
      discount: data.discount.present ? data.discount.value : this.discount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Purchase(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('total: $total, ')
          ..write('paid: $paid, ')
          ..write('discount: $discount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    supplierId,
    invoiceNumber,
    total,
    paid,
    discount,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.invoiceNumber == this.invoiceNumber &&
          other.total == this.total &&
          other.paid == this.paid &&
          other.discount == this.discount &&
          other.createdAt == this.createdAt);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<String> id;
  final Value<String?> supplierId;
  final Value<String?> invoiceNumber;
  final Value<int> total;
  final Value<int> paid;
  final Value<int> discount;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.total = const Value.absent(),
    this.paid = const Value.absent(),
    this.discount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchasesCompanion.insert({
    required String id,
    this.supplierId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    required int total,
    required int paid,
    this.discount = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       total = Value(total),
       paid = Value(paid),
       createdAt = Value(createdAt);
  static Insertable<Purchase> custom({
    Expression<String>? id,
    Expression<String>? supplierId,
    Expression<String>? invoiceNumber,
    Expression<int>? total,
    Expression<int>? paid,
    Expression<int>? discount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (total != null) 'total': total,
      if (paid != null) 'paid': paid,
      if (discount != null) 'discount': discount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchasesCompanion copyWith({
    Value<String>? id,
    Value<String?>? supplierId,
    Value<String?>? invoiceNumber,
    Value<int>? total,
    Value<int>? paid,
    Value<int>? discount,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PurchasesCompanion(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      total: total ?? this.total,
      paid: paid ?? this.paid,
      discount: discount ?? this.discount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (paid.present) {
      map['paid'] = Variable<int>(paid.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('total: $total, ')
          ..write('paid: $paid, ')
          ..write('discount: $discount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseItemsTable extends PurchaseItems
    with TableInfo<$PurchaseItemsTable, PurchaseItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
    'purchase_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostMeta = const VerificationMeta(
    'unitCost',
  );
  @override
  late final GeneratedColumn<int> unitCost = GeneratedColumn<int>(
    'unit_cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineTotalMeta = const VerificationMeta(
    'lineTotal',
  );
  @override
  late final GeneratedColumn<int> lineTotal = GeneratedColumn<int>(
    'line_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseId,
    productId,
    qty,
    unitCost,
    lineTotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('unit_cost')) {
      context.handle(
        _unitCostMeta,
        unitCost.isAcceptableOrUnknown(data['unit_cost']!, _unitCostMeta),
      );
    } else if (isInserting) {
      context.missing(_unitCostMeta);
    }
    if (data.containsKey('line_total')) {
      context.handle(
        _lineTotalMeta,
        lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      unitCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost'],
      )!,
      lineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_total'],
      )!,
    );
  }

  @override
  $PurchaseItemsTable createAlias(String alias) {
    return $PurchaseItemsTable(attachedDatabase, alias);
  }
}

class PurchaseItem extends DataClass implements Insertable<PurchaseItem> {
  final String id;
  final String purchaseId;
  final String productId;
  final int qty;
  final int unitCost;
  final int lineTotal;
  const PurchaseItem({
    required this.id,
    required this.purchaseId,
    required this.productId,
    required this.qty,
    required this.unitCost,
    required this.lineTotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['purchase_id'] = Variable<String>(purchaseId);
    map['product_id'] = Variable<String>(productId);
    map['qty'] = Variable<int>(qty);
    map['unit_cost'] = Variable<int>(unitCost);
    map['line_total'] = Variable<int>(lineTotal);
    return map;
  }

  PurchaseItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseItemsCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      productId: Value(productId),
      qty: Value(qty),
      unitCost: Value(unitCost),
      lineTotal: Value(lineTotal),
    );
  }

  factory PurchaseItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseItem(
      id: serializer.fromJson<String>(json['id']),
      purchaseId: serializer.fromJson<String>(json['purchaseId']),
      productId: serializer.fromJson<String>(json['productId']),
      qty: serializer.fromJson<int>(json['qty']),
      unitCost: serializer.fromJson<int>(json['unitCost']),
      lineTotal: serializer.fromJson<int>(json['lineTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'purchaseId': serializer.toJson<String>(purchaseId),
      'productId': serializer.toJson<String>(productId),
      'qty': serializer.toJson<int>(qty),
      'unitCost': serializer.toJson<int>(unitCost),
      'lineTotal': serializer.toJson<int>(lineTotal),
    };
  }

  PurchaseItem copyWith({
    String? id,
    String? purchaseId,
    String? productId,
    int? qty,
    int? unitCost,
    int? lineTotal,
  }) => PurchaseItem(
    id: id ?? this.id,
    purchaseId: purchaseId ?? this.purchaseId,
    productId: productId ?? this.productId,
    qty: qty ?? this.qty,
    unitCost: unitCost ?? this.unitCost,
    lineTotal: lineTotal ?? this.lineTotal,
  );
  PurchaseItem copyWithCompanion(PurchaseItemsCompanion data) {
    return PurchaseItem(
      id: data.id.present ? data.id.value : this.id,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      productId: data.productId.present ? data.productId.value : this.productId,
      qty: data.qty.present ? data.qty.value : this.qty,
      unitCost: data.unitCost.present ? data.unitCost.value : this.unitCost,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItem(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('qty: $qty, ')
          ..write('unitCost: $unitCost, ')
          ..write('lineTotal: $lineTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, purchaseId, productId, qty, unitCost, lineTotal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItem &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.productId == this.productId &&
          other.qty == this.qty &&
          other.unitCost == this.unitCost &&
          other.lineTotal == this.lineTotal);
}

class PurchaseItemsCompanion extends UpdateCompanion<PurchaseItem> {
  final Value<String> id;
  final Value<String> purchaseId;
  final Value<String> productId;
  final Value<int> qty;
  final Value<int> unitCost;
  final Value<int> lineTotal;
  final Value<int> rowid;
  const PurchaseItemsCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.productId = const Value.absent(),
    this.qty = const Value.absent(),
    this.unitCost = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseItemsCompanion.insert({
    required String id,
    required String purchaseId,
    required String productId,
    required int qty,
    required int unitCost,
    required int lineTotal,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       purchaseId = Value(purchaseId),
       productId = Value(productId),
       qty = Value(qty),
       unitCost = Value(unitCost),
       lineTotal = Value(lineTotal);
  static Insertable<PurchaseItem> custom({
    Expression<String>? id,
    Expression<String>? purchaseId,
    Expression<String>? productId,
    Expression<int>? qty,
    Expression<int>? unitCost,
    Expression<int>? lineTotal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (productId != null) 'product_id': productId,
      if (qty != null) 'qty': qty,
      if (unitCost != null) 'unit_cost': unitCost,
      if (lineTotal != null) 'line_total': lineTotal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? purchaseId,
    Value<String>? productId,
    Value<int>? qty,
    Value<int>? unitCost,
    Value<int>? lineTotal,
    Value<int>? rowid,
  }) {
    return PurchaseItemsCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      productId: productId ?? this.productId,
      qty: qty ?? this.qty,
      unitCost: unitCost ?? this.unitCost,
      lineTotal: lineTotal ?? this.lineTotal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (unitCost.present) {
      map['unit_cost'] = Variable<int>(unitCost.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<int>(lineTotal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('qty: $qty, ')
          ..write('unitCost: $unitCost, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchasePaymentsTable extends PurchasePayments
    with TableInfo<$PurchasePaymentsTable, PurchasePayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasePaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
    'purchase_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseId,
    supplierId,
    amount,
    discount,
    description,
    paymentDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchasePayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchasePayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchasePayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_id'],
      ),
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PurchasePaymentsTable createAlias(String alias) {
    return $PurchasePaymentsTable(attachedDatabase, alias);
  }
}

class PurchasePayment extends DataClass implements Insertable<PurchasePayment> {
  final String id;
  final String? purchaseId;
  final String supplierId;
  final int amount;
  final int discount;
  final String? description;
  final DateTime paymentDate;
  final DateTime createdAt;
  const PurchasePayment({
    required this.id,
    this.purchaseId,
    required this.supplierId,
    required this.amount,
    required this.discount,
    this.description,
    required this.paymentDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || purchaseId != null) {
      map['purchase_id'] = Variable<String>(purchaseId);
    }
    map['supplier_id'] = Variable<String>(supplierId);
    map['amount'] = Variable<int>(amount);
    map['discount'] = Variable<int>(discount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['payment_date'] = Variable<DateTime>(paymentDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PurchasePaymentsCompanion toCompanion(bool nullToAbsent) {
    return PurchasePaymentsCompanion(
      id: Value(id),
      purchaseId: purchaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseId),
      supplierId: Value(supplierId),
      amount: Value(amount),
      discount: Value(discount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      paymentDate: Value(paymentDate),
      createdAt: Value(createdAt),
    );
  }

  factory PurchasePayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchasePayment(
      id: serializer.fromJson<String>(json['id']),
      purchaseId: serializer.fromJson<String?>(json['purchaseId']),
      supplierId: serializer.fromJson<String>(json['supplierId']),
      amount: serializer.fromJson<int>(json['amount']),
      discount: serializer.fromJson<int>(json['discount']),
      description: serializer.fromJson<String?>(json['description']),
      paymentDate: serializer.fromJson<DateTime>(json['paymentDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'purchaseId': serializer.toJson<String?>(purchaseId),
      'supplierId': serializer.toJson<String>(supplierId),
      'amount': serializer.toJson<int>(amount),
      'discount': serializer.toJson<int>(discount),
      'description': serializer.toJson<String?>(description),
      'paymentDate': serializer.toJson<DateTime>(paymentDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PurchasePayment copyWith({
    String? id,
    Value<String?> purchaseId = const Value.absent(),
    String? supplierId,
    int? amount,
    int? discount,
    Value<String?> description = const Value.absent(),
    DateTime? paymentDate,
    DateTime? createdAt,
  }) => PurchasePayment(
    id: id ?? this.id,
    purchaseId: purchaseId.present ? purchaseId.value : this.purchaseId,
    supplierId: supplierId ?? this.supplierId,
    amount: amount ?? this.amount,
    discount: discount ?? this.discount,
    description: description.present ? description.value : this.description,
    paymentDate: paymentDate ?? this.paymentDate,
    createdAt: createdAt ?? this.createdAt,
  );
  PurchasePayment copyWithCompanion(PurchasePaymentsCompanion data) {
    return PurchasePayment(
      id: data.id.present ? data.id.value : this.id,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      amount: data.amount.present ? data.amount.value : this.amount,
      discount: data.discount.present ? data.discount.value : this.discount,
      description: data.description.present
          ? data.description.value
          : this.description,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchasePayment(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('supplierId: $supplierId, ')
          ..write('amount: $amount, ')
          ..write('discount: $discount, ')
          ..write('description: $description, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    purchaseId,
    supplierId,
    amount,
    discount,
    description,
    paymentDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchasePayment &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.supplierId == this.supplierId &&
          other.amount == this.amount &&
          other.discount == this.discount &&
          other.description == this.description &&
          other.paymentDate == this.paymentDate &&
          other.createdAt == this.createdAt);
}

class PurchasePaymentsCompanion extends UpdateCompanion<PurchasePayment> {
  final Value<String> id;
  final Value<String?> purchaseId;
  final Value<String> supplierId;
  final Value<int> amount;
  final Value<int> discount;
  final Value<String?> description;
  final Value<DateTime> paymentDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PurchasePaymentsCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.amount = const Value.absent(),
    this.discount = const Value.absent(),
    this.description = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchasePaymentsCompanion.insert({
    required String id,
    this.purchaseId = const Value.absent(),
    required String supplierId,
    required int amount,
    this.discount = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime paymentDate,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       supplierId = Value(supplierId),
       amount = Value(amount),
       paymentDate = Value(paymentDate),
       createdAt = Value(createdAt);
  static Insertable<PurchasePayment> custom({
    Expression<String>? id,
    Expression<String>? purchaseId,
    Expression<String>? supplierId,
    Expression<int>? amount,
    Expression<int>? discount,
    Expression<String>? description,
    Expression<DateTime>? paymentDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (amount != null) 'amount': amount,
      if (discount != null) 'discount': discount,
      if (description != null) 'description': description,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchasePaymentsCompanion copyWith({
    Value<String>? id,
    Value<String?>? purchaseId,
    Value<String>? supplierId,
    Value<int>? amount,
    Value<int>? discount,
    Value<String?>? description,
    Value<DateTime>? paymentDate,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PurchasePaymentsCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      supplierId: supplierId ?? this.supplierId,
      amount: amount ?? this.amount,
      discount: discount ?? this.discount,
      description: description ?? this.description,
      paymentDate: paymentDate ?? this.paymentDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasePaymentsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('supplierId: $supplierId, ')
          ..write('amount: $amount, ')
          ..write('discount: $discount, ')
          ..write('description: $description, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RepairsTable extends Repairs with TableInfo<$RepairsTable, Repair> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepairsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerPhoneMeta = const VerificationMeta(
    'customerPhone',
  );
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
    'customer_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceMeta = const VerificationMeta('device');
  @override
  late final GeneratedColumn<String> device = GeneratedColumn<String>(
    'device',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imeiMeta = const VerificationMeta('imei');
  @override
  late final GeneratedColumn<String> imei = GeneratedColumn<String>(
    'imei',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _issueMeta = const VerificationMeta('issue');
  @override
  late final GeneratedColumn<String> issue = GeneratedColumn<String>(
    'issue',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedCostMeta = const VerificationMeta(
    'estimatedCost',
  );
  @override
  late final GeneratedColumn<int> estimatedCost = GeneratedColumn<int>(
    'estimated_cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _finalCostMeta = const VerificationMeta(
    'finalCost',
  );
  @override
  late final GeneratedColumn<int> finalCost = GeneratedColumn<int>(
    'final_cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paidAtReceiveMeta = const VerificationMeta(
    'paidAtReceive',
  );
  @override
  late final GeneratedColumn<int> paidAtReceive = GeneratedColumn<int>(
    'paid_at_receive',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paidAtDeliveryMeta = const VerificationMeta(
    'paidAtDelivery',
  );
  @override
  late final GeneratedColumn<int> paidAtDelivery = GeneratedColumn<int>(
    'paid_at_delivery',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalPaidMeta = const VerificationMeta(
    'totalPaid',
  );
  @override
  late final GeneratedColumn<int> totalPaid = GeneratedColumn<int>(
    'total_paid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionStatusMeta = const VerificationMeta(
    'transactionStatus',
  );
  @override
  late final GeneratedColumn<String> transactionStatus =
      GeneratedColumn<String>(
        'transaction_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('normal'),
      );
  static const VerificationMeta _reversedAtMeta = const VerificationMeta(
    'reversedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reversedAt = GeneratedColumn<DateTime>(
    'reversed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    customerName,
    customerPhone,
    device,
    model,
    imei,
    issue,
    status,
    estimatedCost,
    finalCost,
    discount,
    paidAtReceive,
    paidAtDelivery,
    totalPaid,
    createdAt,
    updatedAt,
    transactionStatus,
    reversedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repairs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Repair> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
        _customerPhoneMeta,
        customerPhone.isAcceptableOrUnknown(
          data['customer_phone']!,
          _customerPhoneMeta,
        ),
      );
    }
    if (data.containsKey('device')) {
      context.handle(
        _deviceMeta,
        device.isAcceptableOrUnknown(data['device']!, _deviceMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('imei')) {
      context.handle(
        _imeiMeta,
        imei.isAcceptableOrUnknown(data['imei']!, _imeiMeta),
      );
    }
    if (data.containsKey('issue')) {
      context.handle(
        _issueMeta,
        issue.isAcceptableOrUnknown(data['issue']!, _issueMeta),
      );
    } else if (isInserting) {
      context.missing(_issueMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('estimated_cost')) {
      context.handle(
        _estimatedCostMeta,
        estimatedCost.isAcceptableOrUnknown(
          data['estimated_cost']!,
          _estimatedCostMeta,
        ),
      );
    }
    if (data.containsKey('final_cost')) {
      context.handle(
        _finalCostMeta,
        finalCost.isAcceptableOrUnknown(data['final_cost']!, _finalCostMeta),
      );
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('paid_at_receive')) {
      context.handle(
        _paidAtReceiveMeta,
        paidAtReceive.isAcceptableOrUnknown(
          data['paid_at_receive']!,
          _paidAtReceiveMeta,
        ),
      );
    }
    if (data.containsKey('paid_at_delivery')) {
      context.handle(
        _paidAtDeliveryMeta,
        paidAtDelivery.isAcceptableOrUnknown(
          data['paid_at_delivery']!,
          _paidAtDeliveryMeta,
        ),
      );
    }
    if (data.containsKey('total_paid')) {
      context.handle(
        _totalPaidMeta,
        totalPaid.isAcceptableOrUnknown(data['total_paid']!, _totalPaidMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('transaction_status')) {
      context.handle(
        _transactionStatusMeta,
        transactionStatus.isAcceptableOrUnknown(
          data['transaction_status']!,
          _transactionStatusMeta,
        ),
      );
    }
    if (data.containsKey('reversed_at')) {
      context.handle(
        _reversedAtMeta,
        reversedAt.isAcceptableOrUnknown(data['reversed_at']!, _reversedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Repair map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Repair(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      customerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_phone'],
      ),
      device: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      imei: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imei'],
      ),
      issue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}issue'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      estimatedCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_cost'],
      )!,
      finalCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}final_cost'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount'],
      )!,
      paidAtReceive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_at_receive'],
      )!,
      paidAtDelivery: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_at_delivery'],
      )!,
      totalPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_paid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      transactionStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_status'],
      )!,
      reversedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reversed_at'],
      ),
    );
  }

  @override
  $RepairsTable createAlias(String alias) {
    return $RepairsTable(attachedDatabase, alias);
  }
}

class Repair extends DataClass implements Insertable<Repair> {
  final String id;
  final String? customerId;
  final String customerName;
  final String? customerPhone;
  final String device;
  final String? model;
  final String? imei;
  final String issue;
  final String status;
  final int estimatedCost;
  final int finalCost;
  final int discount;
  final int paidAtReceive;
  final int paidAtDelivery;
  final int totalPaid;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String transactionStatus;
  final DateTime? reversedAt;
  const Repair({
    required this.id,
    this.customerId,
    required this.customerName,
    this.customerPhone,
    required this.device,
    this.model,
    this.imei,
    required this.issue,
    required this.status,
    required this.estimatedCost,
    required this.finalCost,
    required this.discount,
    required this.paidAtReceive,
    required this.paidAtDelivery,
    required this.totalPaid,
    required this.createdAt,
    required this.updatedAt,
    required this.transactionStatus,
    this.reversedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    map['device'] = Variable<String>(device);
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || imei != null) {
      map['imei'] = Variable<String>(imei);
    }
    map['issue'] = Variable<String>(issue);
    map['status'] = Variable<String>(status);
    map['estimated_cost'] = Variable<int>(estimatedCost);
    map['final_cost'] = Variable<int>(finalCost);
    map['discount'] = Variable<int>(discount);
    map['paid_at_receive'] = Variable<int>(paidAtReceive);
    map['paid_at_delivery'] = Variable<int>(paidAtDelivery);
    map['total_paid'] = Variable<int>(totalPaid);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['transaction_status'] = Variable<String>(transactionStatus);
    if (!nullToAbsent || reversedAt != null) {
      map['reversed_at'] = Variable<DateTime>(reversedAt);
    }
    return map;
  }

  RepairsCompanion toCompanion(bool nullToAbsent) {
    return RepairsCompanion(
      id: Value(id),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      customerName: Value(customerName),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      device: Value(device),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      imei: imei == null && nullToAbsent ? const Value.absent() : Value(imei),
      issue: Value(issue),
      status: Value(status),
      estimatedCost: Value(estimatedCost),
      finalCost: Value(finalCost),
      discount: Value(discount),
      paidAtReceive: Value(paidAtReceive),
      paidAtDelivery: Value(paidAtDelivery),
      totalPaid: Value(totalPaid),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      transactionStatus: Value(transactionStatus),
      reversedAt: reversedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reversedAt),
    );
  }

  factory Repair.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Repair(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      device: serializer.fromJson<String>(json['device']),
      model: serializer.fromJson<String?>(json['model']),
      imei: serializer.fromJson<String?>(json['imei']),
      issue: serializer.fromJson<String>(json['issue']),
      status: serializer.fromJson<String>(json['status']),
      estimatedCost: serializer.fromJson<int>(json['estimatedCost']),
      finalCost: serializer.fromJson<int>(json['finalCost']),
      discount: serializer.fromJson<int>(json['discount']),
      paidAtReceive: serializer.fromJson<int>(json['paidAtReceive']),
      paidAtDelivery: serializer.fromJson<int>(json['paidAtDelivery']),
      totalPaid: serializer.fromJson<int>(json['totalPaid']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      transactionStatus: serializer.fromJson<String>(json['transactionStatus']),
      reversedAt: serializer.fromJson<DateTime?>(json['reversedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String?>(customerId),
      'customerName': serializer.toJson<String>(customerName),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'device': serializer.toJson<String>(device),
      'model': serializer.toJson<String?>(model),
      'imei': serializer.toJson<String?>(imei),
      'issue': serializer.toJson<String>(issue),
      'status': serializer.toJson<String>(status),
      'estimatedCost': serializer.toJson<int>(estimatedCost),
      'finalCost': serializer.toJson<int>(finalCost),
      'discount': serializer.toJson<int>(discount),
      'paidAtReceive': serializer.toJson<int>(paidAtReceive),
      'paidAtDelivery': serializer.toJson<int>(paidAtDelivery),
      'totalPaid': serializer.toJson<int>(totalPaid),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'transactionStatus': serializer.toJson<String>(transactionStatus),
      'reversedAt': serializer.toJson<DateTime?>(reversedAt),
    };
  }

  Repair copyWith({
    String? id,
    Value<String?> customerId = const Value.absent(),
    String? customerName,
    Value<String?> customerPhone = const Value.absent(),
    String? device,
    Value<String?> model = const Value.absent(),
    Value<String?> imei = const Value.absent(),
    String? issue,
    String? status,
    int? estimatedCost,
    int? finalCost,
    int? discount,
    int? paidAtReceive,
    int? paidAtDelivery,
    int? totalPaid,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? transactionStatus,
    Value<DateTime?> reversedAt = const Value.absent(),
  }) => Repair(
    id: id ?? this.id,
    customerId: customerId.present ? customerId.value : this.customerId,
    customerName: customerName ?? this.customerName,
    customerPhone: customerPhone.present
        ? customerPhone.value
        : this.customerPhone,
    device: device ?? this.device,
    model: model.present ? model.value : this.model,
    imei: imei.present ? imei.value : this.imei,
    issue: issue ?? this.issue,
    status: status ?? this.status,
    estimatedCost: estimatedCost ?? this.estimatedCost,
    finalCost: finalCost ?? this.finalCost,
    discount: discount ?? this.discount,
    paidAtReceive: paidAtReceive ?? this.paidAtReceive,
    paidAtDelivery: paidAtDelivery ?? this.paidAtDelivery,
    totalPaid: totalPaid ?? this.totalPaid,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    transactionStatus: transactionStatus ?? this.transactionStatus,
    reversedAt: reversedAt.present ? reversedAt.value : this.reversedAt,
  );
  Repair copyWithCompanion(RepairsCompanion data) {
    return Repair(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      device: data.device.present ? data.device.value : this.device,
      model: data.model.present ? data.model.value : this.model,
      imei: data.imei.present ? data.imei.value : this.imei,
      issue: data.issue.present ? data.issue.value : this.issue,
      status: data.status.present ? data.status.value : this.status,
      estimatedCost: data.estimatedCost.present
          ? data.estimatedCost.value
          : this.estimatedCost,
      finalCost: data.finalCost.present ? data.finalCost.value : this.finalCost,
      discount: data.discount.present ? data.discount.value : this.discount,
      paidAtReceive: data.paidAtReceive.present
          ? data.paidAtReceive.value
          : this.paidAtReceive,
      paidAtDelivery: data.paidAtDelivery.present
          ? data.paidAtDelivery.value
          : this.paidAtDelivery,
      totalPaid: data.totalPaid.present ? data.totalPaid.value : this.totalPaid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      transactionStatus: data.transactionStatus.present
          ? data.transactionStatus.value
          : this.transactionStatus,
      reversedAt: data.reversedAt.present
          ? data.reversedAt.value
          : this.reversedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Repair(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('device: $device, ')
          ..write('model: $model, ')
          ..write('imei: $imei, ')
          ..write('issue: $issue, ')
          ..write('status: $status, ')
          ..write('estimatedCost: $estimatedCost, ')
          ..write('finalCost: $finalCost, ')
          ..write('discount: $discount, ')
          ..write('paidAtReceive: $paidAtReceive, ')
          ..write('paidAtDelivery: $paidAtDelivery, ')
          ..write('totalPaid: $totalPaid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('transactionStatus: $transactionStatus, ')
          ..write('reversedAt: $reversedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    customerName,
    customerPhone,
    device,
    model,
    imei,
    issue,
    status,
    estimatedCost,
    finalCost,
    discount,
    paidAtReceive,
    paidAtDelivery,
    totalPaid,
    createdAt,
    updatedAt,
    transactionStatus,
    reversedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Repair &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.device == this.device &&
          other.model == this.model &&
          other.imei == this.imei &&
          other.issue == this.issue &&
          other.status == this.status &&
          other.estimatedCost == this.estimatedCost &&
          other.finalCost == this.finalCost &&
          other.discount == this.discount &&
          other.paidAtReceive == this.paidAtReceive &&
          other.paidAtDelivery == this.paidAtDelivery &&
          other.totalPaid == this.totalPaid &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.transactionStatus == this.transactionStatus &&
          other.reversedAt == this.reversedAt);
}

class RepairsCompanion extends UpdateCompanion<Repair> {
  final Value<String> id;
  final Value<String?> customerId;
  final Value<String> customerName;
  final Value<String?> customerPhone;
  final Value<String> device;
  final Value<String?> model;
  final Value<String?> imei;
  final Value<String> issue;
  final Value<String> status;
  final Value<int> estimatedCost;
  final Value<int> finalCost;
  final Value<int> discount;
  final Value<int> paidAtReceive;
  final Value<int> paidAtDelivery;
  final Value<int> totalPaid;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> transactionStatus;
  final Value<DateTime?> reversedAt;
  final Value<int> rowid;
  const RepairsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.device = const Value.absent(),
    this.model = const Value.absent(),
    this.imei = const Value.absent(),
    this.issue = const Value.absent(),
    this.status = const Value.absent(),
    this.estimatedCost = const Value.absent(),
    this.finalCost = const Value.absent(),
    this.discount = const Value.absent(),
    this.paidAtReceive = const Value.absent(),
    this.paidAtDelivery = const Value.absent(),
    this.totalPaid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.transactionStatus = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepairsCompanion.insert({
    required String id,
    this.customerId = const Value.absent(),
    required String customerName,
    this.customerPhone = const Value.absent(),
    required String device,
    this.model = const Value.absent(),
    this.imei = const Value.absent(),
    required String issue,
    required String status,
    this.estimatedCost = const Value.absent(),
    this.finalCost = const Value.absent(),
    this.discount = const Value.absent(),
    this.paidAtReceive = const Value.absent(),
    this.paidAtDelivery = const Value.absent(),
    this.totalPaid = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.transactionStatus = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerName = Value(customerName),
       device = Value(device),
       issue = Value(issue),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Repair> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<String>? device,
    Expression<String>? model,
    Expression<String>? imei,
    Expression<String>? issue,
    Expression<String>? status,
    Expression<int>? estimatedCost,
    Expression<int>? finalCost,
    Expression<int>? discount,
    Expression<int>? paidAtReceive,
    Expression<int>? paidAtDelivery,
    Expression<int>? totalPaid,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? transactionStatus,
    Expression<DateTime>? reversedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (device != null) 'device': device,
      if (model != null) 'model': model,
      if (imei != null) 'imei': imei,
      if (issue != null) 'issue': issue,
      if (status != null) 'status': status,
      if (estimatedCost != null) 'estimated_cost': estimatedCost,
      if (finalCost != null) 'final_cost': finalCost,
      if (discount != null) 'discount': discount,
      if (paidAtReceive != null) 'paid_at_receive': paidAtReceive,
      if (paidAtDelivery != null) 'paid_at_delivery': paidAtDelivery,
      if (totalPaid != null) 'total_paid': totalPaid,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (transactionStatus != null) 'transaction_status': transactionStatus,
      if (reversedAt != null) 'reversed_at': reversedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepairsCompanion copyWith({
    Value<String>? id,
    Value<String?>? customerId,
    Value<String>? customerName,
    Value<String?>? customerPhone,
    Value<String>? device,
    Value<String?>? model,
    Value<String?>? imei,
    Value<String>? issue,
    Value<String>? status,
    Value<int>? estimatedCost,
    Value<int>? finalCost,
    Value<int>? discount,
    Value<int>? paidAtReceive,
    Value<int>? paidAtDelivery,
    Value<int>? totalPaid,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? transactionStatus,
    Value<DateTime?>? reversedAt,
    Value<int>? rowid,
  }) {
    return RepairsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      device: device ?? this.device,
      model: model ?? this.model,
      imei: imei ?? this.imei,
      issue: issue ?? this.issue,
      status: status ?? this.status,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      finalCost: finalCost ?? this.finalCost,
      discount: discount ?? this.discount,
      paidAtReceive: paidAtReceive ?? this.paidAtReceive,
      paidAtDelivery: paidAtDelivery ?? this.paidAtDelivery,
      totalPaid: totalPaid ?? this.totalPaid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      transactionStatus: transactionStatus ?? this.transactionStatus,
      reversedAt: reversedAt ?? this.reversedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (device.present) {
      map['device'] = Variable<String>(device.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (imei.present) {
      map['imei'] = Variable<String>(imei.value);
    }
    if (issue.present) {
      map['issue'] = Variable<String>(issue.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (estimatedCost.present) {
      map['estimated_cost'] = Variable<int>(estimatedCost.value);
    }
    if (finalCost.present) {
      map['final_cost'] = Variable<int>(finalCost.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    if (paidAtReceive.present) {
      map['paid_at_receive'] = Variable<int>(paidAtReceive.value);
    }
    if (paidAtDelivery.present) {
      map['paid_at_delivery'] = Variable<int>(paidAtDelivery.value);
    }
    if (totalPaid.present) {
      map['total_paid'] = Variable<int>(totalPaid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (transactionStatus.present) {
      map['transaction_status'] = Variable<String>(transactionStatus.value);
    }
    if (reversedAt.present) {
      map['reversed_at'] = Variable<DateTime>(reversedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepairsCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('device: $device, ')
          ..write('model: $model, ')
          ..write('imei: $imei, ')
          ..write('issue: $issue, ')
          ..write('status: $status, ')
          ..write('estimatedCost: $estimatedCost, ')
          ..write('finalCost: $finalCost, ')
          ..write('discount: $discount, ')
          ..write('paidAtReceive: $paidAtReceive, ')
          ..write('paidAtDelivery: $paidAtDelivery, ')
          ..write('totalPaid: $totalPaid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('transactionStatus: $transactionStatus, ')
          ..write('reversedAt: $reversedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RepairPartsTable extends RepairParts
    with TableInfo<$RepairPartsTable, RepairPart> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepairPartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repairIdMeta = const VerificationMeta(
    'repairId',
  );
  @override
  late final GeneratedColumn<String> repairId = GeneratedColumn<String>(
    'repair_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineTotalMeta = const VerificationMeta(
    'lineTotal',
  );
  @override
  late final GeneratedColumn<int> lineTotal = GeneratedColumn<int>(
    'line_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    repairId,
    productId,
    qty,
    unitPrice,
    lineTotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repair_parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepairPart> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('repair_id')) {
      context.handle(
        _repairIdMeta,
        repairId.isAcceptableOrUnknown(data['repair_id']!, _repairIdMeta),
      );
    } else if (isInserting) {
      context.missing(_repairIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('line_total')) {
      context.handle(
        _lineTotalMeta,
        lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepairPart map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepairPart(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      repairId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repair_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price'],
      )!,
      lineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_total'],
      )!,
    );
  }

  @override
  $RepairPartsTable createAlias(String alias) {
    return $RepairPartsTable(attachedDatabase, alias);
  }
}

class RepairPart extends DataClass implements Insertable<RepairPart> {
  final String id;
  final String repairId;
  final String productId;
  final int qty;
  final int unitPrice;
  final int lineTotal;
  const RepairPart({
    required this.id,
    required this.repairId,
    required this.productId,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['repair_id'] = Variable<String>(repairId);
    map['product_id'] = Variable<String>(productId);
    map['qty'] = Variable<int>(qty);
    map['unit_price'] = Variable<int>(unitPrice);
    map['line_total'] = Variable<int>(lineTotal);
    return map;
  }

  RepairPartsCompanion toCompanion(bool nullToAbsent) {
    return RepairPartsCompanion(
      id: Value(id),
      repairId: Value(repairId),
      productId: Value(productId),
      qty: Value(qty),
      unitPrice: Value(unitPrice),
      lineTotal: Value(lineTotal),
    );
  }

  factory RepairPart.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepairPart(
      id: serializer.fromJson<String>(json['id']),
      repairId: serializer.fromJson<String>(json['repairId']),
      productId: serializer.fromJson<String>(json['productId']),
      qty: serializer.fromJson<int>(json['qty']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      lineTotal: serializer.fromJson<int>(json['lineTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'repairId': serializer.toJson<String>(repairId),
      'productId': serializer.toJson<String>(productId),
      'qty': serializer.toJson<int>(qty),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'lineTotal': serializer.toJson<int>(lineTotal),
    };
  }

  RepairPart copyWith({
    String? id,
    String? repairId,
    String? productId,
    int? qty,
    int? unitPrice,
    int? lineTotal,
  }) => RepairPart(
    id: id ?? this.id,
    repairId: repairId ?? this.repairId,
    productId: productId ?? this.productId,
    qty: qty ?? this.qty,
    unitPrice: unitPrice ?? this.unitPrice,
    lineTotal: lineTotal ?? this.lineTotal,
  );
  RepairPart copyWithCompanion(RepairPartsCompanion data) {
    return RepairPart(
      id: data.id.present ? data.id.value : this.id,
      repairId: data.repairId.present ? data.repairId.value : this.repairId,
      productId: data.productId.present ? data.productId.value : this.productId,
      qty: data.qty.present ? data.qty.value : this.qty,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepairPart(')
          ..write('id: $id, ')
          ..write('repairId: $repairId, ')
          ..write('productId: $productId, ')
          ..write('qty: $qty, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, repairId, productId, qty, unitPrice, lineTotal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepairPart &&
          other.id == this.id &&
          other.repairId == this.repairId &&
          other.productId == this.productId &&
          other.qty == this.qty &&
          other.unitPrice == this.unitPrice &&
          other.lineTotal == this.lineTotal);
}

class RepairPartsCompanion extends UpdateCompanion<RepairPart> {
  final Value<String> id;
  final Value<String> repairId;
  final Value<String> productId;
  final Value<int> qty;
  final Value<int> unitPrice;
  final Value<int> lineTotal;
  final Value<int> rowid;
  const RepairPartsCompanion({
    this.id = const Value.absent(),
    this.repairId = const Value.absent(),
    this.productId = const Value.absent(),
    this.qty = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepairPartsCompanion.insert({
    required String id,
    required String repairId,
    required String productId,
    required int qty,
    required int unitPrice,
    required int lineTotal,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       repairId = Value(repairId),
       productId = Value(productId),
       qty = Value(qty),
       unitPrice = Value(unitPrice),
       lineTotal = Value(lineTotal);
  static Insertable<RepairPart> custom({
    Expression<String>? id,
    Expression<String>? repairId,
    Expression<String>? productId,
    Expression<int>? qty,
    Expression<int>? unitPrice,
    Expression<int>? lineTotal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (repairId != null) 'repair_id': repairId,
      if (productId != null) 'product_id': productId,
      if (qty != null) 'qty': qty,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (lineTotal != null) 'line_total': lineTotal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepairPartsCompanion copyWith({
    Value<String>? id,
    Value<String>? repairId,
    Value<String>? productId,
    Value<int>? qty,
    Value<int>? unitPrice,
    Value<int>? lineTotal,
    Value<int>? rowid,
  }) {
    return RepairPartsCompanion(
      id: id ?? this.id,
      repairId: repairId ?? this.repairId,
      productId: productId ?? this.productId,
      qty: qty ?? this.qty,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (repairId.present) {
      map['repair_id'] = Variable<String>(repairId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<int>(lineTotal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepairPartsCompanion(')
          ..write('id: $id, ')
          ..write('repairId: $repairId, ')
          ..write('productId: $productId, ')
          ..write('qty: $qty, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, StockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyDeltaMeta = const VerificationMeta(
    'qtyDelta',
  );
  @override
  late final GeneratedColumn<int> qtyDelta = GeneratedColumn<int>(
    'qty_delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
    'ref_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    type,
    qtyDelta,
    reason,
    refId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockMovement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('qty_delta')) {
      context.handle(
        _qtyDeltaMeta,
        qtyDelta.isAcceptableOrUnknown(data['qty_delta']!, _qtyDeltaMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyDeltaMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
        _refIdMeta,
        refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      qtyDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_delta'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }
}

class StockMovement extends DataClass implements Insertable<StockMovement> {
  final String id;
  final String productId;
  final String type;
  final int qtyDelta;
  final String reason;
  final String? refId;
  final DateTime createdAt;
  const StockMovement({
    required this.id,
    required this.productId,
    required this.type,
    required this.qtyDelta,
    required this.reason,
    this.refId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['type'] = Variable<String>(type);
    map['qty_delta'] = Variable<int>(qtyDelta);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || refId != null) {
      map['ref_id'] = Variable<String>(refId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      productId: Value(productId),
      type: Value(type),
      qtyDelta: Value(qtyDelta),
      reason: Value(reason),
      refId: refId == null && nullToAbsent
          ? const Value.absent()
          : Value(refId),
      createdAt: Value(createdAt),
    );
  }

  factory StockMovement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovement(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      type: serializer.fromJson<String>(json['type']),
      qtyDelta: serializer.fromJson<int>(json['qtyDelta']),
      reason: serializer.fromJson<String>(json['reason']),
      refId: serializer.fromJson<String?>(json['refId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'type': serializer.toJson<String>(type),
      'qtyDelta': serializer.toJson<int>(qtyDelta),
      'reason': serializer.toJson<String>(reason),
      'refId': serializer.toJson<String?>(refId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockMovement copyWith({
    String? id,
    String? productId,
    String? type,
    int? qtyDelta,
    String? reason,
    Value<String?> refId = const Value.absent(),
    DateTime? createdAt,
  }) => StockMovement(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    type: type ?? this.type,
    qtyDelta: qtyDelta ?? this.qtyDelta,
    reason: reason ?? this.reason,
    refId: refId.present ? refId.value : this.refId,
    createdAt: createdAt ?? this.createdAt,
  );
  StockMovement copyWithCompanion(StockMovementsCompanion data) {
    return StockMovement(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      type: data.type.present ? data.type.value : this.type,
      qtyDelta: data.qtyDelta.present ? data.qtyDelta.value : this.qtyDelta,
      reason: data.reason.present ? data.reason.value : this.reason,
      refId: data.refId.present ? data.refId.value : this.refId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMovement(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('type: $type, ')
          ..write('qtyDelta: $qtyDelta, ')
          ..write('reason: $reason, ')
          ..write('refId: $refId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, type, qtyDelta, reason, refId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovement &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.type == this.type &&
          other.qtyDelta == this.qtyDelta &&
          other.reason == this.reason &&
          other.refId == this.refId &&
          other.createdAt == this.createdAt);
}

class StockMovementsCompanion extends UpdateCompanion<StockMovement> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> type;
  final Value<int> qtyDelta;
  final Value<String> reason;
  final Value<String?> refId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.type = const Value.absent(),
    this.qtyDelta = const Value.absent(),
    this.reason = const Value.absent(),
    this.refId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    required String id,
    required String productId,
    required String type,
    required int qtyDelta,
    required String reason,
    this.refId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       type = Value(type),
       qtyDelta = Value(qtyDelta),
       reason = Value(reason),
       createdAt = Value(createdAt);
  static Insertable<StockMovement> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? type,
    Expression<int>? qtyDelta,
    Expression<String>? reason,
    Expression<String>? refId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (type != null) 'type': type,
      if (qtyDelta != null) 'qty_delta': qtyDelta,
      if (reason != null) 'reason': reason,
      if (refId != null) 'ref_id': refId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockMovementsCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<String>? type,
    Value<int>? qtyDelta,
    Value<String>? reason,
    Value<String?>? refId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      qtyDelta: qtyDelta ?? this.qtyDelta,
      reason: reason ?? this.reason,
      refId: refId ?? this.refId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (qtyDelta.present) {
      map['qty_delta'] = Variable<int>(qtyDelta.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('type: $type, ')
          ..write('qtyDelta: $qtyDelta, ')
          ..write('reason: $reason, ')
          ..write('refId: $refId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DebtsTable extends Debts with TableInfo<$DebtsTable, Debt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerPhoneMeta = const VerificationMeta(
    'customerPhone',
  );
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
    'customer_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSettledMeta = const VerificationMeta(
    'isSettled',
  );
  @override
  late final GeneratedColumn<bool> isSettled = GeneratedColumn<bool>(
    'is_settled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_settled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _settledAtMeta = const VerificationMeta(
    'settledAt',
  );
  @override
  late final GeneratedColumn<DateTime> settledAt = GeneratedColumn<DateTime>(
    'settled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    customerName,
    customerPhone,
    sourceType,
    sourceId,
    amount,
    dueDate,
    note,
    createdAt,
    isSettled,
    settledAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Debt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
        _customerPhoneMeta,
        customerPhone.isAcceptableOrUnknown(
          data['customer_phone']!,
          _customerPhoneMeta,
        ),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_settled')) {
      context.handle(
        _isSettledMeta,
        isSettled.isAcceptableOrUnknown(data['is_settled']!, _isSettledMeta),
      );
    }
    if (data.containsKey('settled_at')) {
      context.handle(
        _settledAtMeta,
        settledAt.isAcceptableOrUnknown(data['settled_at']!, _settledAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Debt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Debt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      customerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_phone'],
      ),
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSettled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_settled'],
      )!,
      settledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}settled_at'],
      ),
    );
  }

  @override
  $DebtsTable createAlias(String alias) {
    return $DebtsTable(attachedDatabase, alias);
  }
}

class Debt extends DataClass implements Insertable<Debt> {
  final String id;
  final String? customerId;
  final String customerName;
  final String? customerPhone;
  final String sourceType;
  final String sourceId;
  final int amount;
  final DateTime? dueDate;
  final String? note;
  final DateTime createdAt;
  final bool isSettled;
  final DateTime? settledAt;
  const Debt({
    required this.id,
    this.customerId,
    required this.customerName,
    this.customerPhone,
    required this.sourceType,
    required this.sourceId,
    required this.amount,
    this.dueDate,
    this.note,
    required this.createdAt,
    required this.isSettled,
    this.settledAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    map['source_type'] = Variable<String>(sourceType);
    map['source_id'] = Variable<String>(sourceId);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_settled'] = Variable<bool>(isSettled);
    if (!nullToAbsent || settledAt != null) {
      map['settled_at'] = Variable<DateTime>(settledAt);
    }
    return map;
  }

  DebtsCompanion toCompanion(bool nullToAbsent) {
    return DebtsCompanion(
      id: Value(id),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      customerName: Value(customerName),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      sourceType: Value(sourceType),
      sourceId: Value(sourceId),
      amount: Value(amount),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      isSettled: Value(isSettled),
      settledAt: settledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(settledAt),
    );
  }

  factory Debt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Debt(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      amount: serializer.fromJson<int>(json['amount']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSettled: serializer.fromJson<bool>(json['isSettled']),
      settledAt: serializer.fromJson<DateTime?>(json['settledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String?>(customerId),
      'customerName': serializer.toJson<String>(customerName),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceId': serializer.toJson<String>(sourceId),
      'amount': serializer.toJson<int>(amount),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSettled': serializer.toJson<bool>(isSettled),
      'settledAt': serializer.toJson<DateTime?>(settledAt),
    };
  }

  Debt copyWith({
    String? id,
    Value<String?> customerId = const Value.absent(),
    String? customerName,
    Value<String?> customerPhone = const Value.absent(),
    String? sourceType,
    String? sourceId,
    int? amount,
    Value<DateTime?> dueDate = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    bool? isSettled,
    Value<DateTime?> settledAt = const Value.absent(),
  }) => Debt(
    id: id ?? this.id,
    customerId: customerId.present ? customerId.value : this.customerId,
    customerName: customerName ?? this.customerName,
    customerPhone: customerPhone.present
        ? customerPhone.value
        : this.customerPhone,
    sourceType: sourceType ?? this.sourceType,
    sourceId: sourceId ?? this.sourceId,
    amount: amount ?? this.amount,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    isSettled: isSettled ?? this.isSettled,
    settledAt: settledAt.present ? settledAt.value : this.settledAt,
  );
  Debt copyWithCompanion(DebtsCompanion data) {
    return Debt(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      amount: data.amount.present ? data.amount.value : this.amount,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSettled: data.isSettled.present ? data.isSettled.value : this.isSettled,
      settledAt: data.settledAt.present ? data.settledAt.value : this.settledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Debt(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('amount: $amount, ')
          ..write('dueDate: $dueDate, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSettled: $isSettled, ')
          ..write('settledAt: $settledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    customerName,
    customerPhone,
    sourceType,
    sourceId,
    amount,
    dueDate,
    note,
    createdAt,
    isSettled,
    settledAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Debt &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.amount == this.amount &&
          other.dueDate == this.dueDate &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.isSettled == this.isSettled &&
          other.settledAt == this.settledAt);
}

class DebtsCompanion extends UpdateCompanion<Debt> {
  final Value<String> id;
  final Value<String?> customerId;
  final Value<String> customerName;
  final Value<String?> customerPhone;
  final Value<String> sourceType;
  final Value<String> sourceId;
  final Value<int> amount;
  final Value<DateTime?> dueDate;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<bool> isSettled;
  final Value<DateTime?> settledAt;
  final Value<int> rowid;
  const DebtsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.amount = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSettled = const Value.absent(),
    this.settledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DebtsCompanion.insert({
    required String id,
    this.customerId = const Value.absent(),
    required String customerName,
    this.customerPhone = const Value.absent(),
    required String sourceType,
    required String sourceId,
    required int amount,
    this.dueDate = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.isSettled = const Value.absent(),
    this.settledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerName = Value(customerName),
       sourceType = Value(sourceType),
       sourceId = Value(sourceId),
       amount = Value(amount),
       createdAt = Value(createdAt);
  static Insertable<Debt> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<int>? amount,
    Expression<DateTime>? dueDate,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSettled,
    Expression<DateTime>? settledAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (amount != null) 'amount': amount,
      if (dueDate != null) 'due_date': dueDate,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (isSettled != null) 'is_settled': isSettled,
      if (settledAt != null) 'settled_at': settledAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DebtsCompanion copyWith({
    Value<String>? id,
    Value<String?>? customerId,
    Value<String>? customerName,
    Value<String?>? customerPhone,
    Value<String>? sourceType,
    Value<String>? sourceId,
    Value<int>? amount,
    Value<DateTime?>? dueDate,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<bool>? isSettled,
    Value<DateTime?>? settledAt,
    Value<int>? rowid,
  }) {
    return DebtsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      isSettled: isSettled ?? this.isSettled,
      settledAt: settledAt ?? this.settledAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSettled.present) {
      map['is_settled'] = Variable<bool>(isSettled.value);
    }
    if (settledAt.present) {
      map['settled_at'] = Variable<DateTime>(settledAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtsCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('amount: $amount, ')
          ..write('dueDate: $dueDate, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSettled: $isSettled, ')
          ..write('settledAt: $settledAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ElectricityRechargesTable extends ElectricityRecharges
    with TableInfo<$ElectricityRechargesTable, ElectricityRecharge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ElectricityRechargesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subscriptionNumberMeta =
      const VerificationMeta('subscriptionNumber');
  @override
  late final GeneratedColumn<String> subscriptionNumber =
      GeneratedColumn<String>(
        'subscription_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operatedAtMeta = const VerificationMeta(
    'operatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> operatedAt = GeneratedColumn<DateTime>(
    'operated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Electricity'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _reversedAtMeta = const VerificationMeta(
    'reversedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reversedAt = GeneratedColumn<DateTime>(
    'reversed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerName,
    subscriptionNumber,
    amount,
    operatedAt,
    operationType,
    notes,
    createdAt,
    status,
    reversedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'electricity_recharges';
  @override
  VerificationContext validateIntegrity(
    Insertable<ElectricityRecharge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('subscription_number')) {
      context.handle(
        _subscriptionNumberMeta,
        subscriptionNumber.isAcceptableOrUnknown(
          data['subscription_number']!,
          _subscriptionNumberMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('operated_at')) {
      context.handle(
        _operatedAtMeta,
        operatedAt.isAcceptableOrUnknown(data['operated_at']!, _operatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_operatedAtMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('reversed_at')) {
      context.handle(
        _reversedAtMeta,
        reversedAt.isAcceptableOrUnknown(data['reversed_at']!, _reversedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ElectricityRecharge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ElectricityRecharge(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      subscriptionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_number'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      operatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}operated_at'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      reversedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reversed_at'],
      ),
    );
  }

  @override
  $ElectricityRechargesTable createAlias(String alias) {
    return $ElectricityRechargesTable(attachedDatabase, alias);
  }
}

class ElectricityRecharge extends DataClass
    implements Insertable<ElectricityRecharge> {
  final String id;
  final String customerName;
  final String? subscriptionNumber;
  final int amount;
  final DateTime operatedAt;
  final String operationType;
  final String? notes;
  final DateTime createdAt;
  final String status;
  final DateTime? reversedAt;
  const ElectricityRecharge({
    required this.id,
    required this.customerName,
    this.subscriptionNumber,
    required this.amount,
    required this.operatedAt,
    required this.operationType,
    this.notes,
    required this.createdAt,
    required this.status,
    this.reversedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || subscriptionNumber != null) {
      map['subscription_number'] = Variable<String>(subscriptionNumber);
    }
    map['amount'] = Variable<int>(amount);
    map['operated_at'] = Variable<DateTime>(operatedAt);
    map['operation_type'] = Variable<String>(operationType);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reversedAt != null) {
      map['reversed_at'] = Variable<DateTime>(reversedAt);
    }
    return map;
  }

  ElectricityRechargesCompanion toCompanion(bool nullToAbsent) {
    return ElectricityRechargesCompanion(
      id: Value(id),
      customerName: Value(customerName),
      subscriptionNumber: subscriptionNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(subscriptionNumber),
      amount: Value(amount),
      operatedAt: Value(operatedAt),
      operationType: Value(operationType),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      status: Value(status),
      reversedAt: reversedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reversedAt),
    );
  }

  factory ElectricityRecharge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ElectricityRecharge(
      id: serializer.fromJson<String>(json['id']),
      customerName: serializer.fromJson<String>(json['customerName']),
      subscriptionNumber: serializer.fromJson<String?>(
        json['subscriptionNumber'],
      ),
      amount: serializer.fromJson<int>(json['amount']),
      operatedAt: serializer.fromJson<DateTime>(json['operatedAt']),
      operationType: serializer.fromJson<String>(json['operationType']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      reversedAt: serializer.fromJson<DateTime?>(json['reversedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerName': serializer.toJson<String>(customerName),
      'subscriptionNumber': serializer.toJson<String?>(subscriptionNumber),
      'amount': serializer.toJson<int>(amount),
      'operatedAt': serializer.toJson<DateTime>(operatedAt),
      'operationType': serializer.toJson<String>(operationType),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'reversedAt': serializer.toJson<DateTime?>(reversedAt),
    };
  }

  ElectricityRecharge copyWith({
    String? id,
    String? customerName,
    Value<String?> subscriptionNumber = const Value.absent(),
    int? amount,
    DateTime? operatedAt,
    String? operationType,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    String? status,
    Value<DateTime?> reversedAt = const Value.absent(),
  }) => ElectricityRecharge(
    id: id ?? this.id,
    customerName: customerName ?? this.customerName,
    subscriptionNumber: subscriptionNumber.present
        ? subscriptionNumber.value
        : this.subscriptionNumber,
    amount: amount ?? this.amount,
    operatedAt: operatedAt ?? this.operatedAt,
    operationType: operationType ?? this.operationType,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    reversedAt: reversedAt.present ? reversedAt.value : this.reversedAt,
  );
  ElectricityRecharge copyWithCompanion(ElectricityRechargesCompanion data) {
    return ElectricityRecharge(
      id: data.id.present ? data.id.value : this.id,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      subscriptionNumber: data.subscriptionNumber.present
          ? data.subscriptionNumber.value
          : this.subscriptionNumber,
      amount: data.amount.present ? data.amount.value : this.amount,
      operatedAt: data.operatedAt.present
          ? data.operatedAt.value
          : this.operatedAt,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      reversedAt: data.reversedAt.present
          ? data.reversedAt.value
          : this.reversedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ElectricityRecharge(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('subscriptionNumber: $subscriptionNumber, ')
          ..write('amount: $amount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('operationType: $operationType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerName,
    subscriptionNumber,
    amount,
    operatedAt,
    operationType,
    notes,
    createdAt,
    status,
    reversedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ElectricityRecharge &&
          other.id == this.id &&
          other.customerName == this.customerName &&
          other.subscriptionNumber == this.subscriptionNumber &&
          other.amount == this.amount &&
          other.operatedAt == this.operatedAt &&
          other.operationType == this.operationType &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.reversedAt == this.reversedAt);
}

class ElectricityRechargesCompanion
    extends UpdateCompanion<ElectricityRecharge> {
  final Value<String> id;
  final Value<String> customerName;
  final Value<String?> subscriptionNumber;
  final Value<int> amount;
  final Value<DateTime> operatedAt;
  final Value<String> operationType;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<DateTime?> reversedAt;
  final Value<int> rowid;
  const ElectricityRechargesCompanion({
    this.id = const Value.absent(),
    this.customerName = const Value.absent(),
    this.subscriptionNumber = const Value.absent(),
    this.amount = const Value.absent(),
    this.operatedAt = const Value.absent(),
    this.operationType = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ElectricityRechargesCompanion.insert({
    required String id,
    required String customerName,
    this.subscriptionNumber = const Value.absent(),
    required int amount,
    required DateTime operatedAt,
    this.operationType = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerName = Value(customerName),
       amount = Value(amount),
       operatedAt = Value(operatedAt),
       createdAt = Value(createdAt);
  static Insertable<ElectricityRecharge> custom({
    Expression<String>? id,
    Expression<String>? customerName,
    Expression<String>? subscriptionNumber,
    Expression<int>? amount,
    Expression<DateTime>? operatedAt,
    Expression<String>? operationType,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<DateTime>? reversedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerName != null) 'customer_name': customerName,
      if (subscriptionNumber != null) 'subscription_number': subscriptionNumber,
      if (amount != null) 'amount': amount,
      if (operatedAt != null) 'operated_at': operatedAt,
      if (operationType != null) 'operation_type': operationType,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (reversedAt != null) 'reversed_at': reversedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ElectricityRechargesCompanion copyWith({
    Value<String>? id,
    Value<String>? customerName,
    Value<String?>? subscriptionNumber,
    Value<int>? amount,
    Value<DateTime>? operatedAt,
    Value<String>? operationType,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<DateTime?>? reversedAt,
    Value<int>? rowid,
  }) {
    return ElectricityRechargesCompanion(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      subscriptionNumber: subscriptionNumber ?? this.subscriptionNumber,
      amount: amount ?? this.amount,
      operatedAt: operatedAt ?? this.operatedAt,
      operationType: operationType ?? this.operationType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      reversedAt: reversedAt ?? this.reversedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (subscriptionNumber.present) {
      map['subscription_number'] = Variable<String>(subscriptionNumber.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (operatedAt.present) {
      map['operated_at'] = Variable<DateTime>(operatedAt.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reversedAt.present) {
      map['reversed_at'] = Variable<DateTime>(reversedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ElectricityRechargesCompanion(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('subscriptionNumber: $subscriptionNumber, ')
          ..write('amount: $amount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('operationType: $operationType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WalletOperationsTable extends WalletOperations
    with TableInfo<$WalletOperationsTable, WalletOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operatedAtMeta = const VerificationMeta(
    'operatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> operatedAt = GeneratedColumn<DateTime>(
    'operated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _reversedAtMeta = const VerificationMeta(
    'reversedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reversedAt = GeneratedColumn<DateTime>(
    'reversed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerName,
    amount,
    operatedAt,
    notes,
    createdAt,
    status,
    reversedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('operated_at')) {
      context.handle(
        _operatedAtMeta,
        operatedAt.isAcceptableOrUnknown(data['operated_at']!, _operatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_operatedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('reversed_at')) {
      context.handle(
        _reversedAtMeta,
        reversedAt.isAcceptableOrUnknown(data['reversed_at']!, _reversedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletOperation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      operatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}operated_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      reversedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reversed_at'],
      ),
    );
  }

  @override
  $WalletOperationsTable createAlias(String alias) {
    return $WalletOperationsTable(attachedDatabase, alias);
  }
}

class WalletOperation extends DataClass implements Insertable<WalletOperation> {
  final String id;
  final String customerName;
  final int amount;
  final DateTime operatedAt;
  final String? notes;
  final DateTime createdAt;
  final String status;
  final DateTime? reversedAt;
  const WalletOperation({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.operatedAt,
    this.notes,
    required this.createdAt,
    required this.status,
    this.reversedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_name'] = Variable<String>(customerName);
    map['amount'] = Variable<int>(amount);
    map['operated_at'] = Variable<DateTime>(operatedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reversedAt != null) {
      map['reversed_at'] = Variable<DateTime>(reversedAt);
    }
    return map;
  }

  WalletOperationsCompanion toCompanion(bool nullToAbsent) {
    return WalletOperationsCompanion(
      id: Value(id),
      customerName: Value(customerName),
      amount: Value(amount),
      operatedAt: Value(operatedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      status: Value(status),
      reversedAt: reversedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reversedAt),
    );
  }

  factory WalletOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletOperation(
      id: serializer.fromJson<String>(json['id']),
      customerName: serializer.fromJson<String>(json['customerName']),
      amount: serializer.fromJson<int>(json['amount']),
      operatedAt: serializer.fromJson<DateTime>(json['operatedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      reversedAt: serializer.fromJson<DateTime?>(json['reversedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerName': serializer.toJson<String>(customerName),
      'amount': serializer.toJson<int>(amount),
      'operatedAt': serializer.toJson<DateTime>(operatedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'reversedAt': serializer.toJson<DateTime?>(reversedAt),
    };
  }

  WalletOperation copyWith({
    String? id,
    String? customerName,
    int? amount,
    DateTime? operatedAt,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    String? status,
    Value<DateTime?> reversedAt = const Value.absent(),
  }) => WalletOperation(
    id: id ?? this.id,
    customerName: customerName ?? this.customerName,
    amount: amount ?? this.amount,
    operatedAt: operatedAt ?? this.operatedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    reversedAt: reversedAt.present ? reversedAt.value : this.reversedAt,
  );
  WalletOperation copyWithCompanion(WalletOperationsCompanion data) {
    return WalletOperation(
      id: data.id.present ? data.id.value : this.id,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      amount: data.amount.present ? data.amount.value : this.amount,
      operatedAt: data.operatedAt.present
          ? data.operatedAt.value
          : this.operatedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      reversedAt: data.reversedAt.present
          ? data.reversedAt.value
          : this.reversedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletOperation(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('amount: $amount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerName,
    amount,
    operatedAt,
    notes,
    createdAt,
    status,
    reversedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletOperation &&
          other.id == this.id &&
          other.customerName == this.customerName &&
          other.amount == this.amount &&
          other.operatedAt == this.operatedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.reversedAt == this.reversedAt);
}

class WalletOperationsCompanion extends UpdateCompanion<WalletOperation> {
  final Value<String> id;
  final Value<String> customerName;
  final Value<int> amount;
  final Value<DateTime> operatedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<DateTime?> reversedAt;
  final Value<int> rowid;
  const WalletOperationsCompanion({
    this.id = const Value.absent(),
    this.customerName = const Value.absent(),
    this.amount = const Value.absent(),
    this.operatedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WalletOperationsCompanion.insert({
    required String id,
    required String customerName,
    required int amount,
    required DateTime operatedAt,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerName = Value(customerName),
       amount = Value(amount),
       operatedAt = Value(operatedAt),
       createdAt = Value(createdAt);
  static Insertable<WalletOperation> custom({
    Expression<String>? id,
    Expression<String>? customerName,
    Expression<int>? amount,
    Expression<DateTime>? operatedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<DateTime>? reversedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerName != null) 'customer_name': customerName,
      if (amount != null) 'amount': amount,
      if (operatedAt != null) 'operated_at': operatedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (reversedAt != null) 'reversed_at': reversedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WalletOperationsCompanion copyWith({
    Value<String>? id,
    Value<String>? customerName,
    Value<int>? amount,
    Value<DateTime>? operatedAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<DateTime?>? reversedAt,
    Value<int>? rowid,
  }) {
    return WalletOperationsCompanion(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      amount: amount ?? this.amount,
      operatedAt: operatedAt ?? this.operatedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      reversedAt: reversedAt ?? this.reversedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (operatedAt.present) {
      map['operated_at'] = Variable<DateTime>(operatedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reversedAt.present) {
      map['reversed_at'] = Variable<DateTime>(reversedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletOperationsCompanion(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('amount: $amount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TelelinkOperationsTable extends TelelinkOperations
    with TableInfo<$TelelinkOperationsTable, TelelinkOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TelelinkOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operatedAtMeta = const VerificationMeta(
    'operatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> operatedAt = GeneratedColumn<DateTime>(
    'operated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _reversedAtMeta = const VerificationMeta(
    'reversedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reversedAt = GeneratedColumn<DateTime>(
    'reversed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerName,
    amount,
    operatedAt,
    notes,
    createdAt,
    status,
    reversedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'telelink_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<TelelinkOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('operated_at')) {
      context.handle(
        _operatedAtMeta,
        operatedAt.isAcceptableOrUnknown(data['operated_at']!, _operatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_operatedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('reversed_at')) {
      context.handle(
        _reversedAtMeta,
        reversedAt.isAcceptableOrUnknown(data['reversed_at']!, _reversedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TelelinkOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TelelinkOperation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      operatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}operated_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      reversedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reversed_at'],
      ),
    );
  }

  @override
  $TelelinkOperationsTable createAlias(String alias) {
    return $TelelinkOperationsTable(attachedDatabase, alias);
  }
}

class TelelinkOperation extends DataClass
    implements Insertable<TelelinkOperation> {
  final String id;
  final String customerName;
  final int amount;
  final DateTime operatedAt;
  final String? notes;
  final DateTime createdAt;
  final String status;
  final DateTime? reversedAt;
  const TelelinkOperation({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.operatedAt,
    this.notes,
    required this.createdAt,
    required this.status,
    this.reversedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_name'] = Variable<String>(customerName);
    map['amount'] = Variable<int>(amount);
    map['operated_at'] = Variable<DateTime>(operatedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reversedAt != null) {
      map['reversed_at'] = Variable<DateTime>(reversedAt);
    }
    return map;
  }

  TelelinkOperationsCompanion toCompanion(bool nullToAbsent) {
    return TelelinkOperationsCompanion(
      id: Value(id),
      customerName: Value(customerName),
      amount: Value(amount),
      operatedAt: Value(operatedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      status: Value(status),
      reversedAt: reversedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reversedAt),
    );
  }

  factory TelelinkOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TelelinkOperation(
      id: serializer.fromJson<String>(json['id']),
      customerName: serializer.fromJson<String>(json['customerName']),
      amount: serializer.fromJson<int>(json['amount']),
      operatedAt: serializer.fromJson<DateTime>(json['operatedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      reversedAt: serializer.fromJson<DateTime?>(json['reversedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerName': serializer.toJson<String>(customerName),
      'amount': serializer.toJson<int>(amount),
      'operatedAt': serializer.toJson<DateTime>(operatedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'reversedAt': serializer.toJson<DateTime?>(reversedAt),
    };
  }

  TelelinkOperation copyWith({
    String? id,
    String? customerName,
    int? amount,
    DateTime? operatedAt,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    String? status,
    Value<DateTime?> reversedAt = const Value.absent(),
  }) => TelelinkOperation(
    id: id ?? this.id,
    customerName: customerName ?? this.customerName,
    amount: amount ?? this.amount,
    operatedAt: operatedAt ?? this.operatedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    reversedAt: reversedAt.present ? reversedAt.value : this.reversedAt,
  );
  TelelinkOperation copyWithCompanion(TelelinkOperationsCompanion data) {
    return TelelinkOperation(
      id: data.id.present ? data.id.value : this.id,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      amount: data.amount.present ? data.amount.value : this.amount,
      operatedAt: data.operatedAt.present
          ? data.operatedAt.value
          : this.operatedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      reversedAt: data.reversedAt.present
          ? data.reversedAt.value
          : this.reversedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TelelinkOperation(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('amount: $amount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerName,
    amount,
    operatedAt,
    notes,
    createdAt,
    status,
    reversedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TelelinkOperation &&
          other.id == this.id &&
          other.customerName == this.customerName &&
          other.amount == this.amount &&
          other.operatedAt == this.operatedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.reversedAt == this.reversedAt);
}

class TelelinkOperationsCompanion extends UpdateCompanion<TelelinkOperation> {
  final Value<String> id;
  final Value<String> customerName;
  final Value<int> amount;
  final Value<DateTime> operatedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<DateTime?> reversedAt;
  final Value<int> rowid;
  const TelelinkOperationsCompanion({
    this.id = const Value.absent(),
    this.customerName = const Value.absent(),
    this.amount = const Value.absent(),
    this.operatedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TelelinkOperationsCompanion.insert({
    required String id,
    required String customerName,
    required int amount,
    required DateTime operatedAt,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerName = Value(customerName),
       amount = Value(amount),
       operatedAt = Value(operatedAt),
       createdAt = Value(createdAt);
  static Insertable<TelelinkOperation> custom({
    Expression<String>? id,
    Expression<String>? customerName,
    Expression<int>? amount,
    Expression<DateTime>? operatedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<DateTime>? reversedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerName != null) 'customer_name': customerName,
      if (amount != null) 'amount': amount,
      if (operatedAt != null) 'operated_at': operatedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (reversedAt != null) 'reversed_at': reversedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TelelinkOperationsCompanion copyWith({
    Value<String>? id,
    Value<String>? customerName,
    Value<int>? amount,
    Value<DateTime>? operatedAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<DateTime?>? reversedAt,
    Value<int>? rowid,
  }) {
    return TelelinkOperationsCompanion(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      amount: amount ?? this.amount,
      operatedAt: operatedAt ?? this.operatedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      reversedAt: reversedAt ?? this.reversedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (operatedAt.present) {
      map['operated_at'] = Variable<DateTime>(operatedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reversedAt.present) {
      map['reversed_at'] = Variable<DateTime>(reversedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TelelinkOperationsCompanion(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('amount: $amount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FarahnetPaymentsTable extends FarahnetPayments
    with TableInfo<$FarahnetPaymentsTable, FarahnetPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FarahnetPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPaidMeta = const VerificationMeta(
    'amountPaid',
  );
  @override
  late final GeneratedColumn<int> amountPaid = GeneratedColumn<int>(
    'amount_paid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profitAmountMeta = const VerificationMeta(
    'profitAmount',
  );
  @override
  late final GeneratedColumn<int> profitAmount = GeneratedColumn<int>(
    'profit_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operatedAtMeta = const VerificationMeta(
    'operatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> operatedAt = GeneratedColumn<DateTime>(
    'operated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _reversedAtMeta = const VerificationMeta(
    'reversedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reversedAt = GeneratedColumn<DateTime>(
    'reversed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerName,
    amountPaid,
    profitAmount,
    operatedAt,
    notes,
    createdAt,
    status,
    reversedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'farahnet_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<FarahnetPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('amount_paid')) {
      context.handle(
        _amountPaidMeta,
        amountPaid.isAcceptableOrUnknown(data['amount_paid']!, _amountPaidMeta),
      );
    } else if (isInserting) {
      context.missing(_amountPaidMeta);
    }
    if (data.containsKey('profit_amount')) {
      context.handle(
        _profitAmountMeta,
        profitAmount.isAcceptableOrUnknown(
          data['profit_amount']!,
          _profitAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profitAmountMeta);
    }
    if (data.containsKey('operated_at')) {
      context.handle(
        _operatedAtMeta,
        operatedAt.isAcceptableOrUnknown(data['operated_at']!, _operatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_operatedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('reversed_at')) {
      context.handle(
        _reversedAtMeta,
        reversedAt.isAcceptableOrUnknown(data['reversed_at']!, _reversedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FarahnetPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarahnetPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      amountPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paid'],
      )!,
      profitAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profit_amount'],
      )!,
      operatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}operated_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      reversedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reversed_at'],
      ),
    );
  }

  @override
  $FarahnetPaymentsTable createAlias(String alias) {
    return $FarahnetPaymentsTable(attachedDatabase, alias);
  }
}

class FarahnetPayment extends DataClass implements Insertable<FarahnetPayment> {
  final String id;
  final String customerName;
  final int amountPaid;
  final int profitAmount;
  final DateTime operatedAt;
  final String? notes;
  final DateTime createdAt;
  final String status;
  final DateTime? reversedAt;
  const FarahnetPayment({
    required this.id,
    required this.customerName,
    required this.amountPaid,
    required this.profitAmount,
    required this.operatedAt,
    this.notes,
    required this.createdAt,
    required this.status,
    this.reversedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_name'] = Variable<String>(customerName);
    map['amount_paid'] = Variable<int>(amountPaid);
    map['profit_amount'] = Variable<int>(profitAmount);
    map['operated_at'] = Variable<DateTime>(operatedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reversedAt != null) {
      map['reversed_at'] = Variable<DateTime>(reversedAt);
    }
    return map;
  }

  FarahnetPaymentsCompanion toCompanion(bool nullToAbsent) {
    return FarahnetPaymentsCompanion(
      id: Value(id),
      customerName: Value(customerName),
      amountPaid: Value(amountPaid),
      profitAmount: Value(profitAmount),
      operatedAt: Value(operatedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      status: Value(status),
      reversedAt: reversedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reversedAt),
    );
  }

  factory FarahnetPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarahnetPayment(
      id: serializer.fromJson<String>(json['id']),
      customerName: serializer.fromJson<String>(json['customerName']),
      amountPaid: serializer.fromJson<int>(json['amountPaid']),
      profitAmount: serializer.fromJson<int>(json['profitAmount']),
      operatedAt: serializer.fromJson<DateTime>(json['operatedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      reversedAt: serializer.fromJson<DateTime?>(json['reversedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerName': serializer.toJson<String>(customerName),
      'amountPaid': serializer.toJson<int>(amountPaid),
      'profitAmount': serializer.toJson<int>(profitAmount),
      'operatedAt': serializer.toJson<DateTime>(operatedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'reversedAt': serializer.toJson<DateTime?>(reversedAt),
    };
  }

  FarahnetPayment copyWith({
    String? id,
    String? customerName,
    int? amountPaid,
    int? profitAmount,
    DateTime? operatedAt,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    String? status,
    Value<DateTime?> reversedAt = const Value.absent(),
  }) => FarahnetPayment(
    id: id ?? this.id,
    customerName: customerName ?? this.customerName,
    amountPaid: amountPaid ?? this.amountPaid,
    profitAmount: profitAmount ?? this.profitAmount,
    operatedAt: operatedAt ?? this.operatedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    reversedAt: reversedAt.present ? reversedAt.value : this.reversedAt,
  );
  FarahnetPayment copyWithCompanion(FarahnetPaymentsCompanion data) {
    return FarahnetPayment(
      id: data.id.present ? data.id.value : this.id,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      amountPaid: data.amountPaid.present
          ? data.amountPaid.value
          : this.amountPaid,
      profitAmount: data.profitAmount.present
          ? data.profitAmount.value
          : this.profitAmount,
      operatedAt: data.operatedAt.present
          ? data.operatedAt.value
          : this.operatedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      reversedAt: data.reversedAt.present
          ? data.reversedAt.value
          : this.reversedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarahnetPayment(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('profitAmount: $profitAmount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerName,
    amountPaid,
    profitAmount,
    operatedAt,
    notes,
    createdAt,
    status,
    reversedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarahnetPayment &&
          other.id == this.id &&
          other.customerName == this.customerName &&
          other.amountPaid == this.amountPaid &&
          other.profitAmount == this.profitAmount &&
          other.operatedAt == this.operatedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.reversedAt == this.reversedAt);
}

class FarahnetPaymentsCompanion extends UpdateCompanion<FarahnetPayment> {
  final Value<String> id;
  final Value<String> customerName;
  final Value<int> amountPaid;
  final Value<int> profitAmount;
  final Value<DateTime> operatedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<DateTime?> reversedAt;
  final Value<int> rowid;
  const FarahnetPaymentsCompanion({
    this.id = const Value.absent(),
    this.customerName = const Value.absent(),
    this.amountPaid = const Value.absent(),
    this.profitAmount = const Value.absent(),
    this.operatedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FarahnetPaymentsCompanion.insert({
    required String id,
    required String customerName,
    required int amountPaid,
    required int profitAmount,
    required DateTime operatedAt,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerName = Value(customerName),
       amountPaid = Value(amountPaid),
       profitAmount = Value(profitAmount),
       operatedAt = Value(operatedAt),
       createdAt = Value(createdAt);
  static Insertable<FarahnetPayment> custom({
    Expression<String>? id,
    Expression<String>? customerName,
    Expression<int>? amountPaid,
    Expression<int>? profitAmount,
    Expression<DateTime>? operatedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<DateTime>? reversedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerName != null) 'customer_name': customerName,
      if (amountPaid != null) 'amount_paid': amountPaid,
      if (profitAmount != null) 'profit_amount': profitAmount,
      if (operatedAt != null) 'operated_at': operatedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (reversedAt != null) 'reversed_at': reversedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FarahnetPaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? customerName,
    Value<int>? amountPaid,
    Value<int>? profitAmount,
    Value<DateTime>? operatedAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<DateTime?>? reversedAt,
    Value<int>? rowid,
  }) {
    return FarahnetPaymentsCompanion(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      amountPaid: amountPaid ?? this.amountPaid,
      profitAmount: profitAmount ?? this.profitAmount,
      operatedAt: operatedAt ?? this.operatedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      reversedAt: reversedAt ?? this.reversedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (amountPaid.present) {
      map['amount_paid'] = Variable<int>(amountPaid.value);
    }
    if (profitAmount.present) {
      map['profit_amount'] = Variable<int>(profitAmount.value);
    }
    if (operatedAt.present) {
      map['operated_at'] = Variable<DateTime>(operatedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reversedAt.present) {
      map['reversed_at'] = Variable<DateTime>(reversedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FarahnetPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('profitAmount: $profitAmount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgramTopupsTable extends ProgramTopups
    with TableInfo<$ProgramTopupsTable, ProgramTopup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramTopupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _programTypeMeta = const VerificationMeta(
    'programType',
  );
  @override
  late final GeneratedColumn<String> programType = GeneratedColumn<String>(
    'program_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operatedAtMeta = const VerificationMeta(
    'operatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> operatedAt = GeneratedColumn<DateTime>(
    'operated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _reversedAtMeta = const VerificationMeta(
    'reversedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reversedAt = GeneratedColumn<DateTime>(
    'reversed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    programType,
    amount,
    operatedAt,
    notes,
    createdAt,
    status,
    reversedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'program_topups';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgramTopup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('program_type')) {
      context.handle(
        _programTypeMeta,
        programType.isAcceptableOrUnknown(
          data['program_type']!,
          _programTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_programTypeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('operated_at')) {
      context.handle(
        _operatedAtMeta,
        operatedAt.isAcceptableOrUnknown(data['operated_at']!, _operatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_operatedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('reversed_at')) {
      context.handle(
        _reversedAtMeta,
        reversedAt.isAcceptableOrUnknown(data['reversed_at']!, _reversedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramTopup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgramTopup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      programType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      operatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}operated_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      reversedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reversed_at'],
      ),
    );
  }

  @override
  $ProgramTopupsTable createAlias(String alias) {
    return $ProgramTopupsTable(attachedDatabase, alias);
  }
}

class ProgramTopup extends DataClass implements Insertable<ProgramTopup> {
  final String id;
  final String programType;
  final int amount;
  final DateTime operatedAt;
  final String? notes;
  final DateTime createdAt;
  final String status;
  final DateTime? reversedAt;
  const ProgramTopup({
    required this.id,
    required this.programType,
    required this.amount,
    required this.operatedAt,
    this.notes,
    required this.createdAt,
    required this.status,
    this.reversedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['program_type'] = Variable<String>(programType);
    map['amount'] = Variable<int>(amount);
    map['operated_at'] = Variable<DateTime>(operatedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reversedAt != null) {
      map['reversed_at'] = Variable<DateTime>(reversedAt);
    }
    return map;
  }

  ProgramTopupsCompanion toCompanion(bool nullToAbsent) {
    return ProgramTopupsCompanion(
      id: Value(id),
      programType: Value(programType),
      amount: Value(amount),
      operatedAt: Value(operatedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      status: Value(status),
      reversedAt: reversedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reversedAt),
    );
  }

  factory ProgramTopup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgramTopup(
      id: serializer.fromJson<String>(json['id']),
      programType: serializer.fromJson<String>(json['programType']),
      amount: serializer.fromJson<int>(json['amount']),
      operatedAt: serializer.fromJson<DateTime>(json['operatedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      reversedAt: serializer.fromJson<DateTime?>(json['reversedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'programType': serializer.toJson<String>(programType),
      'amount': serializer.toJson<int>(amount),
      'operatedAt': serializer.toJson<DateTime>(operatedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'reversedAt': serializer.toJson<DateTime?>(reversedAt),
    };
  }

  ProgramTopup copyWith({
    String? id,
    String? programType,
    int? amount,
    DateTime? operatedAt,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    String? status,
    Value<DateTime?> reversedAt = const Value.absent(),
  }) => ProgramTopup(
    id: id ?? this.id,
    programType: programType ?? this.programType,
    amount: amount ?? this.amount,
    operatedAt: operatedAt ?? this.operatedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    reversedAt: reversedAt.present ? reversedAt.value : this.reversedAt,
  );
  ProgramTopup copyWithCompanion(ProgramTopupsCompanion data) {
    return ProgramTopup(
      id: data.id.present ? data.id.value : this.id,
      programType: data.programType.present
          ? data.programType.value
          : this.programType,
      amount: data.amount.present ? data.amount.value : this.amount,
      operatedAt: data.operatedAt.present
          ? data.operatedAt.value
          : this.operatedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      reversedAt: data.reversedAt.present
          ? data.reversedAt.value
          : this.reversedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgramTopup(')
          ..write('id: $id, ')
          ..write('programType: $programType, ')
          ..write('amount: $amount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    programType,
    amount,
    operatedAt,
    notes,
    createdAt,
    status,
    reversedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramTopup &&
          other.id == this.id &&
          other.programType == this.programType &&
          other.amount == this.amount &&
          other.operatedAt == this.operatedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.reversedAt == this.reversedAt);
}

class ProgramTopupsCompanion extends UpdateCompanion<ProgramTopup> {
  final Value<String> id;
  final Value<String> programType;
  final Value<int> amount;
  final Value<DateTime> operatedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<DateTime?> reversedAt;
  final Value<int> rowid;
  const ProgramTopupsCompanion({
    this.id = const Value.absent(),
    this.programType = const Value.absent(),
    this.amount = const Value.absent(),
    this.operatedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgramTopupsCompanion.insert({
    required String id,
    required String programType,
    required int amount,
    required DateTime operatedAt,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       programType = Value(programType),
       amount = Value(amount),
       operatedAt = Value(operatedAt),
       createdAt = Value(createdAt);
  static Insertable<ProgramTopup> custom({
    Expression<String>? id,
    Expression<String>? programType,
    Expression<int>? amount,
    Expression<DateTime>? operatedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<DateTime>? reversedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programType != null) 'program_type': programType,
      if (amount != null) 'amount': amount,
      if (operatedAt != null) 'operated_at': operatedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (reversedAt != null) 'reversed_at': reversedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgramTopupsCompanion copyWith({
    Value<String>? id,
    Value<String>? programType,
    Value<int>? amount,
    Value<DateTime>? operatedAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<DateTime?>? reversedAt,
    Value<int>? rowid,
  }) {
    return ProgramTopupsCompanion(
      id: id ?? this.id,
      programType: programType ?? this.programType,
      amount: amount ?? this.amount,
      operatedAt: operatedAt ?? this.operatedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      reversedAt: reversedAt ?? this.reversedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (programType.present) {
      map['program_type'] = Variable<String>(programType.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (operatedAt.present) {
      map['operated_at'] = Variable<DateTime>(operatedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reversedAt.present) {
      map['reversed_at'] = Variable<DateTime>(reversedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramTopupsCompanion(')
          ..write('id: $id, ')
          ..write('programType: $programType, ')
          ..write('amount: $amount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettlementsTable extends Settlements
    with TableInfo<$SettlementsTable, Settlement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettlementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _programTypeMeta = const VerificationMeta(
    'programType',
  );
  @override
  late final GeneratedColumn<String> programType = GeneratedColumn<String>(
    'program_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operatedAtMeta = const VerificationMeta(
    'operatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> operatedAt = GeneratedColumn<DateTime>(
    'operated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    programType,
    amount,
    operatedAt,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settlements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Settlement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('program_type')) {
      context.handle(
        _programTypeMeta,
        programType.isAcceptableOrUnknown(
          data['program_type']!,
          _programTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_programTypeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('operated_at')) {
      context.handle(
        _operatedAtMeta,
        operatedAt.isAcceptableOrUnknown(data['operated_at']!, _operatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_operatedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Settlement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Settlement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      programType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      operatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}operated_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SettlementsTable createAlias(String alias) {
    return $SettlementsTable(attachedDatabase, alias);
  }
}

class Settlement extends DataClass implements Insertable<Settlement> {
  final String id;
  final String programType;
  final int amount;
  final DateTime operatedAt;
  final String? notes;
  final DateTime createdAt;
  const Settlement({
    required this.id,
    required this.programType,
    required this.amount,
    required this.operatedAt,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['program_type'] = Variable<String>(programType);
    map['amount'] = Variable<int>(amount);
    map['operated_at'] = Variable<DateTime>(operatedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SettlementsCompanion toCompanion(bool nullToAbsent) {
    return SettlementsCompanion(
      id: Value(id),
      programType: Value(programType),
      amount: Value(amount),
      operatedAt: Value(operatedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Settlement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Settlement(
      id: serializer.fromJson<String>(json['id']),
      programType: serializer.fromJson<String>(json['programType']),
      amount: serializer.fromJson<int>(json['amount']),
      operatedAt: serializer.fromJson<DateTime>(json['operatedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'programType': serializer.toJson<String>(programType),
      'amount': serializer.toJson<int>(amount),
      'operatedAt': serializer.toJson<DateTime>(operatedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Settlement copyWith({
    String? id,
    String? programType,
    int? amount,
    DateTime? operatedAt,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => Settlement(
    id: id ?? this.id,
    programType: programType ?? this.programType,
    amount: amount ?? this.amount,
    operatedAt: operatedAt ?? this.operatedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  Settlement copyWithCompanion(SettlementsCompanion data) {
    return Settlement(
      id: data.id.present ? data.id.value : this.id,
      programType: data.programType.present
          ? data.programType.value
          : this.programType,
      amount: data.amount.present ? data.amount.value : this.amount,
      operatedAt: data.operatedAt.present
          ? data.operatedAt.value
          : this.operatedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Settlement(')
          ..write('id: $id, ')
          ..write('programType: $programType, ')
          ..write('amount: $amount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, programType, amount, operatedAt, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Settlement &&
          other.id == this.id &&
          other.programType == this.programType &&
          other.amount == this.amount &&
          other.operatedAt == this.operatedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class SettlementsCompanion extends UpdateCompanion<Settlement> {
  final Value<String> id;
  final Value<String> programType;
  final Value<int> amount;
  final Value<DateTime> operatedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SettlementsCompanion({
    this.id = const Value.absent(),
    this.programType = const Value.absent(),
    this.amount = const Value.absent(),
    this.operatedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettlementsCompanion.insert({
    required String id,
    required String programType,
    required int amount,
    required DateTime operatedAt,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       programType = Value(programType),
       amount = Value(amount),
       operatedAt = Value(operatedAt),
       createdAt = Value(createdAt);
  static Insertable<Settlement> custom({
    Expression<String>? id,
    Expression<String>? programType,
    Expression<int>? amount,
    Expression<DateTime>? operatedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programType != null) 'program_type': programType,
      if (amount != null) 'amount': amount,
      if (operatedAt != null) 'operated_at': operatedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettlementsCompanion copyWith({
    Value<String>? id,
    Value<String>? programType,
    Value<int>? amount,
    Value<DateTime>? operatedAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SettlementsCompanion(
      id: id ?? this.id,
      programType: programType ?? this.programType,
      amount: amount ?? this.amount,
      operatedAt: operatedAt ?? this.operatedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (programType.present) {
      map['program_type'] = Variable<String>(programType.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (operatedAt.present) {
      map['operated_at'] = Variable<DateTime>(operatedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettlementsCompanion(')
          ..write('id: $id, ')
          ..write('programType: $programType, ')
          ..write('amount: $amount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RepairPartOrdersTable extends RepairPartOrders
    with TableInfo<$RepairPartOrdersTable, RepairPartOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepairPartOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repairIdMeta = const VerificationMeta(
    'repairId',
  );
  @override
  late final GeneratedColumn<String> repairId = GeneratedColumn<String>(
    'repair_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<String> partId = GeneratedColumn<String>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _operatedAtMeta = const VerificationMeta(
    'operatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> operatedAt = GeneratedColumn<DateTime>(
    'operated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Pending'),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    repairId,
    partId,
    supplierId,
    operatedAt,
    status,
    quantity,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repair_part_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepairPartOrder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('repair_id')) {
      context.handle(
        _repairIdMeta,
        repairId.isAcceptableOrUnknown(data['repair_id']!, _repairIdMeta),
      );
    } else if (isInserting) {
      context.missing(_repairIdMeta);
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('operated_at')) {
      context.handle(
        _operatedAtMeta,
        operatedAt.isAcceptableOrUnknown(data['operated_at']!, _operatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_operatedAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepairPartOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepairPartOrder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      repairId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repair_id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_id'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      operatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}operated_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RepairPartOrdersTable createAlias(String alias) {
    return $RepairPartOrdersTable(attachedDatabase, alias);
  }
}

class RepairPartOrder extends DataClass implements Insertable<RepairPartOrder> {
  final String id;
  final String repairId;
  final String partId;
  final String? supplierId;
  final DateTime operatedAt;
  final String status;
  final int quantity;
  final String? notes;
  final DateTime createdAt;
  const RepairPartOrder({
    required this.id,
    required this.repairId,
    required this.partId,
    this.supplierId,
    required this.operatedAt,
    required this.status,
    required this.quantity,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['repair_id'] = Variable<String>(repairId);
    map['part_id'] = Variable<String>(partId);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    map['operated_at'] = Variable<DateTime>(operatedAt);
    map['status'] = Variable<String>(status);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RepairPartOrdersCompanion toCompanion(bool nullToAbsent) {
    return RepairPartOrdersCompanion(
      id: Value(id),
      repairId: Value(repairId),
      partId: Value(partId),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      operatedAt: Value(operatedAt),
      status: Value(status),
      quantity: Value(quantity),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory RepairPartOrder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepairPartOrder(
      id: serializer.fromJson<String>(json['id']),
      repairId: serializer.fromJson<String>(json['repairId']),
      partId: serializer.fromJson<String>(json['partId']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      operatedAt: serializer.fromJson<DateTime>(json['operatedAt']),
      status: serializer.fromJson<String>(json['status']),
      quantity: serializer.fromJson<int>(json['quantity']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'repairId': serializer.toJson<String>(repairId),
      'partId': serializer.toJson<String>(partId),
      'supplierId': serializer.toJson<String?>(supplierId),
      'operatedAt': serializer.toJson<DateTime>(operatedAt),
      'status': serializer.toJson<String>(status),
      'quantity': serializer.toJson<int>(quantity),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RepairPartOrder copyWith({
    String? id,
    String? repairId,
    String? partId,
    Value<String?> supplierId = const Value.absent(),
    DateTime? operatedAt,
    String? status,
    int? quantity,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => RepairPartOrder(
    id: id ?? this.id,
    repairId: repairId ?? this.repairId,
    partId: partId ?? this.partId,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    operatedAt: operatedAt ?? this.operatedAt,
    status: status ?? this.status,
    quantity: quantity ?? this.quantity,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  RepairPartOrder copyWithCompanion(RepairPartOrdersCompanion data) {
    return RepairPartOrder(
      id: data.id.present ? data.id.value : this.id,
      repairId: data.repairId.present ? data.repairId.value : this.repairId,
      partId: data.partId.present ? data.partId.value : this.partId,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      operatedAt: data.operatedAt.present
          ? data.operatedAt.value
          : this.operatedAt,
      status: data.status.present ? data.status.value : this.status,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepairPartOrder(')
          ..write('id: $id, ')
          ..write('repairId: $repairId, ')
          ..write('partId: $partId, ')
          ..write('supplierId: $supplierId, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('status: $status, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    repairId,
    partId,
    supplierId,
    operatedAt,
    status,
    quantity,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepairPartOrder &&
          other.id == this.id &&
          other.repairId == this.repairId &&
          other.partId == this.partId &&
          other.supplierId == this.supplierId &&
          other.operatedAt == this.operatedAt &&
          other.status == this.status &&
          other.quantity == this.quantity &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class RepairPartOrdersCompanion extends UpdateCompanion<RepairPartOrder> {
  final Value<String> id;
  final Value<String> repairId;
  final Value<String> partId;
  final Value<String?> supplierId;
  final Value<DateTime> operatedAt;
  final Value<String> status;
  final Value<int> quantity;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RepairPartOrdersCompanion({
    this.id = const Value.absent(),
    this.repairId = const Value.absent(),
    this.partId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.operatedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepairPartOrdersCompanion.insert({
    required String id,
    required String repairId,
    required String partId,
    this.supplierId = const Value.absent(),
    required DateTime operatedAt,
    this.status = const Value.absent(),
    required int quantity,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       repairId = Value(repairId),
       partId = Value(partId),
       operatedAt = Value(operatedAt),
       quantity = Value(quantity),
       createdAt = Value(createdAt);
  static Insertable<RepairPartOrder> custom({
    Expression<String>? id,
    Expression<String>? repairId,
    Expression<String>? partId,
    Expression<String>? supplierId,
    Expression<DateTime>? operatedAt,
    Expression<String>? status,
    Expression<int>? quantity,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (repairId != null) 'repair_id': repairId,
      if (partId != null) 'part_id': partId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (operatedAt != null) 'operated_at': operatedAt,
      if (status != null) 'status': status,
      if (quantity != null) 'quantity': quantity,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepairPartOrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? repairId,
    Value<String>? partId,
    Value<String?>? supplierId,
    Value<DateTime>? operatedAt,
    Value<String>? status,
    Value<int>? quantity,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RepairPartOrdersCompanion(
      id: id ?? this.id,
      repairId: repairId ?? this.repairId,
      partId: partId ?? this.partId,
      supplierId: supplierId ?? this.supplierId,
      operatedAt: operatedAt ?? this.operatedAt,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (repairId.present) {
      map['repair_id'] = Variable<String>(repairId.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<String>(partId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (operatedAt.present) {
      map['operated_at'] = Variable<DateTime>(operatedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepairPartOrdersCompanion(')
          ..write('id: $id, ')
          ..write('repairId: $repairId, ')
          ..write('partId: $partId, ')
          ..write('supplierId: $supplierId, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('status: $status, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceTransactionsTable extends ServiceTransactions
    with TableInfo<$ServiceTransactionsTable, ServiceTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerLabelMeta = const VerificationMeta(
    'providerLabel',
  );
  @override
  late final GeneratedColumn<String> providerLabel = GeneratedColumn<String>(
    'provider_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serviceTypeMeta = const VerificationMeta(
    'serviceType',
  );
  @override
  late final GeneratedColumn<String> serviceType = GeneratedColumn<String>(
    'service_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bills'),
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerCostCentsMeta = const VerificationMeta(
    'providerCostCents',
  );
  @override
  late final GeneratedColumn<int> providerCostCents = GeneratedColumn<int>(
    'provider_cost_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profitBaseCentsMeta = const VerificationMeta(
    'profitBaseCents',
  );
  @override
  late final GeneratedColumn<int> profitBaseCents = GeneratedColumn<int>(
    'profit_base_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bonusProfitCentsMeta = const VerificationMeta(
    'bonusProfitCents',
  );
  @override
  late final GeneratedColumn<int> bonusProfitCents = GeneratedColumn<int>(
    'bonus_profit_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _profitCentsMeta = const VerificationMeta(
    'profitCents',
  );
  @override
  late final GeneratedColumn<int> profitCents = GeneratedColumn<int>(
    'profit_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finalProfitCentsMeta = const VerificationMeta(
    'finalProfitCents',
  );
  @override
  late final GeneratedColumn<int> finalProfitCents = GeneratedColumn<int>(
    'final_profit_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _profitPercentMeta = const VerificationMeta(
    'profitPercent',
  );
  @override
  late final GeneratedColumn<double> profitPercent = GeneratedColumn<double>(
    'profit_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _reversedAtMeta = const VerificationMeta(
    'reversedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reversedAt = GeneratedColumn<DateTime>(
    'reversed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    provider,
    providerLabel,
    serviceType,
    customerName,
    amountCents,
    providerCostCents,
    createdAt,
    notes,
    saleId,
    profitBaseCents,
    bonusProfitCents,
    profitCents,
    finalProfitCents,
    profitPercent,
    status,
    reversedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('provider_label')) {
      context.handle(
        _providerLabelMeta,
        providerLabel.isAcceptableOrUnknown(
          data['provider_label']!,
          _providerLabelMeta,
        ),
      );
    }
    if (data.containsKey('service_type')) {
      context.handle(
        _serviceTypeMeta,
        serviceType.isAcceptableOrUnknown(
          data['service_type']!,
          _serviceTypeMeta,
        ),
      );
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('provider_cost_cents')) {
      context.handle(
        _providerCostCentsMeta,
        providerCostCents.isAcceptableOrUnknown(
          data['provider_cost_cents']!,
          _providerCostCentsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    }
    if (data.containsKey('profit_base_cents')) {
      context.handle(
        _profitBaseCentsMeta,
        profitBaseCents.isAcceptableOrUnknown(
          data['profit_base_cents']!,
          _profitBaseCentsMeta,
        ),
      );
    }
    if (data.containsKey('bonus_profit_cents')) {
      context.handle(
        _bonusProfitCentsMeta,
        bonusProfitCents.isAcceptableOrUnknown(
          data['bonus_profit_cents']!,
          _bonusProfitCentsMeta,
        ),
      );
    }
    if (data.containsKey('profit_cents')) {
      context.handle(
        _profitCentsMeta,
        profitCents.isAcceptableOrUnknown(
          data['profit_cents']!,
          _profitCentsMeta,
        ),
      );
    }
    if (data.containsKey('final_profit_cents')) {
      context.handle(
        _finalProfitCentsMeta,
        finalProfitCents.isAcceptableOrUnknown(
          data['final_profit_cents']!,
          _finalProfitCentsMeta,
        ),
      );
    }
    if (data.containsKey('profit_percent')) {
      context.handle(
        _profitPercentMeta,
        profitPercent.isAcceptableOrUnknown(
          data['profit_percent']!,
          _profitPercentMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('reversed_at')) {
      context.handle(
        _reversedAtMeta,
        reversedAt.isAcceptableOrUnknown(data['reversed_at']!, _reversedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      providerLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_label'],
      ),
      serviceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_type'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      providerCostCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}provider_cost_cents'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      ),
      profitBaseCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profit_base_cents'],
      )!,
      bonusProfitCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bonus_profit_cents'],
      )!,
      profitCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profit_cents'],
      ),
      finalProfitCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}final_profit_cents'],
      )!,
      profitPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}profit_percent'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      reversedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reversed_at'],
      ),
    );
  }

  @override
  $ServiceTransactionsTable createAlias(String alias) {
    return $ServiceTransactionsTable(attachedDatabase, alias);
  }
}

class ServiceTransaction extends DataClass
    implements Insertable<ServiceTransaction> {
  final String id;
  final String category;
  final String provider;
  final String? providerLabel;
  final String serviceType;
  final String? customerName;
  final int amountCents;
  final int providerCostCents;
  final DateTime createdAt;
  final String? notes;
  final String? saleId;
  final int profitBaseCents;
  final int bonusProfitCents;
  final int? profitCents;
  final int finalProfitCents;
  final double profitPercent;
  final String status;
  final DateTime? reversedAt;
  const ServiceTransaction({
    required this.id,
    required this.category,
    required this.provider,
    this.providerLabel,
    required this.serviceType,
    this.customerName,
    required this.amountCents,
    required this.providerCostCents,
    required this.createdAt,
    this.notes,
    this.saleId,
    required this.profitBaseCents,
    required this.bonusProfitCents,
    this.profitCents,
    required this.finalProfitCents,
    required this.profitPercent,
    required this.status,
    this.reversedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category'] = Variable<String>(category);
    map['provider'] = Variable<String>(provider);
    if (!nullToAbsent || providerLabel != null) {
      map['provider_label'] = Variable<String>(providerLabel);
    }
    map['service_type'] = Variable<String>(serviceType);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    map['amount_cents'] = Variable<int>(amountCents);
    map['provider_cost_cents'] = Variable<int>(providerCostCents);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || saleId != null) {
      map['sale_id'] = Variable<String>(saleId);
    }
    map['profit_base_cents'] = Variable<int>(profitBaseCents);
    map['bonus_profit_cents'] = Variable<int>(bonusProfitCents);
    if (!nullToAbsent || profitCents != null) {
      map['profit_cents'] = Variable<int>(profitCents);
    }
    map['final_profit_cents'] = Variable<int>(finalProfitCents);
    map['profit_percent'] = Variable<double>(profitPercent);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reversedAt != null) {
      map['reversed_at'] = Variable<DateTime>(reversedAt);
    }
    return map;
  }

  ServiceTransactionsCompanion toCompanion(bool nullToAbsent) {
    return ServiceTransactionsCompanion(
      id: Value(id),
      category: Value(category),
      provider: Value(provider),
      providerLabel: providerLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(providerLabel),
      serviceType: Value(serviceType),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      amountCents: Value(amountCents),
      providerCostCents: Value(providerCostCents),
      createdAt: Value(createdAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      saleId: saleId == null && nullToAbsent
          ? const Value.absent()
          : Value(saleId),
      profitBaseCents: Value(profitBaseCents),
      bonusProfitCents: Value(bonusProfitCents),
      profitCents: profitCents == null && nullToAbsent
          ? const Value.absent()
          : Value(profitCents),
      finalProfitCents: Value(finalProfitCents),
      profitPercent: Value(profitPercent),
      status: Value(status),
      reversedAt: reversedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reversedAt),
    );
  }

  factory ServiceTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceTransaction(
      id: serializer.fromJson<String>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      provider: serializer.fromJson<String>(json['provider']),
      providerLabel: serializer.fromJson<String?>(json['providerLabel']),
      serviceType: serializer.fromJson<String>(json['serviceType']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      providerCostCents: serializer.fromJson<int>(json['providerCostCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      saleId: serializer.fromJson<String?>(json['saleId']),
      profitBaseCents: serializer.fromJson<int>(json['profitBaseCents']),
      bonusProfitCents: serializer.fromJson<int>(json['bonusProfitCents']),
      profitCents: serializer.fromJson<int?>(json['profitCents']),
      finalProfitCents: serializer.fromJson<int>(json['finalProfitCents']),
      profitPercent: serializer.fromJson<double>(json['profitPercent']),
      status: serializer.fromJson<String>(json['status']),
      reversedAt: serializer.fromJson<DateTime?>(json['reversedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(category),
      'provider': serializer.toJson<String>(provider),
      'providerLabel': serializer.toJson<String?>(providerLabel),
      'serviceType': serializer.toJson<String>(serviceType),
      'customerName': serializer.toJson<String?>(customerName),
      'amountCents': serializer.toJson<int>(amountCents),
      'providerCostCents': serializer.toJson<int>(providerCostCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'notes': serializer.toJson<String?>(notes),
      'saleId': serializer.toJson<String?>(saleId),
      'profitBaseCents': serializer.toJson<int>(profitBaseCents),
      'bonusProfitCents': serializer.toJson<int>(bonusProfitCents),
      'profitCents': serializer.toJson<int?>(profitCents),
      'finalProfitCents': serializer.toJson<int>(finalProfitCents),
      'profitPercent': serializer.toJson<double>(profitPercent),
      'status': serializer.toJson<String>(status),
      'reversedAt': serializer.toJson<DateTime?>(reversedAt),
    };
  }

  ServiceTransaction copyWith({
    String? id,
    String? category,
    String? provider,
    Value<String?> providerLabel = const Value.absent(),
    String? serviceType,
    Value<String?> customerName = const Value.absent(),
    int? amountCents,
    int? providerCostCents,
    DateTime? createdAt,
    Value<String?> notes = const Value.absent(),
    Value<String?> saleId = const Value.absent(),
    int? profitBaseCents,
    int? bonusProfitCents,
    Value<int?> profitCents = const Value.absent(),
    int? finalProfitCents,
    double? profitPercent,
    String? status,
    Value<DateTime?> reversedAt = const Value.absent(),
  }) => ServiceTransaction(
    id: id ?? this.id,
    category: category ?? this.category,
    provider: provider ?? this.provider,
    providerLabel: providerLabel.present
        ? providerLabel.value
        : this.providerLabel,
    serviceType: serviceType ?? this.serviceType,
    customerName: customerName.present ? customerName.value : this.customerName,
    amountCents: amountCents ?? this.amountCents,
    providerCostCents: providerCostCents ?? this.providerCostCents,
    createdAt: createdAt ?? this.createdAt,
    notes: notes.present ? notes.value : this.notes,
    saleId: saleId.present ? saleId.value : this.saleId,
    profitBaseCents: profitBaseCents ?? this.profitBaseCents,
    bonusProfitCents: bonusProfitCents ?? this.bonusProfitCents,
    profitCents: profitCents.present ? profitCents.value : this.profitCents,
    finalProfitCents: finalProfitCents ?? this.finalProfitCents,
    profitPercent: profitPercent ?? this.profitPercent,
    status: status ?? this.status,
    reversedAt: reversedAt.present ? reversedAt.value : this.reversedAt,
  );
  ServiceTransaction copyWithCompanion(ServiceTransactionsCompanion data) {
    return ServiceTransaction(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      provider: data.provider.present ? data.provider.value : this.provider,
      providerLabel: data.providerLabel.present
          ? data.providerLabel.value
          : this.providerLabel,
      serviceType: data.serviceType.present
          ? data.serviceType.value
          : this.serviceType,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      providerCostCents: data.providerCostCents.present
          ? data.providerCostCents.value
          : this.providerCostCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      profitBaseCents: data.profitBaseCents.present
          ? data.profitBaseCents.value
          : this.profitBaseCents,
      bonusProfitCents: data.bonusProfitCents.present
          ? data.bonusProfitCents.value
          : this.bonusProfitCents,
      profitCents: data.profitCents.present
          ? data.profitCents.value
          : this.profitCents,
      finalProfitCents: data.finalProfitCents.present
          ? data.finalProfitCents.value
          : this.finalProfitCents,
      profitPercent: data.profitPercent.present
          ? data.profitPercent.value
          : this.profitPercent,
      status: data.status.present ? data.status.value : this.status,
      reversedAt: data.reversedAt.present
          ? data.reversedAt.value
          : this.reversedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceTransaction(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('provider: $provider, ')
          ..write('providerLabel: $providerLabel, ')
          ..write('serviceType: $serviceType, ')
          ..write('customerName: $customerName, ')
          ..write('amountCents: $amountCents, ')
          ..write('providerCostCents: $providerCostCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('notes: $notes, ')
          ..write('saleId: $saleId, ')
          ..write('profitBaseCents: $profitBaseCents, ')
          ..write('bonusProfitCents: $bonusProfitCents, ')
          ..write('profitCents: $profitCents, ')
          ..write('finalProfitCents: $finalProfitCents, ')
          ..write('profitPercent: $profitPercent, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    provider,
    providerLabel,
    serviceType,
    customerName,
    amountCents,
    providerCostCents,
    createdAt,
    notes,
    saleId,
    profitBaseCents,
    bonusProfitCents,
    profitCents,
    finalProfitCents,
    profitPercent,
    status,
    reversedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceTransaction &&
          other.id == this.id &&
          other.category == this.category &&
          other.provider == this.provider &&
          other.providerLabel == this.providerLabel &&
          other.serviceType == this.serviceType &&
          other.customerName == this.customerName &&
          other.amountCents == this.amountCents &&
          other.providerCostCents == this.providerCostCents &&
          other.createdAt == this.createdAt &&
          other.notes == this.notes &&
          other.saleId == this.saleId &&
          other.profitBaseCents == this.profitBaseCents &&
          other.bonusProfitCents == this.bonusProfitCents &&
          other.profitCents == this.profitCents &&
          other.finalProfitCents == this.finalProfitCents &&
          other.profitPercent == this.profitPercent &&
          other.status == this.status &&
          other.reversedAt == this.reversedAt);
}

class ServiceTransactionsCompanion extends UpdateCompanion<ServiceTransaction> {
  final Value<String> id;
  final Value<String> category;
  final Value<String> provider;
  final Value<String?> providerLabel;
  final Value<String> serviceType;
  final Value<String?> customerName;
  final Value<int> amountCents;
  final Value<int> providerCostCents;
  final Value<DateTime> createdAt;
  final Value<String?> notes;
  final Value<String?> saleId;
  final Value<int> profitBaseCents;
  final Value<int> bonusProfitCents;
  final Value<int?> profitCents;
  final Value<int> finalProfitCents;
  final Value<double> profitPercent;
  final Value<String> status;
  final Value<DateTime?> reversedAt;
  final Value<int> rowid;
  const ServiceTransactionsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.provider = const Value.absent(),
    this.providerLabel = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.customerName = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.providerCostCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.saleId = const Value.absent(),
    this.profitBaseCents = const Value.absent(),
    this.bonusProfitCents = const Value.absent(),
    this.profitCents = const Value.absent(),
    this.finalProfitCents = const Value.absent(),
    this.profitPercent = const Value.absent(),
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceTransactionsCompanion.insert({
    required String id,
    required String category,
    required String provider,
    this.providerLabel = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.customerName = const Value.absent(),
    required int amountCents,
    this.providerCostCents = const Value.absent(),
    required DateTime createdAt,
    this.notes = const Value.absent(),
    this.saleId = const Value.absent(),
    this.profitBaseCents = const Value.absent(),
    this.bonusProfitCents = const Value.absent(),
    this.profitCents = const Value.absent(),
    this.finalProfitCents = const Value.absent(),
    this.profitPercent = const Value.absent(),
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       category = Value(category),
       provider = Value(provider),
       amountCents = Value(amountCents),
       createdAt = Value(createdAt);
  static Insertable<ServiceTransaction> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<String>? provider,
    Expression<String>? providerLabel,
    Expression<String>? serviceType,
    Expression<String>? customerName,
    Expression<int>? amountCents,
    Expression<int>? providerCostCents,
    Expression<DateTime>? createdAt,
    Expression<String>? notes,
    Expression<String>? saleId,
    Expression<int>? profitBaseCents,
    Expression<int>? bonusProfitCents,
    Expression<int>? profitCents,
    Expression<int>? finalProfitCents,
    Expression<double>? profitPercent,
    Expression<String>? status,
    Expression<DateTime>? reversedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (provider != null) 'provider': provider,
      if (providerLabel != null) 'provider_label': providerLabel,
      if (serviceType != null) 'service_type': serviceType,
      if (customerName != null) 'customer_name': customerName,
      if (amountCents != null) 'amount_cents': amountCents,
      if (providerCostCents != null) 'provider_cost_cents': providerCostCents,
      if (createdAt != null) 'created_at': createdAt,
      if (notes != null) 'notes': notes,
      if (saleId != null) 'sale_id': saleId,
      if (profitBaseCents != null) 'profit_base_cents': profitBaseCents,
      if (bonusProfitCents != null) 'bonus_profit_cents': bonusProfitCents,
      if (profitCents != null) 'profit_cents': profitCents,
      if (finalProfitCents != null) 'final_profit_cents': finalProfitCents,
      if (profitPercent != null) 'profit_percent': profitPercent,
      if (status != null) 'status': status,
      if (reversedAt != null) 'reversed_at': reversedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? category,
    Value<String>? provider,
    Value<String?>? providerLabel,
    Value<String>? serviceType,
    Value<String?>? customerName,
    Value<int>? amountCents,
    Value<int>? providerCostCents,
    Value<DateTime>? createdAt,
    Value<String?>? notes,
    Value<String?>? saleId,
    Value<int>? profitBaseCents,
    Value<int>? bonusProfitCents,
    Value<int?>? profitCents,
    Value<int>? finalProfitCents,
    Value<double>? profitPercent,
    Value<String>? status,
    Value<DateTime?>? reversedAt,
    Value<int>? rowid,
  }) {
    return ServiceTransactionsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      provider: provider ?? this.provider,
      providerLabel: providerLabel ?? this.providerLabel,
      serviceType: serviceType ?? this.serviceType,
      customerName: customerName ?? this.customerName,
      amountCents: amountCents ?? this.amountCents,
      providerCostCents: providerCostCents ?? this.providerCostCents,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      saleId: saleId ?? this.saleId,
      profitBaseCents: profitBaseCents ?? this.profitBaseCents,
      bonusProfitCents: bonusProfitCents ?? this.bonusProfitCents,
      profitCents: profitCents ?? this.profitCents,
      finalProfitCents: finalProfitCents ?? this.finalProfitCents,
      profitPercent: profitPercent ?? this.profitPercent,
      status: status ?? this.status,
      reversedAt: reversedAt ?? this.reversedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (providerLabel.present) {
      map['provider_label'] = Variable<String>(providerLabel.value);
    }
    if (serviceType.present) {
      map['service_type'] = Variable<String>(serviceType.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (providerCostCents.present) {
      map['provider_cost_cents'] = Variable<int>(providerCostCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (profitBaseCents.present) {
      map['profit_base_cents'] = Variable<int>(profitBaseCents.value);
    }
    if (bonusProfitCents.present) {
      map['bonus_profit_cents'] = Variable<int>(bonusProfitCents.value);
    }
    if (profitCents.present) {
      map['profit_cents'] = Variable<int>(profitCents.value);
    }
    if (finalProfitCents.present) {
      map['final_profit_cents'] = Variable<int>(finalProfitCents.value);
    }
    if (profitPercent.present) {
      map['profit_percent'] = Variable<double>(profitPercent.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reversedAt.present) {
      map['reversed_at'] = Variable<DateTime>(reversedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('provider: $provider, ')
          ..write('providerLabel: $providerLabel, ')
          ..write('serviceType: $serviceType, ')
          ..write('customerName: $customerName, ')
          ..write('amountCents: $amountCents, ')
          ..write('providerCostCents: $providerCostCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('notes: $notes, ')
          ..write('saleId: $saleId, ')
          ..write('profitBaseCents: $profitBaseCents, ')
          ..write('bonusProfitCents: $bonusProfitCents, ')
          ..write('profitCents: $profitCents, ')
          ..write('finalProfitCents: $finalProfitCents, ')
          ..write('profitPercent: $profitPercent, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashDrawerEventsTable extends CashDrawerEvents
    with TableInfo<$CashDrawerEventsTable, CashDrawerEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashDrawerEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, eventType, createdAt, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_drawer_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashDrawerEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashDrawerEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashDrawerEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $CashDrawerEventsTable createAlias(String alias) {
    return $CashDrawerEventsTable(attachedDatabase, alias);
  }
}

class CashDrawerEvent extends DataClass implements Insertable<CashDrawerEvent> {
  final int id;
  final String eventType;
  final DateTime createdAt;
  final String? notes;
  const CashDrawerEvent({
    required this.id,
    required this.eventType,
    required this.createdAt,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_type'] = Variable<String>(eventType);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  CashDrawerEventsCompanion toCompanion(bool nullToAbsent) {
    return CashDrawerEventsCompanion(
      id: Value(id),
      eventType: Value(eventType),
      createdAt: Value(createdAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory CashDrawerEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashDrawerEvent(
      id: serializer.fromJson<int>(json['id']),
      eventType: serializer.fromJson<String>(json['eventType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventType': serializer.toJson<String>(eventType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  CashDrawerEvent copyWith({
    int? id,
    String? eventType,
    DateTime? createdAt,
    Value<String?> notes = const Value.absent(),
  }) => CashDrawerEvent(
    id: id ?? this.id,
    eventType: eventType ?? this.eventType,
    createdAt: createdAt ?? this.createdAt,
    notes: notes.present ? notes.value : this.notes,
  );
  CashDrawerEvent copyWithCompanion(CashDrawerEventsCompanion data) {
    return CashDrawerEvent(
      id: data.id.present ? data.id.value : this.id,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashDrawerEvent(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('createdAt: $createdAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventType, createdAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashDrawerEvent &&
          other.id == this.id &&
          other.eventType == this.eventType &&
          other.createdAt == this.createdAt &&
          other.notes == this.notes);
}

class CashDrawerEventsCompanion extends UpdateCompanion<CashDrawerEvent> {
  final Value<int> id;
  final Value<String> eventType;
  final Value<DateTime> createdAt;
  final Value<String?> notes;
  const CashDrawerEventsCompanion({
    this.id = const Value.absent(),
    this.eventType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.notes = const Value.absent(),
  });
  CashDrawerEventsCompanion.insert({
    this.id = const Value.absent(),
    required String eventType,
    required DateTime createdAt,
    this.notes = const Value.absent(),
  }) : eventType = Value(eventType),
       createdAt = Value(createdAt);
  static Insertable<CashDrawerEvent> custom({
    Expression<int>? id,
    Expression<String>? eventType,
    Expression<DateTime>? createdAt,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventType != null) 'event_type': eventType,
      if (createdAt != null) 'created_at': createdAt,
      if (notes != null) 'notes': notes,
    });
  }

  CashDrawerEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? eventType,
    Value<DateTime>? createdAt,
    Value<String?>? notes,
  }) {
    return CashDrawerEventsCompanion(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashDrawerEventsCompanion(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('createdAt: $createdAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $ServiceDailyInventoryTable extends ServiceDailyInventory
    with TableInfo<$ServiceDailyInventoryTable, ServiceDailyInventoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceDailyInventoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingBalanceCentsMeta =
      const VerificationMeta('openingBalanceCents');
  @override
  late final GeneratedColumn<int> openingBalanceCents = GeneratedColumn<int>(
    'opening_balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _closingBalanceCentsMeta =
      const VerificationMeta('closingBalanceCents');
  @override
  late final GeneratedColumn<int> closingBalanceCents = GeneratedColumn<int>(
    'closing_balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    provider,
    openingBalanceCents,
    closingBalanceCents,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_daily_inventory';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceDailyInventoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('opening_balance_cents')) {
      context.handle(
        _openingBalanceCentsMeta,
        openingBalanceCents.isAcceptableOrUnknown(
          data['opening_balance_cents']!,
          _openingBalanceCentsMeta,
        ),
      );
    }
    if (data.containsKey('closing_balance_cents')) {
      context.handle(
        _closingBalanceCentsMeta,
        closingBalanceCents.isAcceptableOrUnknown(
          data['closing_balance_cents']!,
          _closingBalanceCentsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceDailyInventoryData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceDailyInventoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      openingBalanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance_cents'],
      )!,
      closingBalanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}closing_balance_cents'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ServiceDailyInventoryTable createAlias(String alias) {
    return $ServiceDailyInventoryTable(attachedDatabase, alias);
  }
}

class ServiceDailyInventoryData extends DataClass
    implements Insertable<ServiceDailyInventoryData> {
  final String id;
  final DateTime date;
  final String provider;
  final int openingBalanceCents;
  final int closingBalanceCents;
  final String? notes;
  final DateTime createdAt;
  const ServiceDailyInventoryData({
    required this.id,
    required this.date,
    required this.provider,
    required this.openingBalanceCents,
    required this.closingBalanceCents,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['provider'] = Variable<String>(provider);
    map['opening_balance_cents'] = Variable<int>(openingBalanceCents);
    map['closing_balance_cents'] = Variable<int>(closingBalanceCents);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ServiceDailyInventoryCompanion toCompanion(bool nullToAbsent) {
    return ServiceDailyInventoryCompanion(
      id: Value(id),
      date: Value(date),
      provider: Value(provider),
      openingBalanceCents: Value(openingBalanceCents),
      closingBalanceCents: Value(closingBalanceCents),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory ServiceDailyInventoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceDailyInventoryData(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      provider: serializer.fromJson<String>(json['provider']),
      openingBalanceCents: serializer.fromJson<int>(
        json['openingBalanceCents'],
      ),
      closingBalanceCents: serializer.fromJson<int>(
        json['closingBalanceCents'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'provider': serializer.toJson<String>(provider),
      'openingBalanceCents': serializer.toJson<int>(openingBalanceCents),
      'closingBalanceCents': serializer.toJson<int>(closingBalanceCents),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ServiceDailyInventoryData copyWith({
    String? id,
    DateTime? date,
    String? provider,
    int? openingBalanceCents,
    int? closingBalanceCents,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => ServiceDailyInventoryData(
    id: id ?? this.id,
    date: date ?? this.date,
    provider: provider ?? this.provider,
    openingBalanceCents: openingBalanceCents ?? this.openingBalanceCents,
    closingBalanceCents: closingBalanceCents ?? this.closingBalanceCents,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  ServiceDailyInventoryData copyWithCompanion(
    ServiceDailyInventoryCompanion data,
  ) {
    return ServiceDailyInventoryData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      provider: data.provider.present ? data.provider.value : this.provider,
      openingBalanceCents: data.openingBalanceCents.present
          ? data.openingBalanceCents.value
          : this.openingBalanceCents,
      closingBalanceCents: data.closingBalanceCents.present
          ? data.closingBalanceCents.value
          : this.closingBalanceCents,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceDailyInventoryData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('provider: $provider, ')
          ..write('openingBalanceCents: $openingBalanceCents, ')
          ..write('closingBalanceCents: $closingBalanceCents, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    provider,
    openingBalanceCents,
    closingBalanceCents,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceDailyInventoryData &&
          other.id == this.id &&
          other.date == this.date &&
          other.provider == this.provider &&
          other.openingBalanceCents == this.openingBalanceCents &&
          other.closingBalanceCents == this.closingBalanceCents &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class ServiceDailyInventoryCompanion
    extends UpdateCompanion<ServiceDailyInventoryData> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> provider;
  final Value<int> openingBalanceCents;
  final Value<int> closingBalanceCents;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ServiceDailyInventoryCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.provider = const Value.absent(),
    this.openingBalanceCents = const Value.absent(),
    this.closingBalanceCents = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceDailyInventoryCompanion.insert({
    required String id,
    required DateTime date,
    required String provider,
    this.openingBalanceCents = const Value.absent(),
    this.closingBalanceCents = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       provider = Value(provider);
  static Insertable<ServiceDailyInventoryData> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? provider,
    Expression<int>? openingBalanceCents,
    Expression<int>? closingBalanceCents,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (provider != null) 'provider': provider,
      if (openingBalanceCents != null)
        'opening_balance_cents': openingBalanceCents,
      if (closingBalanceCents != null)
        'closing_balance_cents': closingBalanceCents,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceDailyInventoryCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String>? provider,
    Value<int>? openingBalanceCents,
    Value<int>? closingBalanceCents,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ServiceDailyInventoryCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      provider: provider ?? this.provider,
      openingBalanceCents: openingBalanceCents ?? this.openingBalanceCents,
      closingBalanceCents: closingBalanceCents ?? this.closingBalanceCents,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (openingBalanceCents.present) {
      map['opening_balance_cents'] = Variable<int>(openingBalanceCents.value);
    }
    if (closingBalanceCents.present) {
      map['closing_balance_cents'] = Variable<int>(closingBalanceCents.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceDailyInventoryCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('provider: $provider, ')
          ..write('openingBalanceCents: $openingBalanceCents, ')
          ..write('closingBalanceCents: $closingBalanceCents, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SideRevenueTable extends SideRevenue
    with TableInfo<$SideRevenueTable, SideRevenueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SideRevenueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operatedAtMeta = const VerificationMeta(
    'operatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> operatedAt = GeneratedColumn<DateTime>(
    'operated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _reversedAtMeta = const VerificationMeta(
    'reversedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reversedAt = GeneratedColumn<DateTime>(
    'reversed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    description,
    customerName,
    amount,
    operatedAt,
    notes,
    createdAt,
    status,
    reversedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'side_revenue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SideRevenueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('operated_at')) {
      context.handle(
        _operatedAtMeta,
        operatedAt.isAcceptableOrUnknown(data['operated_at']!, _operatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_operatedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('reversed_at')) {
      context.handle(
        _reversedAtMeta,
        reversedAt.isAcceptableOrUnknown(data['reversed_at']!, _reversedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SideRevenueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SideRevenueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      operatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}operated_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      reversedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reversed_at'],
      ),
    );
  }

  @override
  $SideRevenueTable createAlias(String alias) {
    return $SideRevenueTable(attachedDatabase, alias);
  }
}

class SideRevenueData extends DataClass implements Insertable<SideRevenueData> {
  final String id;
  final String category;
  final String description;
  final String? customerName;
  final int amount;
  final DateTime operatedAt;
  final String? notes;
  final DateTime createdAt;
  final String status;
  final DateTime? reversedAt;
  const SideRevenueData({
    required this.id,
    required this.category,
    required this.description,
    this.customerName,
    required this.amount,
    required this.operatedAt,
    this.notes,
    required this.createdAt,
    required this.status,
    this.reversedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category'] = Variable<String>(category);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    map['amount'] = Variable<int>(amount);
    map['operated_at'] = Variable<DateTime>(operatedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reversedAt != null) {
      map['reversed_at'] = Variable<DateTime>(reversedAt);
    }
    return map;
  }

  SideRevenueCompanion toCompanion(bool nullToAbsent) {
    return SideRevenueCompanion(
      id: Value(id),
      category: Value(category),
      description: Value(description),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      amount: Value(amount),
      operatedAt: Value(operatedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      status: Value(status),
      reversedAt: reversedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reversedAt),
    );
  }

  factory SideRevenueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SideRevenueData(
      id: serializer.fromJson<String>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String>(json['description']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      amount: serializer.fromJson<int>(json['amount']),
      operatedAt: serializer.fromJson<DateTime>(json['operatedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      reversedAt: serializer.fromJson<DateTime?>(json['reversedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String>(description),
      'customerName': serializer.toJson<String?>(customerName),
      'amount': serializer.toJson<int>(amount),
      'operatedAt': serializer.toJson<DateTime>(operatedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'reversedAt': serializer.toJson<DateTime?>(reversedAt),
    };
  }

  SideRevenueData copyWith({
    String? id,
    String? category,
    String? description,
    Value<String?> customerName = const Value.absent(),
    int? amount,
    DateTime? operatedAt,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    String? status,
    Value<DateTime?> reversedAt = const Value.absent(),
  }) => SideRevenueData(
    id: id ?? this.id,
    category: category ?? this.category,
    description: description ?? this.description,
    customerName: customerName.present ? customerName.value : this.customerName,
    amount: amount ?? this.amount,
    operatedAt: operatedAt ?? this.operatedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    reversedAt: reversedAt.present ? reversedAt.value : this.reversedAt,
  );
  SideRevenueData copyWithCompanion(SideRevenueCompanion data) {
    return SideRevenueData(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      amount: data.amount.present ? data.amount.value : this.amount,
      operatedAt: data.operatedAt.present
          ? data.operatedAt.value
          : this.operatedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      reversedAt: data.reversedAt.present
          ? data.reversedAt.value
          : this.reversedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SideRevenueData(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('customerName: $customerName, ')
          ..write('amount: $amount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    description,
    customerName,
    amount,
    operatedAt,
    notes,
    createdAt,
    status,
    reversedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SideRevenueData &&
          other.id == this.id &&
          other.category == this.category &&
          other.description == this.description &&
          other.customerName == this.customerName &&
          other.amount == this.amount &&
          other.operatedAt == this.operatedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.reversedAt == this.reversedAt);
}

class SideRevenueCompanion extends UpdateCompanion<SideRevenueData> {
  final Value<String> id;
  final Value<String> category;
  final Value<String> description;
  final Value<String?> customerName;
  final Value<int> amount;
  final Value<DateTime> operatedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<DateTime?> reversedAt;
  final Value<int> rowid;
  const SideRevenueCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.customerName = const Value.absent(),
    this.amount = const Value.absent(),
    this.operatedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SideRevenueCompanion.insert({
    required String id,
    required String category,
    required String description,
    this.customerName = const Value.absent(),
    required int amount,
    required DateTime operatedAt,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       category = Value(category),
       description = Value(description),
       amount = Value(amount),
       operatedAt = Value(operatedAt),
       createdAt = Value(createdAt);
  static Insertable<SideRevenueData> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? customerName,
    Expression<int>? amount,
    Expression<DateTime>? operatedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<DateTime>? reversedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (customerName != null) 'customer_name': customerName,
      if (amount != null) 'amount': amount,
      if (operatedAt != null) 'operated_at': operatedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (reversedAt != null) 'reversed_at': reversedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SideRevenueCompanion copyWith({
    Value<String>? id,
    Value<String>? category,
    Value<String>? description,
    Value<String?>? customerName,
    Value<int>? amount,
    Value<DateTime>? operatedAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<DateTime?>? reversedAt,
    Value<int>? rowid,
  }) {
    return SideRevenueCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      description: description ?? this.description,
      customerName: customerName ?? this.customerName,
      amount: amount ?? this.amount,
      operatedAt: operatedAt ?? this.operatedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      reversedAt: reversedAt ?? this.reversedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (operatedAt.present) {
      map['operated_at'] = Variable<DateTime>(operatedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reversedAt.present) {
      map['reversed_at'] = Variable<DateTime>(reversedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SideRevenueCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('customerName: $customerName, ')
          ..write('amount: $amount, ')
          ..write('operatedAt: $operatedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('reversedAt: $reversedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $PurchaseInvoicesTable purchaseInvoices = $PurchaseInvoicesTable(
    this,
  );
  late final $PurchaseInvoiceItemsTable purchaseInvoiceItems =
      $PurchaseInvoiceItemsTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $PurchaseItemsTable purchaseItems = $PurchaseItemsTable(this);
  late final $PurchasePaymentsTable purchasePayments = $PurchasePaymentsTable(
    this,
  );
  late final $RepairsTable repairs = $RepairsTable(this);
  late final $RepairPartsTable repairParts = $RepairPartsTable(this);
  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);
  late final $DebtsTable debts = $DebtsTable(this);
  late final $ElectricityRechargesTable electricityRecharges =
      $ElectricityRechargesTable(this);
  late final $WalletOperationsTable walletOperations = $WalletOperationsTable(
    this,
  );
  late final $TelelinkOperationsTable telelinkOperations =
      $TelelinkOperationsTable(this);
  late final $FarahnetPaymentsTable farahnetPayments = $FarahnetPaymentsTable(
    this,
  );
  late final $ProgramTopupsTable programTopups = $ProgramTopupsTable(this);
  late final $SettlementsTable settlements = $SettlementsTable(this);
  late final $RepairPartOrdersTable repairPartOrders = $RepairPartOrdersTable(
    this,
  );
  late final $ServiceTransactionsTable serviceTransactions =
      $ServiceTransactionsTable(this);
  late final $CashDrawerEventsTable cashDrawerEvents = $CashDrawerEventsTable(
    this,
  );
  late final $ServiceDailyInventoryTable serviceDailyInventory =
      $ServiceDailyInventoryTable(this);
  late final $SideRevenueTable sideRevenue = $SideRevenueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    customers,
    payments,
    sales,
    saleItems,
    purchaseInvoices,
    purchaseInvoiceItems,
    suppliers,
    purchases,
    purchaseItems,
    purchasePayments,
    repairs,
    repairParts,
    stockMovements,
    debts,
    electricityRecharges,
    walletOperations,
    telelinkOperations,
    farahnetPayments,
    programTopups,
    settlements,
    repairPartOrders,
    serviceTransactions,
    cashDrawerEvents,
    serviceDailyInventory,
    sideRevenue,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String name,
      Value<String?> barcode,
      required String category,
      Value<String?> supplierId,
      required int sellPrice,
      required int costPrice,
      required int qty,
      required bool trackImei,
      Value<String?> imagePath,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> barcode,
      Value<String> category,
      Value<String?> supplierId,
      Value<int> sellPrice,
      Value<int> costPrice,
      Value<int> qty,
      Value<bool> trackImei,
      Value<String?> imagePath,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellPrice => $composableBuilder(
    column: $table.sellPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get trackImei => $composableBuilder(
    column: $table.trackImei,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellPrice => $composableBuilder(
    column: $table.sellPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get trackImei => $composableBuilder(
    column: $table.trackImei,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sellPrice =>
      $composableBuilder(column: $table.sellPrice, builder: (column) => column);

  GeneratedColumn<int> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<bool> get trackImei =>
      $composableBuilder(column: $table.trackImei, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<int> sellPrice = const Value.absent(),
                Value<int> costPrice = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<bool> trackImei = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
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
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> barcode = const Value.absent(),
                required String category,
                Value<String?> supplierId = const Value.absent(),
                required int sellPrice,
                required int costPrice,
                required int qty,
                required bool trackImei,
                Value<String?> imagePath = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
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
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      required String name,
      Value<String?> phone,
      Value<int> balance,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> phone,
      Value<int> balance,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<int> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
          Customer,
          PrefetchHooks Function()
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<int> balance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                name: name,
                phone: phone,
                balance: balance,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<int> balance = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                balance: balance,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
      Customer,
      PrefetchHooks Function()
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      required String id,
      required String customerId,
      required int amount,
      required String direction,
      Value<String?> note,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<String> id,
      Value<String> customerId,
      Value<int> amount,
      Value<String> direction,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
          Payment,
          PrefetchHooks Function()
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                customerId: customerId,
                amount: amount,
                direction: direction,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerId,
                required int amount,
                required String direction,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                customerId: customerId,
                amount: amount,
                direction: direction,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
      Payment,
      PrefetchHooks Function()
    >;
typedef $$SalesTableCreateCompanionBuilder =
    SalesCompanion Function({
      required String id,
      Value<String?> customerId,
      required int total,
      required int discount,
      required int paid,
      required String paymentType,
      required DateTime createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });
typedef $$SalesTableUpdateCompanionBuilder =
    SalesCompanion Function({
      Value<String> id,
      Value<String?> customerId,
      Value<int> total,
      Value<int> discount,
      Value<int> paid,
      Value<String> paymentType,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<int> get paid =>
      $composableBuilder(column: $table.paid, builder: (column) => column);

  GeneratedColumn<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => column,
  );
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          Sale,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
          Sale,
          PrefetchHooks Function()
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> discount = const Value.absent(),
                Value<int> paid = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                customerId: customerId,
                total: total,
                discount: discount,
                paid: paid,
                paymentType: paymentType,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> customerId = const Value.absent(),
                required int total,
                required int discount,
                required int paid,
                required String paymentType,
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                customerId: customerId,
                total: total,
                discount: discount,
                paid: paid,
                paymentType: paymentType,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      Sale,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
      Sale,
      PrefetchHooks Function()
    >;
typedef $$SaleItemsTableCreateCompanionBuilder =
    SaleItemsCompanion Function({
      required String id,
      required String saleId,
      required String productId,
      required int qty,
      required int unitPrice,
      required int lineTotal,
      Value<int> rowid,
    });
typedef $$SaleItemsTableUpdateCompanionBuilder =
    SaleItemsCompanion Function({
      Value<String> id,
      Value<String> saleId,
      Value<String> productId,
      Value<int> qty,
      Value<int> unitPrice,
      Value<int> lineTotal,
      Value<int> rowid,
    });

class $$SaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);
}

class $$SaleItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleItemsTable,
          SaleItem,
          $$SaleItemsTableFilterComposer,
          $$SaleItemsTableOrderingComposer,
          $$SaleItemsTableAnnotationComposer,
          $$SaleItemsTableCreateCompanionBuilder,
          $$SaleItemsTableUpdateCompanionBuilder,
          (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
          SaleItem,
          PrefetchHooks Function()
        > {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                Value<int> lineTotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleItemsCompanion(
                id: id,
                saleId: saleId,
                productId: productId,
                qty: qty,
                unitPrice: unitPrice,
                lineTotal: lineTotal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleId,
                required String productId,
                required int qty,
                required int unitPrice,
                required int lineTotal,
                Value<int> rowid = const Value.absent(),
              }) => SaleItemsCompanion.insert(
                id: id,
                saleId: saleId,
                productId: productId,
                qty: qty,
                unitPrice: unitPrice,
                lineTotal: lineTotal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SaleItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleItemsTable,
      SaleItem,
      $$SaleItemsTableFilterComposer,
      $$SaleItemsTableOrderingComposer,
      $$SaleItemsTableAnnotationComposer,
      $$SaleItemsTableCreateCompanionBuilder,
      $$SaleItemsTableUpdateCompanionBuilder,
      (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
      SaleItem,
      PrefetchHooks Function()
    >;
typedef $$PurchaseInvoicesTableCreateCompanionBuilder =
    PurchaseInvoicesCompanion Function({
      required String id,
      required String invoiceNumber,
      required String supplier,
      required int total,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PurchaseInvoicesTableUpdateCompanionBuilder =
    PurchaseInvoicesCompanion Function({
      Value<String> id,
      Value<String> invoiceNumber,
      Value<String> supplier,
      Value<int> total,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PurchaseInvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseInvoicesTable> {
  $$PurchaseInvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplier => $composableBuilder(
    column: $table.supplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchaseInvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseInvoicesTable> {
  $$PurchaseInvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplier => $composableBuilder(
    column: $table.supplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseInvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseInvoicesTable> {
  $$PurchaseInvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplier =>
      $composableBuilder(column: $table.supplier, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PurchaseInvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseInvoicesTable,
          PurchaseInvoice,
          $$PurchaseInvoicesTableFilterComposer,
          $$PurchaseInvoicesTableOrderingComposer,
          $$PurchaseInvoicesTableAnnotationComposer,
          $$PurchaseInvoicesTableCreateCompanionBuilder,
          $$PurchaseInvoicesTableUpdateCompanionBuilder,
          (
            PurchaseInvoice,
            BaseReferences<
              _$AppDatabase,
              $PurchaseInvoicesTable,
              PurchaseInvoice
            >,
          ),
          PurchaseInvoice,
          PrefetchHooks Function()
        > {
  $$PurchaseInvoicesTableTableManager(
    _$AppDatabase db,
    $PurchaseInvoicesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseInvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseInvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseInvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> invoiceNumber = const Value.absent(),
                Value<String> supplier = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseInvoicesCompanion(
                id: id,
                invoiceNumber: invoiceNumber,
                supplier: supplier,
                total: total,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String invoiceNumber,
                required String supplier,
                required int total,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PurchaseInvoicesCompanion.insert(
                id: id,
                invoiceNumber: invoiceNumber,
                supplier: supplier,
                total: total,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchaseInvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseInvoicesTable,
      PurchaseInvoice,
      $$PurchaseInvoicesTableFilterComposer,
      $$PurchaseInvoicesTableOrderingComposer,
      $$PurchaseInvoicesTableAnnotationComposer,
      $$PurchaseInvoicesTableCreateCompanionBuilder,
      $$PurchaseInvoicesTableUpdateCompanionBuilder,
      (
        PurchaseInvoice,
        BaseReferences<_$AppDatabase, $PurchaseInvoicesTable, PurchaseInvoice>,
      ),
      PurchaseInvoice,
      PrefetchHooks Function()
    >;
typedef $$PurchaseInvoiceItemsTableCreateCompanionBuilder =
    PurchaseInvoiceItemsCompanion Function({
      required String id,
      required String purchaseInvoiceId,
      required String productId,
      required int qty,
      required int purchasePrice,
      required int salePrice,
      required int lineTotal,
      Value<int> rowid,
    });
typedef $$PurchaseInvoiceItemsTableUpdateCompanionBuilder =
    PurchaseInvoiceItemsCompanion Function({
      Value<String> id,
      Value<String> purchaseInvoiceId,
      Value<String> productId,
      Value<int> qty,
      Value<int> purchasePrice,
      Value<int> salePrice,
      Value<int> lineTotal,
      Value<int> rowid,
    });

class $$PurchaseInvoiceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseInvoiceItemsTable> {
  $$PurchaseInvoiceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseInvoiceId => $composableBuilder(
    column: $table.purchaseInvoiceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchaseInvoiceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseInvoiceItemsTable> {
  $$PurchaseInvoiceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseInvoiceId => $composableBuilder(
    column: $table.purchaseInvoiceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseInvoiceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseInvoiceItemsTable> {
  $$PurchaseInvoiceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get purchaseInvoiceId => $composableBuilder(
    column: $table.purchaseInvoiceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<int> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);
}

class $$PurchaseInvoiceItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseInvoiceItemsTable,
          PurchaseInvoiceItem,
          $$PurchaseInvoiceItemsTableFilterComposer,
          $$PurchaseInvoiceItemsTableOrderingComposer,
          $$PurchaseInvoiceItemsTableAnnotationComposer,
          $$PurchaseInvoiceItemsTableCreateCompanionBuilder,
          $$PurchaseInvoiceItemsTableUpdateCompanionBuilder,
          (
            PurchaseInvoiceItem,
            BaseReferences<
              _$AppDatabase,
              $PurchaseInvoiceItemsTable,
              PurchaseInvoiceItem
            >,
          ),
          PurchaseInvoiceItem,
          PrefetchHooks Function()
        > {
  $$PurchaseInvoiceItemsTableTableManager(
    _$AppDatabase db,
    $PurchaseInvoiceItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseInvoiceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseInvoiceItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PurchaseInvoiceItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> purchaseInvoiceId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<int> purchasePrice = const Value.absent(),
                Value<int> salePrice = const Value.absent(),
                Value<int> lineTotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseInvoiceItemsCompanion(
                id: id,
                purchaseInvoiceId: purchaseInvoiceId,
                productId: productId,
                qty: qty,
                purchasePrice: purchasePrice,
                salePrice: salePrice,
                lineTotal: lineTotal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String purchaseInvoiceId,
                required String productId,
                required int qty,
                required int purchasePrice,
                required int salePrice,
                required int lineTotal,
                Value<int> rowid = const Value.absent(),
              }) => PurchaseInvoiceItemsCompanion.insert(
                id: id,
                purchaseInvoiceId: purchaseInvoiceId,
                productId: productId,
                qty: qty,
                purchasePrice: purchasePrice,
                salePrice: salePrice,
                lineTotal: lineTotal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchaseInvoiceItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseInvoiceItemsTable,
      PurchaseInvoiceItem,
      $$PurchaseInvoiceItemsTableFilterComposer,
      $$PurchaseInvoiceItemsTableOrderingComposer,
      $$PurchaseInvoiceItemsTableAnnotationComposer,
      $$PurchaseInvoiceItemsTableCreateCompanionBuilder,
      $$PurchaseInvoiceItemsTableUpdateCompanionBuilder,
      (
        PurchaseInvoiceItem,
        BaseReferences<
          _$AppDatabase,
          $PurchaseInvoiceItemsTable,
          PurchaseInvoiceItem
        >,
      ),
      PurchaseInvoiceItem,
      PrefetchHooks Function()
    >;
typedef $$SuppliersTableCreateCompanionBuilder =
    SuppliersCompanion Function({
      required String id,
      required String name,
      Value<String?> phone,
      Value<String?> address,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SuppliersTableUpdateCompanionBuilder =
    SuppliersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> phone,
      Value<String?> address,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SuppliersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SuppliersTable,
          Supplier,
          $$SuppliersTableFilterComposer,
          $$SuppliersTableOrderingComposer,
          $$SuppliersTableAnnotationComposer,
          $$SuppliersTableCreateCompanionBuilder,
          $$SuppliersTableUpdateCompanionBuilder,
          (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
          Supplier,
          PrefetchHooks Function()
        > {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SuppliersCompanion(
                id: id,
                name: name,
                phone: phone,
                address: address,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SuppliersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                address: address,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SuppliersTable,
      Supplier,
      $$SuppliersTableFilterComposer,
      $$SuppliersTableOrderingComposer,
      $$SuppliersTableAnnotationComposer,
      $$SuppliersTableCreateCompanionBuilder,
      $$SuppliersTableUpdateCompanionBuilder,
      (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
      Supplier,
      PrefetchHooks Function()
    >;
typedef $$PurchasesTableCreateCompanionBuilder =
    PurchasesCompanion Function({
      required String id,
      Value<String?> supplierId,
      Value<String?> invoiceNumber,
      required int total,
      required int paid,
      Value<int> discount,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PurchasesTableUpdateCompanionBuilder =
    PurchasesCompanion Function({
      Value<String> id,
      Value<String?> supplierId,
      Value<String?> invoiceNumber,
      Value<int> total,
      Value<int> paid,
      Value<int> discount,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get paid =>
      $composableBuilder(column: $table.paid, builder: (column) => column);

  GeneratedColumn<int> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchasesTable,
          Purchase,
          $$PurchasesTableFilterComposer,
          $$PurchasesTableOrderingComposer,
          $$PurchasesTableAnnotationComposer,
          $$PurchasesTableCreateCompanionBuilder,
          $$PurchasesTableUpdateCompanionBuilder,
          (Purchase, BaseReferences<_$AppDatabase, $PurchasesTable, Purchase>),
          Purchase,
          PrefetchHooks Function()
        > {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<String?> invoiceNumber = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> paid = const Value.absent(),
                Value<int> discount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchasesCompanion(
                id: id,
                supplierId: supplierId,
                invoiceNumber: invoiceNumber,
                total: total,
                paid: paid,
                discount: discount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> supplierId = const Value.absent(),
                Value<String?> invoiceNumber = const Value.absent(),
                required int total,
                required int paid,
                Value<int> discount = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PurchasesCompanion.insert(
                id: id,
                supplierId: supplierId,
                invoiceNumber: invoiceNumber,
                total: total,
                paid: paid,
                discount: discount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchasesTable,
      Purchase,
      $$PurchasesTableFilterComposer,
      $$PurchasesTableOrderingComposer,
      $$PurchasesTableAnnotationComposer,
      $$PurchasesTableCreateCompanionBuilder,
      $$PurchasesTableUpdateCompanionBuilder,
      (Purchase, BaseReferences<_$AppDatabase, $PurchasesTable, Purchase>),
      Purchase,
      PrefetchHooks Function()
    >;
typedef $$PurchaseItemsTableCreateCompanionBuilder =
    PurchaseItemsCompanion Function({
      required String id,
      required String purchaseId,
      required String productId,
      required int qty,
      required int unitCost,
      required int lineTotal,
      Value<int> rowid,
    });
typedef $$PurchaseItemsTableUpdateCompanionBuilder =
    PurchaseItemsCompanion Function({
      Value<String> id,
      Value<String> purchaseId,
      Value<String> productId,
      Value<int> qty,
      Value<int> unitCost,
      Value<int> lineTotal,
      Value<int> rowid,
    });

class $$PurchaseItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchaseItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCost => $composableBuilder(
    column: $table.unitCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get unitCost =>
      $composableBuilder(column: $table.unitCost, builder: (column) => column);

  GeneratedColumn<int> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);
}

class $$PurchaseItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseItemsTable,
          PurchaseItem,
          $$PurchaseItemsTableFilterComposer,
          $$PurchaseItemsTableOrderingComposer,
          $$PurchaseItemsTableAnnotationComposer,
          $$PurchaseItemsTableCreateCompanionBuilder,
          $$PurchaseItemsTableUpdateCompanionBuilder,
          (
            PurchaseItem,
            BaseReferences<_$AppDatabase, $PurchaseItemsTable, PurchaseItem>,
          ),
          PurchaseItem,
          PrefetchHooks Function()
        > {
  $$PurchaseItemsTableTableManager(_$AppDatabase db, $PurchaseItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> purchaseId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<int> unitCost = const Value.absent(),
                Value<int> lineTotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseItemsCompanion(
                id: id,
                purchaseId: purchaseId,
                productId: productId,
                qty: qty,
                unitCost: unitCost,
                lineTotal: lineTotal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String purchaseId,
                required String productId,
                required int qty,
                required int unitCost,
                required int lineTotal,
                Value<int> rowid = const Value.absent(),
              }) => PurchaseItemsCompanion.insert(
                id: id,
                purchaseId: purchaseId,
                productId: productId,
                qty: qty,
                unitCost: unitCost,
                lineTotal: lineTotal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchaseItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseItemsTable,
      PurchaseItem,
      $$PurchaseItemsTableFilterComposer,
      $$PurchaseItemsTableOrderingComposer,
      $$PurchaseItemsTableAnnotationComposer,
      $$PurchaseItemsTableCreateCompanionBuilder,
      $$PurchaseItemsTableUpdateCompanionBuilder,
      (
        PurchaseItem,
        BaseReferences<_$AppDatabase, $PurchaseItemsTable, PurchaseItem>,
      ),
      PurchaseItem,
      PrefetchHooks Function()
    >;
typedef $$PurchasePaymentsTableCreateCompanionBuilder =
    PurchasePaymentsCompanion Function({
      required String id,
      Value<String?> purchaseId,
      required String supplierId,
      required int amount,
      Value<int> discount,
      Value<String?> description,
      required DateTime paymentDate,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PurchasePaymentsTableUpdateCompanionBuilder =
    PurchasePaymentsCompanion Function({
      Value<String> id,
      Value<String?> purchaseId,
      Value<String> supplierId,
      Value<int> amount,
      Value<int> discount,
      Value<String?> description,
      Value<DateTime> paymentDate,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PurchasePaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasePaymentsTable> {
  $$PurchasePaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchasePaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasePaymentsTable> {
  $$PurchasePaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchasePaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasePaymentsTable> {
  $$PurchasePaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PurchasePaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchasePaymentsTable,
          PurchasePayment,
          $$PurchasePaymentsTableFilterComposer,
          $$PurchasePaymentsTableOrderingComposer,
          $$PurchasePaymentsTableAnnotationComposer,
          $$PurchasePaymentsTableCreateCompanionBuilder,
          $$PurchasePaymentsTableUpdateCompanionBuilder,
          (
            PurchasePayment,
            BaseReferences<
              _$AppDatabase,
              $PurchasePaymentsTable,
              PurchasePayment
            >,
          ),
          PurchasePayment,
          PrefetchHooks Function()
        > {
  $$PurchasePaymentsTableTableManager(
    _$AppDatabase db,
    $PurchasePaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasePaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasePaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasePaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> purchaseId = const Value.absent(),
                Value<String> supplierId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> discount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> paymentDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchasePaymentsCompanion(
                id: id,
                purchaseId: purchaseId,
                supplierId: supplierId,
                amount: amount,
                discount: discount,
                description: description,
                paymentDate: paymentDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> purchaseId = const Value.absent(),
                required String supplierId,
                required int amount,
                Value<int> discount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required DateTime paymentDate,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PurchasePaymentsCompanion.insert(
                id: id,
                purchaseId: purchaseId,
                supplierId: supplierId,
                amount: amount,
                discount: discount,
                description: description,
                paymentDate: paymentDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PurchasePaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchasePaymentsTable,
      PurchasePayment,
      $$PurchasePaymentsTableFilterComposer,
      $$PurchasePaymentsTableOrderingComposer,
      $$PurchasePaymentsTableAnnotationComposer,
      $$PurchasePaymentsTableCreateCompanionBuilder,
      $$PurchasePaymentsTableUpdateCompanionBuilder,
      (
        PurchasePayment,
        BaseReferences<_$AppDatabase, $PurchasePaymentsTable, PurchasePayment>,
      ),
      PurchasePayment,
      PrefetchHooks Function()
    >;
typedef $$RepairsTableCreateCompanionBuilder =
    RepairsCompanion Function({
      required String id,
      Value<String?> customerId,
      required String customerName,
      Value<String?> customerPhone,
      required String device,
      Value<String?> model,
      Value<String?> imei,
      required String issue,
      required String status,
      Value<int> estimatedCost,
      Value<int> finalCost,
      Value<int> discount,
      Value<int> paidAtReceive,
      Value<int> paidAtDelivery,
      Value<int> totalPaid,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String> transactionStatus,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });
typedef $$RepairsTableUpdateCompanionBuilder =
    RepairsCompanion Function({
      Value<String> id,
      Value<String?> customerId,
      Value<String> customerName,
      Value<String?> customerPhone,
      Value<String> device,
      Value<String?> model,
      Value<String?> imei,
      Value<String> issue,
      Value<String> status,
      Value<int> estimatedCost,
      Value<int> finalCost,
      Value<int> discount,
      Value<int> paidAtReceive,
      Value<int> paidAtDelivery,
      Value<int> totalPaid,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> transactionStatus,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });

class $$RepairsTableFilterComposer
    extends Composer<_$AppDatabase, $RepairsTable> {
  $$RepairsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get device => $composableBuilder(
    column: $table.device,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imei => $composableBuilder(
    column: $table.imei,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get issue => $composableBuilder(
    column: $table.issue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedCost => $composableBuilder(
    column: $table.estimatedCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get finalCost => $composableBuilder(
    column: $table.finalCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidAtReceive => $composableBuilder(
    column: $table.paidAtReceive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidAtDelivery => $composableBuilder(
    column: $table.paidAtDelivery,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPaid => $composableBuilder(
    column: $table.totalPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionStatus => $composableBuilder(
    column: $table.transactionStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RepairsTableOrderingComposer
    extends Composer<_$AppDatabase, $RepairsTable> {
  $$RepairsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get device => $composableBuilder(
    column: $table.device,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imei => $composableBuilder(
    column: $table.imei,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get issue => $composableBuilder(
    column: $table.issue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedCost => $composableBuilder(
    column: $table.estimatedCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get finalCost => $composableBuilder(
    column: $table.finalCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidAtReceive => $composableBuilder(
    column: $table.paidAtReceive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidAtDelivery => $composableBuilder(
    column: $table.paidAtDelivery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPaid => $composableBuilder(
    column: $table.totalPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionStatus => $composableBuilder(
    column: $table.transactionStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RepairsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepairsTable> {
  $$RepairsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get device =>
      $composableBuilder(column: $table.device, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get imei =>
      $composableBuilder(column: $table.imei, builder: (column) => column);

  GeneratedColumn<String> get issue =>
      $composableBuilder(column: $table.issue, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get estimatedCost => $composableBuilder(
    column: $table.estimatedCost,
    builder: (column) => column,
  );

  GeneratedColumn<int> get finalCost =>
      $composableBuilder(column: $table.finalCost, builder: (column) => column);

  GeneratedColumn<int> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<int> get paidAtReceive => $composableBuilder(
    column: $table.paidAtReceive,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paidAtDelivery => $composableBuilder(
    column: $table.paidAtDelivery,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPaid =>
      $composableBuilder(column: $table.totalPaid, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get transactionStatus => $composableBuilder(
    column: $table.transactionStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => column,
  );
}

class $$RepairsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RepairsTable,
          Repair,
          $$RepairsTableFilterComposer,
          $$RepairsTableOrderingComposer,
          $$RepairsTableAnnotationComposer,
          $$RepairsTableCreateCompanionBuilder,
          $$RepairsTableUpdateCompanionBuilder,
          (Repair, BaseReferences<_$AppDatabase, $RepairsTable, Repair>),
          Repair,
          PrefetchHooks Function()
        > {
  $$RepairsTableTableManager(_$AppDatabase db, $RepairsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepairsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepairsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepairsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<String> device = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> imei = const Value.absent(),
                Value<String> issue = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> estimatedCost = const Value.absent(),
                Value<int> finalCost = const Value.absent(),
                Value<int> discount = const Value.absent(),
                Value<int> paidAtReceive = const Value.absent(),
                Value<int> paidAtDelivery = const Value.absent(),
                Value<int> totalPaid = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> transactionStatus = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepairsCompanion(
                id: id,
                customerId: customerId,
                customerName: customerName,
                customerPhone: customerPhone,
                device: device,
                model: model,
                imei: imei,
                issue: issue,
                status: status,
                estimatedCost: estimatedCost,
                finalCost: finalCost,
                discount: discount,
                paidAtReceive: paidAtReceive,
                paidAtDelivery: paidAtDelivery,
                totalPaid: totalPaid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                transactionStatus: transactionStatus,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> customerId = const Value.absent(),
                required String customerName,
                Value<String?> customerPhone = const Value.absent(),
                required String device,
                Value<String?> model = const Value.absent(),
                Value<String?> imei = const Value.absent(),
                required String issue,
                required String status,
                Value<int> estimatedCost = const Value.absent(),
                Value<int> finalCost = const Value.absent(),
                Value<int> discount = const Value.absent(),
                Value<int> paidAtReceive = const Value.absent(),
                Value<int> paidAtDelivery = const Value.absent(),
                Value<int> totalPaid = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String> transactionStatus = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepairsCompanion.insert(
                id: id,
                customerId: customerId,
                customerName: customerName,
                customerPhone: customerPhone,
                device: device,
                model: model,
                imei: imei,
                issue: issue,
                status: status,
                estimatedCost: estimatedCost,
                finalCost: finalCost,
                discount: discount,
                paidAtReceive: paidAtReceive,
                paidAtDelivery: paidAtDelivery,
                totalPaid: totalPaid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                transactionStatus: transactionStatus,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RepairsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RepairsTable,
      Repair,
      $$RepairsTableFilterComposer,
      $$RepairsTableOrderingComposer,
      $$RepairsTableAnnotationComposer,
      $$RepairsTableCreateCompanionBuilder,
      $$RepairsTableUpdateCompanionBuilder,
      (Repair, BaseReferences<_$AppDatabase, $RepairsTable, Repair>),
      Repair,
      PrefetchHooks Function()
    >;
typedef $$RepairPartsTableCreateCompanionBuilder =
    RepairPartsCompanion Function({
      required String id,
      required String repairId,
      required String productId,
      required int qty,
      required int unitPrice,
      required int lineTotal,
      Value<int> rowid,
    });
typedef $$RepairPartsTableUpdateCompanionBuilder =
    RepairPartsCompanion Function({
      Value<String> id,
      Value<String> repairId,
      Value<String> productId,
      Value<int> qty,
      Value<int> unitPrice,
      Value<int> lineTotal,
      Value<int> rowid,
    });

class $$RepairPartsTableFilterComposer
    extends Composer<_$AppDatabase, $RepairPartsTable> {
  $$RepairPartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repairId => $composableBuilder(
    column: $table.repairId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RepairPartsTableOrderingComposer
    extends Composer<_$AppDatabase, $RepairPartsTable> {
  $$RepairPartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repairId => $composableBuilder(
    column: $table.repairId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RepairPartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepairPartsTable> {
  $$RepairPartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get repairId =>
      $composableBuilder(column: $table.repairId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);
}

class $$RepairPartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RepairPartsTable,
          RepairPart,
          $$RepairPartsTableFilterComposer,
          $$RepairPartsTableOrderingComposer,
          $$RepairPartsTableAnnotationComposer,
          $$RepairPartsTableCreateCompanionBuilder,
          $$RepairPartsTableUpdateCompanionBuilder,
          (
            RepairPart,
            BaseReferences<_$AppDatabase, $RepairPartsTable, RepairPart>,
          ),
          RepairPart,
          PrefetchHooks Function()
        > {
  $$RepairPartsTableTableManager(_$AppDatabase db, $RepairPartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepairPartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepairPartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepairPartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> repairId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                Value<int> lineTotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepairPartsCompanion(
                id: id,
                repairId: repairId,
                productId: productId,
                qty: qty,
                unitPrice: unitPrice,
                lineTotal: lineTotal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String repairId,
                required String productId,
                required int qty,
                required int unitPrice,
                required int lineTotal,
                Value<int> rowid = const Value.absent(),
              }) => RepairPartsCompanion.insert(
                id: id,
                repairId: repairId,
                productId: productId,
                qty: qty,
                unitPrice: unitPrice,
                lineTotal: lineTotal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RepairPartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RepairPartsTable,
      RepairPart,
      $$RepairPartsTableFilterComposer,
      $$RepairPartsTableOrderingComposer,
      $$RepairPartsTableAnnotationComposer,
      $$RepairPartsTableCreateCompanionBuilder,
      $$RepairPartsTableUpdateCompanionBuilder,
      (
        RepairPart,
        BaseReferences<_$AppDatabase, $RepairPartsTable, RepairPart>,
      ),
      RepairPart,
      PrefetchHooks Function()
    >;
typedef $$StockMovementsTableCreateCompanionBuilder =
    StockMovementsCompanion Function({
      required String id,
      required String productId,
      required String type,
      required int qtyDelta,
      required String reason,
      Value<String?> refId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StockMovementsTableUpdateCompanionBuilder =
    StockMovementsCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<String> type,
      Value<int> qtyDelta,
      Value<String> reason,
      Value<String?> refId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$StockMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtyDelta => $composableBuilder(
    column: $table.qtyDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StockMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtyDelta => $composableBuilder(
    column: $table.qtyDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StockMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get qtyDelta =>
      $composableBuilder(column: $table.qtyDelta, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StockMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockMovementsTable,
          StockMovement,
          $$StockMovementsTableFilterComposer,
          $$StockMovementsTableOrderingComposer,
          $$StockMovementsTableAnnotationComposer,
          $$StockMovementsTableCreateCompanionBuilder,
          $$StockMovementsTableUpdateCompanionBuilder,
          (
            StockMovement,
            BaseReferences<_$AppDatabase, $StockMovementsTable, StockMovement>,
          ),
          StockMovement,
          PrefetchHooks Function()
        > {
  $$StockMovementsTableTableManager(
    _$AppDatabase db,
    $StockMovementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> qtyDelta = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String?> refId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockMovementsCompanion(
                id: id,
                productId: productId,
                type: type,
                qtyDelta: qtyDelta,
                reason: reason,
                refId: refId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required String type,
                required int qtyDelta,
                required String reason,
                Value<String?> refId = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StockMovementsCompanion.insert(
                id: id,
                productId: productId,
                type: type,
                qtyDelta: qtyDelta,
                reason: reason,
                refId: refId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StockMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockMovementsTable,
      StockMovement,
      $$StockMovementsTableFilterComposer,
      $$StockMovementsTableOrderingComposer,
      $$StockMovementsTableAnnotationComposer,
      $$StockMovementsTableCreateCompanionBuilder,
      $$StockMovementsTableUpdateCompanionBuilder,
      (
        StockMovement,
        BaseReferences<_$AppDatabase, $StockMovementsTable, StockMovement>,
      ),
      StockMovement,
      PrefetchHooks Function()
    >;
typedef $$DebtsTableCreateCompanionBuilder =
    DebtsCompanion Function({
      required String id,
      Value<String?> customerId,
      required String customerName,
      Value<String?> customerPhone,
      required String sourceType,
      required String sourceId,
      required int amount,
      Value<DateTime?> dueDate,
      Value<String?> note,
      required DateTime createdAt,
      Value<bool> isSettled,
      Value<DateTime?> settledAt,
      Value<int> rowid,
    });
typedef $$DebtsTableUpdateCompanionBuilder =
    DebtsCompanion Function({
      Value<String> id,
      Value<String?> customerId,
      Value<String> customerName,
      Value<String?> customerPhone,
      Value<String> sourceType,
      Value<String> sourceId,
      Value<int> amount,
      Value<DateTime?> dueDate,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<bool> isSettled,
      Value<DateTime?> settledAt,
      Value<int> rowid,
    });

class $$DebtsTableFilterComposer extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSettled => $composableBuilder(
    column: $table.isSettled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get settledAt => $composableBuilder(
    column: $table.settledAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DebtsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSettled => $composableBuilder(
    column: $table.isSettled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get settledAt => $composableBuilder(
    column: $table.settledAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSettled =>
      $composableBuilder(column: $table.isSettled, builder: (column) => column);

  GeneratedColumn<DateTime> get settledAt =>
      $composableBuilder(column: $table.settledAt, builder: (column) => column);
}

class $$DebtsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebtsTable,
          Debt,
          $$DebtsTableFilterComposer,
          $$DebtsTableOrderingComposer,
          $$DebtsTableAnnotationComposer,
          $$DebtsTableCreateCompanionBuilder,
          $$DebtsTableUpdateCompanionBuilder,
          (Debt, BaseReferences<_$AppDatabase, $DebtsTable, Debt>),
          Debt,
          PrefetchHooks Function()
        > {
  $$DebtsTableTableManager(_$AppDatabase db, $DebtsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSettled = const Value.absent(),
                Value<DateTime?> settledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DebtsCompanion(
                id: id,
                customerId: customerId,
                customerName: customerName,
                customerPhone: customerPhone,
                sourceType: sourceType,
                sourceId: sourceId,
                amount: amount,
                dueDate: dueDate,
                note: note,
                createdAt: createdAt,
                isSettled: isSettled,
                settledAt: settledAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> customerId = const Value.absent(),
                required String customerName,
                Value<String?> customerPhone = const Value.absent(),
                required String sourceType,
                required String sourceId,
                required int amount,
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<bool> isSettled = const Value.absent(),
                Value<DateTime?> settledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DebtsCompanion.insert(
                id: id,
                customerId: customerId,
                customerName: customerName,
                customerPhone: customerPhone,
                sourceType: sourceType,
                sourceId: sourceId,
                amount: amount,
                dueDate: dueDate,
                note: note,
                createdAt: createdAt,
                isSettled: isSettled,
                settledAt: settledAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DebtsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebtsTable,
      Debt,
      $$DebtsTableFilterComposer,
      $$DebtsTableOrderingComposer,
      $$DebtsTableAnnotationComposer,
      $$DebtsTableCreateCompanionBuilder,
      $$DebtsTableUpdateCompanionBuilder,
      (Debt, BaseReferences<_$AppDatabase, $DebtsTable, Debt>),
      Debt,
      PrefetchHooks Function()
    >;
typedef $$ElectricityRechargesTableCreateCompanionBuilder =
    ElectricityRechargesCompanion Function({
      required String id,
      required String customerName,
      Value<String?> subscriptionNumber,
      required int amount,
      required DateTime operatedAt,
      Value<String> operationType,
      Value<String?> notes,
      required DateTime createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });
typedef $$ElectricityRechargesTableUpdateCompanionBuilder =
    ElectricityRechargesCompanion Function({
      Value<String> id,
      Value<String> customerName,
      Value<String?> subscriptionNumber,
      Value<int> amount,
      Value<DateTime> operatedAt,
      Value<String> operationType,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });

class $$ElectricityRechargesTableFilterComposer
    extends Composer<_$AppDatabase, $ElectricityRechargesTable> {
  $$ElectricityRechargesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subscriptionNumber => $composableBuilder(
    column: $table.subscriptionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ElectricityRechargesTableOrderingComposer
    extends Composer<_$AppDatabase, $ElectricityRechargesTable> {
  $$ElectricityRechargesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subscriptionNumber => $composableBuilder(
    column: $table.subscriptionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ElectricityRechargesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ElectricityRechargesTable> {
  $$ElectricityRechargesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subscriptionNumber => $composableBuilder(
    column: $table.subscriptionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => column,
  );
}

class $$ElectricityRechargesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ElectricityRechargesTable,
          ElectricityRecharge,
          $$ElectricityRechargesTableFilterComposer,
          $$ElectricityRechargesTableOrderingComposer,
          $$ElectricityRechargesTableAnnotationComposer,
          $$ElectricityRechargesTableCreateCompanionBuilder,
          $$ElectricityRechargesTableUpdateCompanionBuilder,
          (
            ElectricityRecharge,
            BaseReferences<
              _$AppDatabase,
              $ElectricityRechargesTable,
              ElectricityRecharge
            >,
          ),
          ElectricityRecharge,
          PrefetchHooks Function()
        > {
  $$ElectricityRechargesTableTableManager(
    _$AppDatabase db,
    $ElectricityRechargesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ElectricityRechargesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ElectricityRechargesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ElectricityRechargesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String?> subscriptionNumber = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> operatedAt = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ElectricityRechargesCompanion(
                id: id,
                customerName: customerName,
                subscriptionNumber: subscriptionNumber,
                amount: amount,
                operatedAt: operatedAt,
                operationType: operationType,
                notes: notes,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerName,
                Value<String?> subscriptionNumber = const Value.absent(),
                required int amount,
                required DateTime operatedAt,
                Value<String> operationType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ElectricityRechargesCompanion.insert(
                id: id,
                customerName: customerName,
                subscriptionNumber: subscriptionNumber,
                amount: amount,
                operatedAt: operatedAt,
                operationType: operationType,
                notes: notes,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ElectricityRechargesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ElectricityRechargesTable,
      ElectricityRecharge,
      $$ElectricityRechargesTableFilterComposer,
      $$ElectricityRechargesTableOrderingComposer,
      $$ElectricityRechargesTableAnnotationComposer,
      $$ElectricityRechargesTableCreateCompanionBuilder,
      $$ElectricityRechargesTableUpdateCompanionBuilder,
      (
        ElectricityRecharge,
        BaseReferences<
          _$AppDatabase,
          $ElectricityRechargesTable,
          ElectricityRecharge
        >,
      ),
      ElectricityRecharge,
      PrefetchHooks Function()
    >;
typedef $$WalletOperationsTableCreateCompanionBuilder =
    WalletOperationsCompanion Function({
      required String id,
      required String customerName,
      required int amount,
      required DateTime operatedAt,
      Value<String?> notes,
      required DateTime createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });
typedef $$WalletOperationsTableUpdateCompanionBuilder =
    WalletOperationsCompanion Function({
      Value<String> id,
      Value<String> customerName,
      Value<int> amount,
      Value<DateTime> operatedAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });

class $$WalletOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletOperationsTable> {
  $$WalletOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletOperationsTable> {
  $$WalletOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletOperationsTable> {
  $$WalletOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => column,
  );
}

class $$WalletOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletOperationsTable,
          WalletOperation,
          $$WalletOperationsTableFilterComposer,
          $$WalletOperationsTableOrderingComposer,
          $$WalletOperationsTableAnnotationComposer,
          $$WalletOperationsTableCreateCompanionBuilder,
          $$WalletOperationsTableUpdateCompanionBuilder,
          (
            WalletOperation,
            BaseReferences<
              _$AppDatabase,
              $WalletOperationsTable,
              WalletOperation
            >,
          ),
          WalletOperation,
          PrefetchHooks Function()
        > {
  $$WalletOperationsTableTableManager(
    _$AppDatabase db,
    $WalletOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletOperationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> operatedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalletOperationsCompanion(
                id: id,
                customerName: customerName,
                amount: amount,
                operatedAt: operatedAt,
                notes: notes,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerName,
                required int amount,
                required DateTime operatedAt,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalletOperationsCompanion.insert(
                id: id,
                customerName: customerName,
                amount: amount,
                operatedAt: operatedAt,
                notes: notes,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletOperationsTable,
      WalletOperation,
      $$WalletOperationsTableFilterComposer,
      $$WalletOperationsTableOrderingComposer,
      $$WalletOperationsTableAnnotationComposer,
      $$WalletOperationsTableCreateCompanionBuilder,
      $$WalletOperationsTableUpdateCompanionBuilder,
      (
        WalletOperation,
        BaseReferences<_$AppDatabase, $WalletOperationsTable, WalletOperation>,
      ),
      WalletOperation,
      PrefetchHooks Function()
    >;
typedef $$TelelinkOperationsTableCreateCompanionBuilder =
    TelelinkOperationsCompanion Function({
      required String id,
      required String customerName,
      required int amount,
      required DateTime operatedAt,
      Value<String?> notes,
      required DateTime createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });
typedef $$TelelinkOperationsTableUpdateCompanionBuilder =
    TelelinkOperationsCompanion Function({
      Value<String> id,
      Value<String> customerName,
      Value<int> amount,
      Value<DateTime> operatedAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });

class $$TelelinkOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $TelelinkOperationsTable> {
  $$TelelinkOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TelelinkOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $TelelinkOperationsTable> {
  $$TelelinkOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TelelinkOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TelelinkOperationsTable> {
  $$TelelinkOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => column,
  );
}

class $$TelelinkOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TelelinkOperationsTable,
          TelelinkOperation,
          $$TelelinkOperationsTableFilterComposer,
          $$TelelinkOperationsTableOrderingComposer,
          $$TelelinkOperationsTableAnnotationComposer,
          $$TelelinkOperationsTableCreateCompanionBuilder,
          $$TelelinkOperationsTableUpdateCompanionBuilder,
          (
            TelelinkOperation,
            BaseReferences<
              _$AppDatabase,
              $TelelinkOperationsTable,
              TelelinkOperation
            >,
          ),
          TelelinkOperation,
          PrefetchHooks Function()
        > {
  $$TelelinkOperationsTableTableManager(
    _$AppDatabase db,
    $TelelinkOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TelelinkOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TelelinkOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TelelinkOperationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> operatedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TelelinkOperationsCompanion(
                id: id,
                customerName: customerName,
                amount: amount,
                operatedAt: operatedAt,
                notes: notes,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerName,
                required int amount,
                required DateTime operatedAt,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TelelinkOperationsCompanion.insert(
                id: id,
                customerName: customerName,
                amount: amount,
                operatedAt: operatedAt,
                notes: notes,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TelelinkOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TelelinkOperationsTable,
      TelelinkOperation,
      $$TelelinkOperationsTableFilterComposer,
      $$TelelinkOperationsTableOrderingComposer,
      $$TelelinkOperationsTableAnnotationComposer,
      $$TelelinkOperationsTableCreateCompanionBuilder,
      $$TelelinkOperationsTableUpdateCompanionBuilder,
      (
        TelelinkOperation,
        BaseReferences<
          _$AppDatabase,
          $TelelinkOperationsTable,
          TelelinkOperation
        >,
      ),
      TelelinkOperation,
      PrefetchHooks Function()
    >;
typedef $$FarahnetPaymentsTableCreateCompanionBuilder =
    FarahnetPaymentsCompanion Function({
      required String id,
      required String customerName,
      required int amountPaid,
      required int profitAmount,
      required DateTime operatedAt,
      Value<String?> notes,
      required DateTime createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });
typedef $$FarahnetPaymentsTableUpdateCompanionBuilder =
    FarahnetPaymentsCompanion Function({
      Value<String> id,
      Value<String> customerName,
      Value<int> amountPaid,
      Value<int> profitAmount,
      Value<DateTime> operatedAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });

class $$FarahnetPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $FarahnetPaymentsTable> {
  $$FarahnetPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get profitAmount => $composableBuilder(
    column: $table.profitAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FarahnetPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $FarahnetPaymentsTable> {
  $$FarahnetPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get profitAmount => $composableBuilder(
    column: $table.profitAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FarahnetPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FarahnetPaymentsTable> {
  $$FarahnetPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get profitAmount => $composableBuilder(
    column: $table.profitAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => column,
  );
}

class $$FarahnetPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FarahnetPaymentsTable,
          FarahnetPayment,
          $$FarahnetPaymentsTableFilterComposer,
          $$FarahnetPaymentsTableOrderingComposer,
          $$FarahnetPaymentsTableAnnotationComposer,
          $$FarahnetPaymentsTableCreateCompanionBuilder,
          $$FarahnetPaymentsTableUpdateCompanionBuilder,
          (
            FarahnetPayment,
            BaseReferences<
              _$AppDatabase,
              $FarahnetPaymentsTable,
              FarahnetPayment
            >,
          ),
          FarahnetPayment,
          PrefetchHooks Function()
        > {
  $$FarahnetPaymentsTableTableManager(
    _$AppDatabase db,
    $FarahnetPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FarahnetPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FarahnetPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FarahnetPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<int> amountPaid = const Value.absent(),
                Value<int> profitAmount = const Value.absent(),
                Value<DateTime> operatedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FarahnetPaymentsCompanion(
                id: id,
                customerName: customerName,
                amountPaid: amountPaid,
                profitAmount: profitAmount,
                operatedAt: operatedAt,
                notes: notes,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerName,
                required int amountPaid,
                required int profitAmount,
                required DateTime operatedAt,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FarahnetPaymentsCompanion.insert(
                id: id,
                customerName: customerName,
                amountPaid: amountPaid,
                profitAmount: profitAmount,
                operatedAt: operatedAt,
                notes: notes,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FarahnetPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FarahnetPaymentsTable,
      FarahnetPayment,
      $$FarahnetPaymentsTableFilterComposer,
      $$FarahnetPaymentsTableOrderingComposer,
      $$FarahnetPaymentsTableAnnotationComposer,
      $$FarahnetPaymentsTableCreateCompanionBuilder,
      $$FarahnetPaymentsTableUpdateCompanionBuilder,
      (
        FarahnetPayment,
        BaseReferences<_$AppDatabase, $FarahnetPaymentsTable, FarahnetPayment>,
      ),
      FarahnetPayment,
      PrefetchHooks Function()
    >;
typedef $$ProgramTopupsTableCreateCompanionBuilder =
    ProgramTopupsCompanion Function({
      required String id,
      required String programType,
      required int amount,
      required DateTime operatedAt,
      Value<String?> notes,
      required DateTime createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });
typedef $$ProgramTopupsTableUpdateCompanionBuilder =
    ProgramTopupsCompanion Function({
      Value<String> id,
      Value<String> programType,
      Value<int> amount,
      Value<DateTime> operatedAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });

class $$ProgramTopupsTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramTopupsTable> {
  $$ProgramTopupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get programType => $composableBuilder(
    column: $table.programType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgramTopupsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramTopupsTable> {
  $$ProgramTopupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get programType => $composableBuilder(
    column: $table.programType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgramTopupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramTopupsTable> {
  $$ProgramTopupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get programType => $composableBuilder(
    column: $table.programType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => column,
  );
}

class $$ProgramTopupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgramTopupsTable,
          ProgramTopup,
          $$ProgramTopupsTableFilterComposer,
          $$ProgramTopupsTableOrderingComposer,
          $$ProgramTopupsTableAnnotationComposer,
          $$ProgramTopupsTableCreateCompanionBuilder,
          $$ProgramTopupsTableUpdateCompanionBuilder,
          (
            ProgramTopup,
            BaseReferences<_$AppDatabase, $ProgramTopupsTable, ProgramTopup>,
          ),
          ProgramTopup,
          PrefetchHooks Function()
        > {
  $$ProgramTopupsTableTableManager(_$AppDatabase db, $ProgramTopupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramTopupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramTopupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramTopupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> programType = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> operatedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramTopupsCompanion(
                id: id,
                programType: programType,
                amount: amount,
                operatedAt: operatedAt,
                notes: notes,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String programType,
                required int amount,
                required DateTime operatedAt,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramTopupsCompanion.insert(
                id: id,
                programType: programType,
                amount: amount,
                operatedAt: operatedAt,
                notes: notes,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgramTopupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgramTopupsTable,
      ProgramTopup,
      $$ProgramTopupsTableFilterComposer,
      $$ProgramTopupsTableOrderingComposer,
      $$ProgramTopupsTableAnnotationComposer,
      $$ProgramTopupsTableCreateCompanionBuilder,
      $$ProgramTopupsTableUpdateCompanionBuilder,
      (
        ProgramTopup,
        BaseReferences<_$AppDatabase, $ProgramTopupsTable, ProgramTopup>,
      ),
      ProgramTopup,
      PrefetchHooks Function()
    >;
typedef $$SettlementsTableCreateCompanionBuilder =
    SettlementsCompanion Function({
      required String id,
      required String programType,
      required int amount,
      required DateTime operatedAt,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SettlementsTableUpdateCompanionBuilder =
    SettlementsCompanion Function({
      Value<String> id,
      Value<String> programType,
      Value<int> amount,
      Value<DateTime> operatedAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SettlementsTableFilterComposer
    extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get programType => $composableBuilder(
    column: $table.programType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettlementsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get programType => $composableBuilder(
    column: $table.programType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettlementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get programType => $composableBuilder(
    column: $table.programType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SettlementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettlementsTable,
          Settlement,
          $$SettlementsTableFilterComposer,
          $$SettlementsTableOrderingComposer,
          $$SettlementsTableAnnotationComposer,
          $$SettlementsTableCreateCompanionBuilder,
          $$SettlementsTableUpdateCompanionBuilder,
          (
            Settlement,
            BaseReferences<_$AppDatabase, $SettlementsTable, Settlement>,
          ),
          Settlement,
          PrefetchHooks Function()
        > {
  $$SettlementsTableTableManager(_$AppDatabase db, $SettlementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettlementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettlementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettlementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> programType = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> operatedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettlementsCompanion(
                id: id,
                programType: programType,
                amount: amount,
                operatedAt: operatedAt,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String programType,
                required int amount,
                required DateTime operatedAt,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SettlementsCompanion.insert(
                id: id,
                programType: programType,
                amount: amount,
                operatedAt: operatedAt,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettlementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettlementsTable,
      Settlement,
      $$SettlementsTableFilterComposer,
      $$SettlementsTableOrderingComposer,
      $$SettlementsTableAnnotationComposer,
      $$SettlementsTableCreateCompanionBuilder,
      $$SettlementsTableUpdateCompanionBuilder,
      (
        Settlement,
        BaseReferences<_$AppDatabase, $SettlementsTable, Settlement>,
      ),
      Settlement,
      PrefetchHooks Function()
    >;
typedef $$RepairPartOrdersTableCreateCompanionBuilder =
    RepairPartOrdersCompanion Function({
      required String id,
      required String repairId,
      required String partId,
      Value<String?> supplierId,
      required DateTime operatedAt,
      Value<String> status,
      required int quantity,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RepairPartOrdersTableUpdateCompanionBuilder =
    RepairPartOrdersCompanion Function({
      Value<String> id,
      Value<String> repairId,
      Value<String> partId,
      Value<String?> supplierId,
      Value<DateTime> operatedAt,
      Value<String> status,
      Value<int> quantity,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$RepairPartOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $RepairPartOrdersTable> {
  $$RepairPartOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repairId => $composableBuilder(
    column: $table.repairId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RepairPartOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $RepairPartOrdersTable> {
  $$RepairPartOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repairId => $composableBuilder(
    column: $table.repairId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partId => $composableBuilder(
    column: $table.partId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RepairPartOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepairPartOrdersTable> {
  $$RepairPartOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get repairId =>
      $composableBuilder(column: $table.repairId, builder: (column) => column);

  GeneratedColumn<String> get partId =>
      $composableBuilder(column: $table.partId, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RepairPartOrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RepairPartOrdersTable,
          RepairPartOrder,
          $$RepairPartOrdersTableFilterComposer,
          $$RepairPartOrdersTableOrderingComposer,
          $$RepairPartOrdersTableAnnotationComposer,
          $$RepairPartOrdersTableCreateCompanionBuilder,
          $$RepairPartOrdersTableUpdateCompanionBuilder,
          (
            RepairPartOrder,
            BaseReferences<
              _$AppDatabase,
              $RepairPartOrdersTable,
              RepairPartOrder
            >,
          ),
          RepairPartOrder,
          PrefetchHooks Function()
        > {
  $$RepairPartOrdersTableTableManager(
    _$AppDatabase db,
    $RepairPartOrdersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepairPartOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepairPartOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepairPartOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> repairId = const Value.absent(),
                Value<String> partId = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<DateTime> operatedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepairPartOrdersCompanion(
                id: id,
                repairId: repairId,
                partId: partId,
                supplierId: supplierId,
                operatedAt: operatedAt,
                status: status,
                quantity: quantity,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String repairId,
                required String partId,
                Value<String?> supplierId = const Value.absent(),
                required DateTime operatedAt,
                Value<String> status = const Value.absent(),
                required int quantity,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RepairPartOrdersCompanion.insert(
                id: id,
                repairId: repairId,
                partId: partId,
                supplierId: supplierId,
                operatedAt: operatedAt,
                status: status,
                quantity: quantity,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RepairPartOrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RepairPartOrdersTable,
      RepairPartOrder,
      $$RepairPartOrdersTableFilterComposer,
      $$RepairPartOrdersTableOrderingComposer,
      $$RepairPartOrdersTableAnnotationComposer,
      $$RepairPartOrdersTableCreateCompanionBuilder,
      $$RepairPartOrdersTableUpdateCompanionBuilder,
      (
        RepairPartOrder,
        BaseReferences<_$AppDatabase, $RepairPartOrdersTable, RepairPartOrder>,
      ),
      RepairPartOrder,
      PrefetchHooks Function()
    >;
typedef $$ServiceTransactionsTableCreateCompanionBuilder =
    ServiceTransactionsCompanion Function({
      required String id,
      required String category,
      required String provider,
      Value<String?> providerLabel,
      Value<String> serviceType,
      Value<String?> customerName,
      required int amountCents,
      Value<int> providerCostCents,
      required DateTime createdAt,
      Value<String?> notes,
      Value<String?> saleId,
      Value<int> profitBaseCents,
      Value<int> bonusProfitCents,
      Value<int?> profitCents,
      Value<int> finalProfitCents,
      Value<double> profitPercent,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });
typedef $$ServiceTransactionsTableUpdateCompanionBuilder =
    ServiceTransactionsCompanion Function({
      Value<String> id,
      Value<String> category,
      Value<String> provider,
      Value<String?> providerLabel,
      Value<String> serviceType,
      Value<String?> customerName,
      Value<int> amountCents,
      Value<int> providerCostCents,
      Value<DateTime> createdAt,
      Value<String?> notes,
      Value<String?> saleId,
      Value<int> profitBaseCents,
      Value<int> bonusProfitCents,
      Value<int?> profitCents,
      Value<int> finalProfitCents,
      Value<double> profitPercent,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });

class $$ServiceTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceTransactionsTable> {
  $$ServiceTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerLabel => $composableBuilder(
    column: $table.providerLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get providerCostCents => $composableBuilder(
    column: $table.providerCostCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get profitBaseCents => $composableBuilder(
    column: $table.profitBaseCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bonusProfitCents => $composableBuilder(
    column: $table.bonusProfitCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get profitCents => $composableBuilder(
    column: $table.profitCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get finalProfitCents => $composableBuilder(
    column: $table.finalProfitCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get profitPercent => $composableBuilder(
    column: $table.profitPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServiceTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceTransactionsTable> {
  $$ServiceTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerLabel => $composableBuilder(
    column: $table.providerLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get providerCostCents => $composableBuilder(
    column: $table.providerCostCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get profitBaseCents => $composableBuilder(
    column: $table.profitBaseCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bonusProfitCents => $composableBuilder(
    column: $table.bonusProfitCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get profitCents => $composableBuilder(
    column: $table.profitCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get finalProfitCents => $composableBuilder(
    column: $table.finalProfitCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get profitPercent => $composableBuilder(
    column: $table.profitPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServiceTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceTransactionsTable> {
  $$ServiceTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get providerLabel => $composableBuilder(
    column: $table.providerLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get providerCostCents => $composableBuilder(
    column: $table.providerCostCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<int> get profitBaseCents => $composableBuilder(
    column: $table.profitBaseCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bonusProfitCents => $composableBuilder(
    column: $table.bonusProfitCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get profitCents => $composableBuilder(
    column: $table.profitCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get finalProfitCents => $composableBuilder(
    column: $table.finalProfitCents,
    builder: (column) => column,
  );

  GeneratedColumn<double> get profitPercent => $composableBuilder(
    column: $table.profitPercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => column,
  );
}

class $$ServiceTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceTransactionsTable,
          ServiceTransaction,
          $$ServiceTransactionsTableFilterComposer,
          $$ServiceTransactionsTableOrderingComposer,
          $$ServiceTransactionsTableAnnotationComposer,
          $$ServiceTransactionsTableCreateCompanionBuilder,
          $$ServiceTransactionsTableUpdateCompanionBuilder,
          (
            ServiceTransaction,
            BaseReferences<
              _$AppDatabase,
              $ServiceTransactionsTable,
              ServiceTransaction
            >,
          ),
          ServiceTransaction,
          PrefetchHooks Function()
        > {
  $$ServiceTransactionsTableTableManager(
    _$AppDatabase db,
    $ServiceTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ServiceTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String?> providerLabel = const Value.absent(),
                Value<String> serviceType = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<int> providerCostCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> saleId = const Value.absent(),
                Value<int> profitBaseCents = const Value.absent(),
                Value<int> bonusProfitCents = const Value.absent(),
                Value<int?> profitCents = const Value.absent(),
                Value<int> finalProfitCents = const Value.absent(),
                Value<double> profitPercent = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceTransactionsCompanion(
                id: id,
                category: category,
                provider: provider,
                providerLabel: providerLabel,
                serviceType: serviceType,
                customerName: customerName,
                amountCents: amountCents,
                providerCostCents: providerCostCents,
                createdAt: createdAt,
                notes: notes,
                saleId: saleId,
                profitBaseCents: profitBaseCents,
                bonusProfitCents: bonusProfitCents,
                profitCents: profitCents,
                finalProfitCents: finalProfitCents,
                profitPercent: profitPercent,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String category,
                required String provider,
                Value<String?> providerLabel = const Value.absent(),
                Value<String> serviceType = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                required int amountCents,
                Value<int> providerCostCents = const Value.absent(),
                required DateTime createdAt,
                Value<String?> notes = const Value.absent(),
                Value<String?> saleId = const Value.absent(),
                Value<int> profitBaseCents = const Value.absent(),
                Value<int> bonusProfitCents = const Value.absent(),
                Value<int?> profitCents = const Value.absent(),
                Value<int> finalProfitCents = const Value.absent(),
                Value<double> profitPercent = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceTransactionsCompanion.insert(
                id: id,
                category: category,
                provider: provider,
                providerLabel: providerLabel,
                serviceType: serviceType,
                customerName: customerName,
                amountCents: amountCents,
                providerCostCents: providerCostCents,
                createdAt: createdAt,
                notes: notes,
                saleId: saleId,
                profitBaseCents: profitBaseCents,
                bonusProfitCents: bonusProfitCents,
                profitCents: profitCents,
                finalProfitCents: finalProfitCents,
                profitPercent: profitPercent,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServiceTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceTransactionsTable,
      ServiceTransaction,
      $$ServiceTransactionsTableFilterComposer,
      $$ServiceTransactionsTableOrderingComposer,
      $$ServiceTransactionsTableAnnotationComposer,
      $$ServiceTransactionsTableCreateCompanionBuilder,
      $$ServiceTransactionsTableUpdateCompanionBuilder,
      (
        ServiceTransaction,
        BaseReferences<
          _$AppDatabase,
          $ServiceTransactionsTable,
          ServiceTransaction
        >,
      ),
      ServiceTransaction,
      PrefetchHooks Function()
    >;
typedef $$CashDrawerEventsTableCreateCompanionBuilder =
    CashDrawerEventsCompanion Function({
      Value<int> id,
      required String eventType,
      required DateTime createdAt,
      Value<String?> notes,
    });
typedef $$CashDrawerEventsTableUpdateCompanionBuilder =
    CashDrawerEventsCompanion Function({
      Value<int> id,
      Value<String> eventType,
      Value<DateTime> createdAt,
      Value<String?> notes,
    });

class $$CashDrawerEventsTableFilterComposer
    extends Composer<_$AppDatabase, $CashDrawerEventsTable> {
  $$CashDrawerEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CashDrawerEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $CashDrawerEventsTable> {
  $$CashDrawerEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CashDrawerEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashDrawerEventsTable> {
  $$CashDrawerEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$CashDrawerEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashDrawerEventsTable,
          CashDrawerEvent,
          $$CashDrawerEventsTableFilterComposer,
          $$CashDrawerEventsTableOrderingComposer,
          $$CashDrawerEventsTableAnnotationComposer,
          $$CashDrawerEventsTableCreateCompanionBuilder,
          $$CashDrawerEventsTableUpdateCompanionBuilder,
          (
            CashDrawerEvent,
            BaseReferences<
              _$AppDatabase,
              $CashDrawerEventsTable,
              CashDrawerEvent
            >,
          ),
          CashDrawerEvent,
          PrefetchHooks Function()
        > {
  $$CashDrawerEventsTableTableManager(
    _$AppDatabase db,
    $CashDrawerEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashDrawerEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashDrawerEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashDrawerEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => CashDrawerEventsCompanion(
                id: id,
                eventType: eventType,
                createdAt: createdAt,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventType,
                required DateTime createdAt,
                Value<String?> notes = const Value.absent(),
              }) => CashDrawerEventsCompanion.insert(
                id: id,
                eventType: eventType,
                createdAt: createdAt,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CashDrawerEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashDrawerEventsTable,
      CashDrawerEvent,
      $$CashDrawerEventsTableFilterComposer,
      $$CashDrawerEventsTableOrderingComposer,
      $$CashDrawerEventsTableAnnotationComposer,
      $$CashDrawerEventsTableCreateCompanionBuilder,
      $$CashDrawerEventsTableUpdateCompanionBuilder,
      (
        CashDrawerEvent,
        BaseReferences<_$AppDatabase, $CashDrawerEventsTable, CashDrawerEvent>,
      ),
      CashDrawerEvent,
      PrefetchHooks Function()
    >;
typedef $$ServiceDailyInventoryTableCreateCompanionBuilder =
    ServiceDailyInventoryCompanion Function({
      required String id,
      required DateTime date,
      required String provider,
      Value<int> openingBalanceCents,
      Value<int> closingBalanceCents,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ServiceDailyInventoryTableUpdateCompanionBuilder =
    ServiceDailyInventoryCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String> provider,
      Value<int> openingBalanceCents,
      Value<int> closingBalanceCents,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ServiceDailyInventoryTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceDailyInventoryTable> {
  $$ServiceDailyInventoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingBalanceCents => $composableBuilder(
    column: $table.openingBalanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get closingBalanceCents => $composableBuilder(
    column: $table.closingBalanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServiceDailyInventoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceDailyInventoryTable> {
  $$ServiceDailyInventoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalanceCents => $composableBuilder(
    column: $table.openingBalanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get closingBalanceCents => $composableBuilder(
    column: $table.closingBalanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServiceDailyInventoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceDailyInventoryTable> {
  $$ServiceDailyInventoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<int> get openingBalanceCents => $composableBuilder(
    column: $table.openingBalanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get closingBalanceCents => $composableBuilder(
    column: $table.closingBalanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ServiceDailyInventoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceDailyInventoryTable,
          ServiceDailyInventoryData,
          $$ServiceDailyInventoryTableFilterComposer,
          $$ServiceDailyInventoryTableOrderingComposer,
          $$ServiceDailyInventoryTableAnnotationComposer,
          $$ServiceDailyInventoryTableCreateCompanionBuilder,
          $$ServiceDailyInventoryTableUpdateCompanionBuilder,
          (
            ServiceDailyInventoryData,
            BaseReferences<
              _$AppDatabase,
              $ServiceDailyInventoryTable,
              ServiceDailyInventoryData
            >,
          ),
          ServiceDailyInventoryData,
          PrefetchHooks Function()
        > {
  $$ServiceDailyInventoryTableTableManager(
    _$AppDatabase db,
    $ServiceDailyInventoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceDailyInventoryTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ServiceDailyInventoryTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ServiceDailyInventoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<int> openingBalanceCents = const Value.absent(),
                Value<int> closingBalanceCents = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceDailyInventoryCompanion(
                id: id,
                date: date,
                provider: provider,
                openingBalanceCents: openingBalanceCents,
                closingBalanceCents: closingBalanceCents,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required String provider,
                Value<int> openingBalanceCents = const Value.absent(),
                Value<int> closingBalanceCents = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceDailyInventoryCompanion.insert(
                id: id,
                date: date,
                provider: provider,
                openingBalanceCents: openingBalanceCents,
                closingBalanceCents: closingBalanceCents,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServiceDailyInventoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceDailyInventoryTable,
      ServiceDailyInventoryData,
      $$ServiceDailyInventoryTableFilterComposer,
      $$ServiceDailyInventoryTableOrderingComposer,
      $$ServiceDailyInventoryTableAnnotationComposer,
      $$ServiceDailyInventoryTableCreateCompanionBuilder,
      $$ServiceDailyInventoryTableUpdateCompanionBuilder,
      (
        ServiceDailyInventoryData,
        BaseReferences<
          _$AppDatabase,
          $ServiceDailyInventoryTable,
          ServiceDailyInventoryData
        >,
      ),
      ServiceDailyInventoryData,
      PrefetchHooks Function()
    >;
typedef $$SideRevenueTableCreateCompanionBuilder =
    SideRevenueCompanion Function({
      required String id,
      required String category,
      required String description,
      Value<String?> customerName,
      required int amount,
      required DateTime operatedAt,
      Value<String?> notes,
      required DateTime createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });
typedef $$SideRevenueTableUpdateCompanionBuilder =
    SideRevenueCompanion Function({
      Value<String> id,
      Value<String> category,
      Value<String> description,
      Value<String?> customerName,
      Value<int> amount,
      Value<DateTime> operatedAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<DateTime?> reversedAt,
      Value<int> rowid,
    });

class $$SideRevenueTableFilterComposer
    extends Composer<_$AppDatabase, $SideRevenueTable> {
  $$SideRevenueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SideRevenueTableOrderingComposer
    extends Composer<_$AppDatabase, $SideRevenueTable> {
  $$SideRevenueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SideRevenueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SideRevenueTable> {
  $$SideRevenueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get operatedAt => $composableBuilder(
    column: $table.operatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => column,
  );
}

class $$SideRevenueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SideRevenueTable,
          SideRevenueData,
          $$SideRevenueTableFilterComposer,
          $$SideRevenueTableOrderingComposer,
          $$SideRevenueTableAnnotationComposer,
          $$SideRevenueTableCreateCompanionBuilder,
          $$SideRevenueTableUpdateCompanionBuilder,
          (
            SideRevenueData,
            BaseReferences<_$AppDatabase, $SideRevenueTable, SideRevenueData>,
          ),
          SideRevenueData,
          PrefetchHooks Function()
        > {
  $$SideRevenueTableTableManager(_$AppDatabase db, $SideRevenueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SideRevenueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SideRevenueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SideRevenueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> operatedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SideRevenueCompanion(
                id: id,
                category: category,
                description: description,
                customerName: customerName,
                amount: amount,
                operatedAt: operatedAt,
                notes: notes,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String category,
                required String description,
                Value<String?> customerName = const Value.absent(),
                required int amount,
                required DateTime operatedAt,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SideRevenueCompanion.insert(
                id: id,
                category: category,
                description: description,
                customerName: customerName,
                amount: amount,
                operatedAt: operatedAt,
                notes: notes,
                createdAt: createdAt,
                status: status,
                reversedAt: reversedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SideRevenueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SideRevenueTable,
      SideRevenueData,
      $$SideRevenueTableFilterComposer,
      $$SideRevenueTableOrderingComposer,
      $$SideRevenueTableAnnotationComposer,
      $$SideRevenueTableCreateCompanionBuilder,
      $$SideRevenueTableUpdateCompanionBuilder,
      (
        SideRevenueData,
        BaseReferences<_$AppDatabase, $SideRevenueTable, SideRevenueData>,
      ),
      SideRevenueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$PurchaseInvoicesTableTableManager get purchaseInvoices =>
      $$PurchaseInvoicesTableTableManager(_db, _db.purchaseInvoices);
  $$PurchaseInvoiceItemsTableTableManager get purchaseInvoiceItems =>
      $$PurchaseInvoiceItemsTableTableManager(_db, _db.purchaseInvoiceItems);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$PurchaseItemsTableTableManager get purchaseItems =>
      $$PurchaseItemsTableTableManager(_db, _db.purchaseItems);
  $$PurchasePaymentsTableTableManager get purchasePayments =>
      $$PurchasePaymentsTableTableManager(_db, _db.purchasePayments);
  $$RepairsTableTableManager get repairs =>
      $$RepairsTableTableManager(_db, _db.repairs);
  $$RepairPartsTableTableManager get repairParts =>
      $$RepairPartsTableTableManager(_db, _db.repairParts);
  $$StockMovementsTableTableManager get stockMovements =>
      $$StockMovementsTableTableManager(_db, _db.stockMovements);
  $$DebtsTableTableManager get debts =>
      $$DebtsTableTableManager(_db, _db.debts);
  $$ElectricityRechargesTableTableManager get electricityRecharges =>
      $$ElectricityRechargesTableTableManager(_db, _db.electricityRecharges);
  $$WalletOperationsTableTableManager get walletOperations =>
      $$WalletOperationsTableTableManager(_db, _db.walletOperations);
  $$TelelinkOperationsTableTableManager get telelinkOperations =>
      $$TelelinkOperationsTableTableManager(_db, _db.telelinkOperations);
  $$FarahnetPaymentsTableTableManager get farahnetPayments =>
      $$FarahnetPaymentsTableTableManager(_db, _db.farahnetPayments);
  $$ProgramTopupsTableTableManager get programTopups =>
      $$ProgramTopupsTableTableManager(_db, _db.programTopups);
  $$SettlementsTableTableManager get settlements =>
      $$SettlementsTableTableManager(_db, _db.settlements);
  $$RepairPartOrdersTableTableManager get repairPartOrders =>
      $$RepairPartOrdersTableTableManager(_db, _db.repairPartOrders);
  $$ServiceTransactionsTableTableManager get serviceTransactions =>
      $$ServiceTransactionsTableTableManager(_db, _db.serviceTransactions);
  $$CashDrawerEventsTableTableManager get cashDrawerEvents =>
      $$CashDrawerEventsTableTableManager(_db, _db.cashDrawerEvents);
  $$ServiceDailyInventoryTableTableManager get serviceDailyInventory =>
      $$ServiceDailyInventoryTableTableManager(_db, _db.serviceDailyInventory);
  $$SideRevenueTableTableManager get sideRevenue =>
      $$SideRevenueTableTableManager(_db, _db.sideRevenue);
}
