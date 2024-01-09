import 'package:cobaprojek1/models/database.dart';
import 'package:cobaprojek1/models/transaction_with_category.dart';
import 'package:cobaprojek1/pages/transaction_page.dart';
// import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  const HomePage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<double> totalPemasukan;
  late Future<double> totalPengeluaran;
  final AppDatabase database = AppDatabase();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    totalPemasukan = database.calculateTotalPemasukans(1);
    totalPengeluaran = database.calculateTotalPengeluarans(2);
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Column(
        children: [
          //ini dashboard
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.download,
                              color: Colors.green,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          SizedBox(width: 10),
                          FutureBuilder(
                              future: totalPemasukan,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Pemasukan",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 14)),
                                      SizedBox(height: 7),
                                      Text("Rp. ${snapshot.data}",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Total Pemasukan",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 14)),
                                      SizedBox(height: 7),
                                      Text("Rp. 0",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  );
                                }
                              })
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.upload,
                              color: Colors.red,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          SizedBox(width: 10),
                          FutureBuilder(
                              future: totalPengeluaran,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Pengeluaran",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 14)),
                                      SizedBox(height: 7),
                                      Text("Rp. ${snapshot.data}",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Pengeluaran",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 14)),
                                      SizedBox(height: 7),
                                      Text("Rp. 0",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  );
                                }
                              })
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          FutureBuilder(
                              future: database.calculateTotalUang(
                                  totalPemasukan, totalPengeluaran),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("Total Uang",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 14)),
                                      SizedBox(height: 7),
                                      Text("Rp. ${snapshot.data}",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Total Uang",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 14)),
                                      SizedBox(height: 7),
                                      Text("Rp. 0",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  );
                                }
                              })
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xff9D76C1),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // ini text transaksi
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Transaksi hari ini : ",
              style: GoogleFonts.montserrat(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          StreamBuilder<List<TransactionWithCategory>>(
              stream: database.getTransactionByDateRepo(widget.selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                elevation: 10,
                                child: ListTile(
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  TransactionPage(
                                                      transactionWithCategory:
                                                          snapshot
                                                              .data![index]),
                                            ));
                                          },
                                          icon: Icon(Icons.edit)),
                                      SizedBox(width: 8),
                                      IconButton(
                                          onPressed: () async {
                                            await database
                                                .deleteTransactionRepo(snapshot
                                                    .data![index]
                                                    .transaction
                                                    .id);
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.delete)),
                                    ],
                                  ),
                                  title: Text("Rp." +
                                      snapshot.data![index].transaction.amount
                                          .toString()),
                                  subtitle: Text(snapshot
                                          .data![index].category.name +
                                      ' (' +
                                      snapshot.data![index].transaction.name +
                                      ')'),
                                  leading: Container(
                                    child:
                                        (snapshot.data![index].category.type ==
                                                2)
                                            ? Icon(
                                                Icons.upload,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.download,
                                                color: Colors.green,
                                              ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Text("Tidak ada Transaksi!!"),
                      );
                    }
                  } else {
                    return Center(
                      child: Text("Tidak ada data"),
                    );
                  }
                }
              }),

          //ini list transaksi
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Card(
          //     elevation: 10,
          //     child: ListTile(
          //       trailing: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          //           SizedBox(width: 8),
          //           IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          //         ],
          //       ),
          //       title: Text("Rp.20.000"),
          //       subtitle: Text("Makan Siang"),
          //       leading: Container(
          //         child: Icon(
          //           Icons.upload,
          //           color: Colors.red,
          //         ),
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(8)),
          //       ),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Card(
          //     elevation: 10,
          //     child: ListTile(
          //       trailing: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          //           SizedBox(width: 8),
          //           IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          //         ],
          //       ),
          //       title: Text("Rp.20.000"),
          //       subtitle: Text("Tabungan"),
          //       leading: Container(
          //         child: Icon(
          //           Icons.download,
          //           color: Colors.green,
          //         ),
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(8)),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      )),
    );
  }
}
