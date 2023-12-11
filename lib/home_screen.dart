// ignore_for_file: prefer_const_constructors, prefer_is_empty, non_constant_identifier_names, prefer_const_literals_to_create_immutables

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

  /////////////Declerations////////////////
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;  
  late int todoId;
  String todoTitle ='';
  String todoDesc='';
  String todoDT='';
  /////////////Declerations////////////////
  
  /////////////////////Functions/////////////////////
  loadData() async{
    dataList = dbHelper!.getDataList();
  }
  
  /////////////////////Functions/////////////////////
  
  ////////////Init State////////////
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }
  ////////////Init State////////////


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 45, 38, 34),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Too",
              style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: 1,color: Color.fromARGB(255, 241, 135, 13)),
            ),
            Text(
              "Doo",
              style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.w500, letterSpacing: 1,color: Color.fromARGB(235, 255, 255, 255)),
            ),
          ],
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: _FutuerBuilder(),
          )
        ],
      ),
      floatingActionButton:FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUpdateTask()),
          );
        },
        backgroundColor: Colors.transparent, // Set the color to transparent
        child: Container(
          width: 500,
          height: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: [Color.fromARGB(255, 234, 100, 16), Color.fromARGB(255, 210, 80, 15)],
            stops: [0.25, 0.75],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),

    );
  }

  Widget _todocard({required int todoId,required String todoTitle,required String todoDesc,required String todoDT,}) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color.fromARGB(255, 229, 100, 19), Color.fromARGB(255, 238, 111, 47)],
            stops: [0.25, 0.75],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(209, 219, 90, 10).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todoTitle,
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  todoDesc,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0)
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: const Color.fromARGB(255, 238, 238, 238),
            thickness: 1.5,
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  todoDT,
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddUpdateTask(
                          todoId: todoId,
                          todoTitle: todoTitle,
                          todoDesc: todoDesc,
                          todoDT: todoDT,
                          update: true,
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.edit,
                    size: 27,
                    color: Color.fromARGB(255, 1, 110, 79),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _FutuerBuilder(){
    return FutureBuilder(
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
                color: const Color.fromARGB(255, 3, 3, 3)
              ),
            ),
          );
        }else{
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              int todoId = snapshot.data![index].id!.toInt();
              String todoTitle = snapshot.data![index].title.toString();
              String todoDesc = snapshot.data![index].desc.toString();
              String todoDT = snapshot.data![index].dateandtime.toString();

              return Dismissible(
                key: ValueKey<int>(todoId),
                direction: DismissDirection.endToStart,
                background: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Color.fromARGB(255, 248, 63, 63),
                    child: Icon(Icons.delete_forever, color: Colors.white),
                  ),
                ),
                onDismissed: (DismissDirection direction) {
                  setState(() {
                    dbHelper!.delete(todoId);
                    dataList = dbHelper!.getDataList();
                    snapshot.data!.remove(snapshot.data![index]);
                  });
                },
                child: _todocard(
                  todoId: todoId,
                  todoTitle: todoTitle,
                  todoDesc: todoDesc,
                  todoDT: todoDT,
                ),
              );
            },
          );
        }
      },
    );
  }
}
