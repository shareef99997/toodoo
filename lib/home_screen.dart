import 'package:flutter/material.dart';
import 'package:toodoo/add_update_screen.dart';
import 'package:toodoo/db_handler.dart';
import 'package:toodoo/model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

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
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Too",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1,color: Color.fromARGB(255, 241, 135, 13)),
            ),
            Text(
              "Doo",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 1),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.help_outline_rounded,
                size: 30,
              )
              )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: dataList,
              builder: (context,AsyncSnapshot<List<TodoModel>> snapshot){
                if(!snapshot.hasData || snapshot.data == null){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else if(snapshot.data!.length == 0){
                  return Center(
                    child: Text("No Tasks Found",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  );
                }else{
                  return Container();
                  // return ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: snapshot,
                  //   );
                }
              },
            )
          )
        ],
      ),
      floatingActionButton:FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddUpdateTask(),
          ));
        },
        ) ,
    );
  }
}
