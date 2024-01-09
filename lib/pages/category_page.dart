import 'package:cobaprojek1/models/database.dart';
import 'package:cobaprojek1/pages/auth/login_page.dart';
// import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isPengeluaran = true;
  int type = 2;
  final AppDatabase database = AppDatabase();
  TextEditingController categoryNameController = TextEditingController();

  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            name: name, type: type, createdAt: now, updatedAt: now));

    print(row);
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

// update
  Future update(int categoryId, String newName) async {
    return await database.updateCategoryRepo(categoryId, newName);
  }

  void openDialog(Category? category) {
    if (category != null) {
      categoryNameController.text = category.name;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        (isPengeluaran == true)
                            ? "Masukkan Kategori Pengeluaran"
                            : "Masukkan Kategori Pemasukan",
                        style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: (isPengeluaran == true)
                                ? Colors.red
                                : Colors.green),
                      ),
                    ),
                    TextFormField(
                      controller: categoryNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: "Name"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Back")),
                          SizedBox(width: 10),
                          ElevatedButton(
                              onPressed: () {
                                if (category == null) {
                                  insert(categoryNameController.text,
                                      isPengeluaran ? 2 : 1);
                                } else {
                                  update(
                                      category.id, categoryNameController.text);
                                }
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                                setState(() {});
                                categoryNameController.clear();
                              },
                              child: Text("Save"))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Switch(
                value: isPengeluaran,
                onChanged: (bool value) {
                  setState(() {
                    isPengeluaran = value;
                    type = value ? 2 : 1;
                  });
                },
                inactiveTrackColor: Colors.green[200],
                inactiveThumbColor: Colors.green,
                activeColor: Colors.red,
              ),
              IconButton(
                  onPressed: () {
                    openDialog(null);
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
        ),
        FutureBuilder<List<Category>>(
            future: getAllCategory(type),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Card(
                              elevation: 10,
                              child: ListTile(
                                trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            openDialog(snapshot.data![index]);
                                          },
                                          icon: Icon(Icons.edit)),
                                      SizedBox(width: 8),
                                      IconButton(
                                          onPressed: () {
                                            database.deleteCategoryRepo(
                                                snapshot.data![index].id);
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.delete))
                                    ]),
                                leading: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: (isPengeluaran)
                                      ? Icon(
                                          Icons.upload,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.download,
                                          color: Colors.green,
                                        ),
                                ),
                                title: Text(snapshot.data![index].name),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: Text("No has data!!"),
                    );
                  }
                } else {
                  return Center(
                    child: Text("No has data!!"),
                  );
                }
              }
            }),
        Spacer(),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return LoginPage();
                },
              ));
            },
            child: Text('Logout'))
      ],
    ));
  }
}
