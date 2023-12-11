// ignore_for_file: prefer_const_constructors, avoid_print, deprecated_member_use, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, non_constant_identifier_names, use_key_in_widget_constructors, curly_braces_in_flow_control_structures, must_be_immutable

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
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                primaryColor: Color.fromARGB(255, 241, 135, 13), // Your custom color
                hintColor: Color.fromARGB(255, 241, 135, 13), // Your custom color
                colorScheme: ColorScheme.dark(primary: Color.fromARGB(255, 241, 135, 13)), // Your custom color
                buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child!,
            );
    },
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
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              primaryColor: Color.fromARGB(255, 241, 135, 13), // Your custom color
              hintColor: Color.fromARGB(255, 241, 135, 13), // Your custom color
              colorScheme: ColorScheme.dark(primary: Color.fromARGB(255, 241, 135, 13)), // Your custom color
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );

  if (picked != null) {
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
      backgroundColor: Color.fromARGB(255, 53, 49, 45),
      appBar: AppBar(
        title: Text(appTitle,style: TextStyle( fontSize: 22,fontWeight: FontWeight.w900,letterSpacing: 1,color: Color.fromARGB(255, 241, 135, 13),),),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Form Function
              _buildForm(),
              SizedBox(height: 220),
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
              style: TextStyle(fontSize: 18, color: Colors.white), // Adjust the font size as needed
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 4),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Note Title",
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(
                  Icons.title, // Replace with your desired icon
                  color: Colors.white,
                ),
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
              style: TextStyle(fontSize: 16, color: Colors.white), // Adjust the font size as needed
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 4,),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Description",
                hintStyle: TextStyle(color: Colors.grey[400]),
                errorStyle: TextStyle(fontSize: 14), // Adjust error text size
                prefixIcon: Icon(
                  Icons.description, // Replace with your desired icon
                  color: Colors.white,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter some text";
                }
                return null;
              },
            ),
          ),        
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Date and Time
              Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 214, 85, 5), Color.fromARGB(255, 238, 111, 47)],
                    stops: [0.25, 0.75],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.transparent, // Set the color to transparent
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Icon(Icons.calendar_month_outlined,color: Colors.white,),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 214, 85, 5), Color.fromARGB(255, 238, 111, 47)],
                    stops: [0.25, 0.75],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.transparent, // Set the color to transparent
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => _selectTime(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Icon(Icons.timer_sharp,color: Colors.white,),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /////////// Buttons Widget ///////////
  Widget _Buttons() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 214, 85, 5), Color.fromARGB(255, 238, 111, 47)],
                stops: [0.25, 0.75],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 234, 100, 16), // Use the same color as the gradient
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
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
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
                  titleController.clear();
                  descController.clear();
                  print("data added");
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 55,
                width: 260,
                child: Text("Submit", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),

    );
 }

}