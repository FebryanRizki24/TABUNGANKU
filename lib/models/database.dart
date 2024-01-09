// These imports are necessary to open the sqlite3 database
import 'dart:io';

import 'package:cobaprojek1/models/category.dart';
import 'package:cobaprojek1/models/transaction.dart';
import 'package:cobaprojek1/models/transaction_with_category.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';
// ... the TodoItems table definition stays the same

@DriftDatabase(tables: [Categories, Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  //CRUD
  Future updateCategoryRepo(int id, String name) async {
    return (update(categories)..where((tbl) => tbl.id.equals(id)))
        .write(CategoriesCompanion(name: Value(name)));
  }

  Future deleteCategoryRepo(int id) async {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<Category>> getAllCategoryRepo(int type) async {
    return await (select(categories)..where((tbl) => tbl.type.equals(type)))
        .get();
  }

  Future updateTransactionRepo(int id, int amount, int categoryId,
      DateTime transactionDate, String detail) async {
    return (update(transactions)..where((tbl) => tbl.id.equals(id))).write(
        TransactionsCompanion(
            name: Value(detail),
            amount: Value(amount),
            category_id: Value(categoryId),
            transaction_date: Value(transactionDate)));
  }

  Future deleteTransactionRepo(int id) async {
    return (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<double> calculateTotalPemasukans(int type) async {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.category_id)),
    ])
      ..where(categories.type.equals(type));

    final result = await query.get();

    double totalPemasukan = 0.0;

    for (final row in result) {
      // Menggunakan row[transactions.amount] untuk mengakses kolom amount
      final amount = row.readTable(transactions).amount;
      totalPemasukan += amount;
    }

    return totalPemasukan;
  }

  Future<double> calculateTotalPengeluarans(int type) async {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.category_id)),
    ])
      ..where(categories.type.equals(type));

    final result = await query.get();

    double totalPengeluaran = 0.0;

    for (final row in result) {
      // Menggunakan row[transactions.amount] untuk mengakses kolom amount
      final amount = row.readTable(transactions).amount;
      totalPengeluaran += amount;
    }

    return totalPengeluaran;
  }

  Future<double> calculateTotalUang(
      Future<double> totalPemasukan, Future<double> totalPengeluaran) async {
    return await totalPemasukan - await totalPengeluaran;
  }

  Stream<List<TransactionWithCategory>> getTransactionByDateRepo(
      DateTime date) {
    final query = (select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.category_id))
    ])
      ..where(transactions.transaction_date.equals(date)));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
            row.readTable(transactions), row.readTable(categories));
      }).toList();
    });
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
