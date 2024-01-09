import 'package:cobaprojek1/models/database.dart';
import 'package:cobaprojek1/models/transaction_with_category.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionWithCategory;
  const TransactionPage({Key? key, required this.transactionWithCategory})
      : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final AppDatabase database = AppDatabase();
  late int type;
  bool isPengeluaran = true;
  List<String> list = ['Makan dan jajan', 'Transportasi', 'Nonton'];
  late String dropDownValue = list.first;
  TextEditingController jumlahController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  Category? selectedCategory;

  Future insert(
      int jumlah, DateTime date, String keterangan, int kategoriId) async {
    //ada insert ke db
    DateTime now = DateTime.now();
    final row = await database.into(database.transactions).insertReturning(
        TransactionsCompanion.insert(
            name: keterangan,
            category_id: kategoriId,
            transaction_date: date,
            amount: jumlah,
            createdAt: now,
            updatedAt: now));
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future update(int transactionId, int amount, DateTime transactionDate,
      int categoryId, String detail) async {
    return await database.updateTransactionRepo(
        transactionId, amount, categoryId, transactionDate, detail);
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.transactionWithCategory != null) {
      updateTransactionView(widget.transactionWithCategory!);
    } else {
      type = 2;
    }
    super.initState();
  }

  void updateTransactionView(TransactionWithCategory transactionWithCategory) {
    jumlahController.text =
        transactionWithCategory.transaction.amount.toString();
    keteranganController.text = transactionWithCategory.transaction.name;
    dateController.text = DateFormat('yyyy-MM-dd')
        .format(transactionWithCategory.transaction.transaction_date);
    type = transactionWithCategory.category.type;
    (type == 2) ? isPengeluaran = true : isPengeluaran = false;
    selectedCategory = transactionWithCategory.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Transaksi"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Switch(
                    value: isPengeluaran,
                    onChanged: (bool value) {
                      setState(() {
                        isPengeluaran = value;
                        type = value ? 2 : 1;
                        selectedCategory = null;
                      });
                    },
                    inactiveThumbColor: Colors.green[200],
                    inactiveTrackColor: Colors.green,
                    activeColor: Colors.red,
                  ),
                  (isPengeluaran == true)
                      ? Text("Pengeluaran")
                      : Text("Pemasukan")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: jumlahController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(), labelText: "Jumlah"),
                  ),
                  SizedBox(height: 25),
                  Text(
                    "Kategori",
                    style: GoogleFonts.montserrat(fontSize: 16),
                  ),
                  FutureBuilder<List<Category>>(
                      future: getAllCategory(type),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (snapshot.hasData) {
                            if (snapshot.data!.length > 0) {
                              selectedCategory = (selectedCategory == null)
                                  ? snapshot.data!.first
                                  : selectedCategory;
                              return DropdownButton<Category>(
                                  value: (selectedCategory == null)
                                      ? snapshot.data!.first
                                      : selectedCategory,
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_downward),
                                  items: snapshot.data!.map((Category item) {
                                    return DropdownMenuItem<Category>(
                                        value: item, child: Text(item.name));
                                  }).toList(),
                                  onChanged: (Category? value) {
                                    setState(() {
                                      selectedCategory = value;
                                    });
                                  });
                            } else {
                              return Center(
                                child: Text("Data Kosong!!"),
                              );
                            }
                          } else {
                            return Center(
                              child: Text("No has data!!"),
                            );
                          }
                        }
                      }),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: keteranganController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Keterangan"),
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(), labelText: "Tanggal"),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2099));

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                        dateController.text = formattedDate;
                      }
                      ;
                    },
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                      onPressed: () async {
                        (widget.transactionWithCategory == null)
                            ? insert(
                                int.parse(jumlahController.text),
                                DateTime.parse(dateController.text),
                                keteranganController.text,
                                selectedCategory!.id)
                            : await update(
                                widget.transactionWithCategory!.transaction.id,
                                int.parse(jumlahController.text),
                                DateTime.parse(dateController.text),
                                selectedCategory!.id,
                                keteranganController.text);
                        Navigator.pop(context, true);
                      },
                      child: Text("Save"))
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
