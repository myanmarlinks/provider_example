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
        final image = tasks[index].avatar;
        return Card(
          child: ListTile(
            leading: image == null ? Image.network("https://megamyanmarlink.com/apple-icon-60x60.png"): Image.network(image),
            title: Text("${tasks[index].name}"),
            subtitle: Text("${tasks[index].id.toString()}"),
          ),
        );
     }
    );
  }
}
