class TaskDashboardModel {
  TaskDashboardModel({
    this.taskId,
    this.taskName,
    this.status,
    this.assignee,
    this.due,
    this.priority,
    this.tags,
    this.project,
    this.startDate,
    this.complete,
  });

  final int? taskId;
  final String? taskName;
  final String? status;
  final String? assignee;
  final String? due;
  final String? priority;
  final String? tags;
  final String? project;
  final String? startDate;
  final String? complete;

  factory TaskDashboardModel.fromJson(Map<String, dynamic> json){
    return TaskDashboardModel(
      taskId: json["task_id"],
      taskName: json["task_name"],
      status: json["status"],
      assignee: json["assignee"],
      due: json["due"],
      priority: json["priority"],
      tags: json["tags"],
      project: json["project"],
      startDate: json["start_date"],
      complete: json["complete"],
    );
  }

}
