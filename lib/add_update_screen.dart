import 'package:flutter/material.dart';
import 'package:toodoo/db_handler.dart';
import 'package:toodoo/model.dart';

class AddUpdateTask extends StatefulWidget {
  const AddUpdateTask({super.key});

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
 
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async{
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {

    final titleController = TextEditingController();
    final descController = TextEditingController();

    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Add",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1,color: Color.fromARGB(255, 241, 135, 13)),
            ),
            Text(
              "/",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1,color: Color.fromARGB(255, 79, 79, 79)),
            ),
            Text(
              "Update",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 1),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding:EdgeInsets.only(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _fromKey,
                child:Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller:titleController ,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Note Title"
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller:descController ,
                        maxLines: null,
                        minLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Description"
                        ),
                        validator:(value){
                          if (value!.isEmpty){
                            return "Enter some text";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(height: 40),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          if (_fromKey.currentState!.validate()) {
                            dbHelper!.insert(TodoModel(
                              title: titleController.text,
                              desc: descController.text,
                              dateandtime: DateFormat('yMd')
                              .add_jm()
                              .format(DateTime.now())
                              .toString()
                            ));
                          }
                        },
                        child: Container(
                          alignment:Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 55,
                          width: 120,
                          decoration:BoxDecoration(),
                          child: Text("Submit",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600 ,color: Colors.white)),
                        ),
                      ),
                    ),
                    Material(
                      color: Color.fromARGB(255, 200, 1, 1),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          setState((){
                            titleController.clear();
                            descController.clear();
                          });
                        },
                        child: Container(
                          alignment:Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 55,
                          width: 120,
                          decoration:BoxDecoration(),
                          child: Text("Clear",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600 ,color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]
          ),
        ), 
      ),
    );
  }
}