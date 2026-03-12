import 'package:drift/drift.dart';

class ServiceTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()(); // 'websites' or 'palpay'
  TextColumn get provider =>
      text()(); // telelink, platform, fawry, farahnet, electricity, mada, other
  TextColumn get providerLabel =>
      text().nullable()(); // Custom name when provider='other'
  TextColumn get serviceType => text().withDefault(
    const Constant('bills'),
  )(); // 'bills', 'balance', 'games', 'roaming', 'bundle', 'internet', 'minutes'
  TextColumn get customerName => text().nullable()();
  IntColumn get amountCents => integer()(); // Total amount customer pays (in cents/fils)
  IntColumn get providerCostCents => integer().withDefault(
    const Constant(0),
  )(); // What we pay to provider (in cents/fils)
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get saleId =>
      text().nullable()(); // Link to sale if part of POS transaction
  
  // Profit tracking fields
  IntColumn get profitBaseCents => integer().withDefault(
    const Constant(0),
  )(); // Base profit: amount - provider_cost
  IntColumn get bonusProfitCents => integer().withDefault(
    const Constant(0),
  )(); // Additional profit (e.g., games +1 ILS)
  IntColumn get profitCents => integer().nullable()(); // DEPRECATED: use finalProfitCents instead
  IntColumn get finalProfitCents => integer().withDefault(
    const Constant(0),
  )(); // Final profit: baseProfit + bonusProfit
  RealColumn get profitPercent => real().withDefault(
    const Constant(0),
  )(); // Percentage: (finalProfit / amount) * 100
  
  // Reversal support
  TextColumn get status => text().withDefault(const Constant('normal'))();
  DateTimeColumn get reversedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

