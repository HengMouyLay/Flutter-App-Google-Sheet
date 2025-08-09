import 'package:flutter/material.dart';

import '../models/task_dashboard_model.dart';
import '../services/task_service.dart';

class TaskDashboard extends StatefulWidget {
  const TaskDashboard({super.key});

  @override
  State<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends State<TaskDashboard> {
  //SERVICE
  TaskService taskService = TaskService();
  //MODEL
  List<TaskDashboardModel> listDashboardModel = [];
  //VARIABLE
  double screenWidth = 0;
  double screenHeight = 0;
  List<CardTaskInfo> listCardSummary = [];
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }
  @override
  Widget build(BuildContext context) {
   screenWidth = MediaQuery.of(context).size.width;
   screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white.withGreen(500),
      appBar: _buildAppBar(),
      body: _buildBody(),
    ));
  }
  AppBar _buildAppBar(){
   return AppBar(
     title: Text("Tasks Tracker",style: TextStyle(color: Colors.white),),
     centerTitle: true,
     backgroundColor: Colors.indigoAccent,
   );
  }
  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
      width: screenWidth,
      height: screenHeight,
      child: SingleChildScrollView(
        child:  _buildGridTaskDashboard(),
      ),
    );
  }
  Widget _buildGridTaskDashboard(){
   return SizedBox(
     width:screenWidth,
     height: screenHeight,
     child: GridView.builder(
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: 3,   // 3 columns
         mainAxisSpacing: 1, // vertical spacing
         crossAxisSpacing: 1,// horizontal spacing
         childAspectRatio: 1, // width / height ratio of each tile
       ),
       itemCount: listCardSummary.length,
       itemBuilder: (context, index) {
         return buildCardTask(listCardSummary[index]);
       },
     )
     ,
   );
  }

  Widget buildCardTask(CardTaskInfo info){
    return  SizedBox(
     // margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      width: 150,
      height: 150,
      child: Card(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(info.icon,color: info.color,size: 50,),
            const SizedBox(height: 10,),
            Text(info.taskTitle),
            const SizedBox(height: 10,),
            Text(info.number.toString(),style: TextStyle(color: info.color,fontWeight: FontWeight.b),),
          ],
        ),
      ),
    );
  }

 void initData(){
   getTaskDashboard();
 }
 void getTaskDashboard() async{
   listDashboardModel = await taskService.fetchDataDashboard();
   listCardSummary.clear();
   addItemCardInfo();
 }
 void addItemCardInfo(){
   listCardSummary.add(CardTaskInfo(icon: Icons.task,color: Colors.deepPurple,taskTitle: "All Tasks",number: listDashboardModel.length,status: "all"));
   listCardSummary.add(CardTaskInfo(icon: Icons.pending,color: Colors.amber,taskTitle: "Pending Task",number: listDashboardModel.where((item) => item.status == "Pending").length,status: "pending"));
   listCardSummary.add(CardTaskInfo(icon: Icons.check_circle,color: Colors.green,taskTitle: "Complete Task",number: listDashboardModel.where((item) => item.status == "Completed").length,status: "complete"));

   setState(() {});
   }
}
class CardTaskInfo {
  IconData icon;
  Color color;
  String taskTitle;
  int number;
  String status;

  CardTaskInfo({this.icon = Icons.task,this.color = Colors.indigoAccent,this.taskTitle = "", this.number = 0,this.status = "complete"});
}