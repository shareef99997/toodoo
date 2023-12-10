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
              colors: [Color(0xffc14e06), Color(0xffd20f0f)],
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

  Widget _todocard(){
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 234, 100, 16), Color.fromARGB(255, 210, 80, 15)],
          stops: [0.25, 0.75],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2,
          )
        ]
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(10),
            title: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(todoTitle,
              style: TextStyle(fontSize: 19),
              ),
            ),
            subtitle: Text(
              todoDesc,
              style: TextStyle(fontSize: 19),
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 0.8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3,horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  todoDT,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddUpdateTask(todoId:todoId ,todoTitle:todoTitle ,todoDesc:todoDesc,todoDT: todoDT,update:true )));
                  },
                  child: Icon(Icons.edit_note,size: 28,color: Colors.green,),
                ),
              ],
            ),
          )
        ]
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
                todoId = snapshot.data![index].id!.toInt();
                todoTitle = snapshot.data![index].title.toString();
                todoDesc = snapshot.data![index].desc.toString();
                todoDT = snapshot.data![index].dateandtime.toString();

                
              ///Dismissible
              return Dismissible(
                key: ValueKey<int>(todoId),
                direction:DismissDirection.endToStart ,
                background:ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Color.fromARGB(255, 248, 63, 63),
                    child: Icon(Icons.delete_forever, color: Colors.white),
                  ),
                ),
                onDismissed: (DismissDirection direction){
                  setState(() {
                    dbHelper!.delete(todoId);
                    dataList =dbHelper!.getDataList();
                    snapshot.data!.remove(snapshot.data![index]);
                  });
                },
                child: _todocard()
              );
            },
          );
        }
      },
    );
  }
}
