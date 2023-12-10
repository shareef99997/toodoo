import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toodoo/db_handler.dart';
import 'package:toodoo/home_screen.dart';
import 'package:toodoo/model.dart';

class AddUpdateTask extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDesc;
  String? todoDT;
  bool? update;

  AddUpdateTask({
    this.todoId,
    this.todoTitle,
    this.todoDesc,
    this.todoDT,
    this.update,
  });

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {


  /////////////Declerations////////////////
  late Future<List<TodoModel>> dataList;
  final _fromKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descController;
  DBHelper? dbHelper;
  DateTime selectedDateTime = DateTime.now();
  String appTitle ='';
  /////////////Declerations////////////////


  /////////////////////Functions/////////////////////
    //Load Data
    loadData() async {
    dataList = dbHelper!.getDataList();
  }
    
    //Date Widget
    Future<void> _selectDate(BuildContext context) async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDateTime,
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (picked != null && picked != selectedDateTime)
          setState(() {
            selectedDateTime = DateTime(
              picked.year,
              picked.month,
              picked.day,
              selectedDateTime.hour,
              selectedDateTime.minute,
            );
          });
      }
    
    //Time Widget
    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      if (picked != null)
        setState(() {
          selectedDateTime = DateTime(
            selectedDateTime.year,
            selectedDateTime.month,
            selectedDateTime.day,
            picked.hour,
            picked.minute,
          );
        });
    }

  /////////////////////Functions/////////////////////
  
  ////////////Init State////////////
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todoTitle);
    descController = TextEditingController(text: widget.todoDesc);
    dbHelper = DBHelper();
    loadData();
    
    if (widget.update == true) {
      appTitle = "Update Task";
      } else {
        appTitle = "Add Task";
    }
  }
  ////////////Init State////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle,style: TextStyle( fontSize: 22,fontWeight: FontWeight.w900,letterSpacing: 1,color: Color.fromARGB(255, 241, 135, 13),),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Form Function
              _buildForm(),
              SizedBox(height: 40),
              //Buttons Function
              _Buttons()
            ],
          ),
        ),
      ),
    );
  }  
  










  //////////// Form Widget ////////////
  Widget _buildForm() {
    return Form(
      key: _fromKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              controller: titleController,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Note Title",
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              controller: descController,
              maxLines: null,
              minLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Description",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter some text";
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select Date'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _selectTime(context),
            child: Text('Select Time'),
          ),
        ],
      ),
    );
  }
  
  /////////// Buttons Widget ///////////
  Widget _Buttons(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Submit Button
          Material(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {
                if (_fromKey.currentState!.validate()) {
                  if (widget.update == true) {
                    dbHelper!.update(TodoModel(
                      id: widget.todoId,
                      title: titleController.text,
                      desc: descController.text,
                      dateandtime: DateFormat('yMd').add_jm().format(selectedDateTime).toString(),
                    ));
                  } else {
                    dbHelper!.insert(TodoModel(
                      title: titleController.text,
                      desc: descController.text,
                      dateandtime: DateFormat('yMd').add_jm().format(selectedDateTime).toString(),
                    ));
                  }
                  Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => HomeScreen()),(route) => false); 
                  titleController.clear();
                  descController.clear();
                  print("data added");
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 55,
                width: 120,
                decoration: BoxDecoration(),
                child: Text("Submit", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ),
          // Clear Button
          Material(
            color: Color.fromARGB(255, 200, 1, 1),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {
                setState(() {
                  titleController.clear();
                  descController.clear();
                });
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 55,
                width: 120,
                decoration: BoxDecoration(),
                child: Text("Clear", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}