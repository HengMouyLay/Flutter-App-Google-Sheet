import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../setting.dart';
import '../models/task_dashboard_model.dart';


class TaskService{
  Future<List<TaskDashboardModel>> fetchDataDashboard() async {
    String baseUrl = Setting.baseUrl;
    final url = Uri.parse(baseUrl);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<TaskDashboardModel> data = jsonList
          .map((jsonItem) => TaskDashboardModel.fromJson(jsonItem))
          .toList();
      return data;
    } else {
      throw Exception('Failed to load data from Google Sheets');
    }
  }


}