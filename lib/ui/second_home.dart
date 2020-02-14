import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_example/network/api_service.dart';
import 'package:provider_example/network/model/task_model.dart';


class SecondHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Home"),
      ),
      body: _buildTasks(context),
    );
  }

  FutureBuilder _buildTasks(BuildContext context) {
    return FutureBuilder<List<TaskModel>>(
      future: Provider.of<ApiService>(context, listen: false).getTasks(),
      builder: (context, AsyncSnapshot<List<TaskModel>> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasError) {
            return Center(
              child: Text("Something wrong"),
            );
          }
          final tasks = snapshot.data;
          return _listTasks(tasks);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  ListView _listTasks(List<TaskModel> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            trailing: Image.network(tasks[index].avatar),
            title: Text("${tasks[index].name}"),
            subtitle: Text("${tasks[index].id}"),
          ),
        );
     }
    );
  }
}
