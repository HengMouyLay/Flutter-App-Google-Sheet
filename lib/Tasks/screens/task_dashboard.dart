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
      //margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
      width: screenWidth,
      height: screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.purple,Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft
        )
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildGridTaskDashboard(),
            _buildListViewTask(),
          ],
        ),
      ),
    );
  }
  Widget _buildGridTaskDashboard(){
   return SizedBox(
     width:screenWidth,
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
  Widget _buildListViewTask(){
   return Container(
     width: screenWidth,
     height: screenHeight,
     color: Colors.transparent,
     child: ListView.builder(
         itemCount: listDashboardModel.length,
         itemBuilder: (context,index){
           return _buildItemListViewTask(listDashboardModel[index]);
         }
     ),
   );
  }
  Widget _buildItemListViewTask(TaskDashboardModel item){
   return Container(
     margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
     width: screenWidth,
     height: 100,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(5),
       color: Colors.white,
     ),
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Row(
           children: [
             _buildIconStatus(item.status.toString()),
             const SizedBox(width: 10,),
             Column(
               children: [
                 SizedBox(
                   width: 150,
                   child: Text(
                     item.taskName.toString(),
                     overflow: TextOverflow.ellipsis,
                     maxLines: 1,
                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                   ),
                 )
                 ,
                 Text("${item.assignee}"),
                 Text("${item.startDate}"),
               ],
             ),
           ],
         ),

       ],
     ),
   );
  }
  Widget _buildIconStatus(String status){
   Widget result = SizedBox();
   if(status == "Pending"){
     result =  Container(child: Icon(Icons.pending,color: Colors.amber,size: 60,),);
   }
   else if(status == "Completed"){
     result =  Container(child: Icon(Icons.check_circle,color: Colors.green,size: 60,),);
   }
   else if(status == "In Progress"){
     result =  Container(child: Icon(Icons.lock_clock,color: Colors.green,size: 60,),);
   }
   return result;
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
            Text(info.number.toString(),style: TextStyle(color: info.color,fontWeight: FontWeight.bold,fontSize: 20),),
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