import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_example/inject/future_object.dart';
import 'package:provider_example/inject/network_provider.dart';
import 'package:provider_example/inject/notify_object.dart';
import 'package:provider_example/inject/simple_model.dart';
import 'package:provider_example/network/api_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        Provider<SimpleModel>(
          create: (context) => SimpleModel(),
        ),
        FutureProvider<FutureObject>(
          create: (context) => FutureObject().create(),
        ),
        Provider<ApiService>(
          create: (_) => ApiService.create(),
        ),
        ChangeNotifierProvider<NotifyObject>(
          create: (context) => NotifyObject(),
        ),
        Provider<NetworkProvider>(
          create: (context) => NetworkProvider(),
          dispose: (context, service) => service.disposeStreams(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blueAccent
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Provider Sample"),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(children: <Widget>[
              Consumer<SimpleModel>(
                  builder: (context, simpleModel, child)
                  {
                    print("SimpleModel Container Widget Built!");
                    return Container(
                      width: double.infinity,
                      height: 100.0,
                      child: Center(
                        child: Text("${simpleModel.appId}"),
                      ),
                  );
                }
              ),
              Consumer<NotifyObject>(
                builder: (context, notifyObject, child) {
                  print("NotifyObject Container Widget Built!");
                  return Container(
                    width: double.infinity,
                    height: 100.0,
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Text(
                          "${notifyObject.count}",
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  );
                },
              ),
              Consumer<FutureObject>(
                builder: (context, futureObject, child) {
                 return OutlineButton.icon(
                     onPressed: () async {
                       await futureObject.setToSharedPreference();
                     },
                     icon: Icon(Icons.create),
                     label: Text("Write Prefs"));
                },
              ),
              Consumer<FutureObject>(
                builder: (context, futureObject, child) {
                  return OutlineButton.icon(
                      onPressed: () async {
                        await futureObject.getFromSharedPreference();
                        print(futureObject.prefValue);
                      },
                      icon: Icon(Icons.done),
                      label: Text("Get Prefs")
                  );
                },
              ),
              Consumer<NetworkProvider>(
                builder: (context, networkProvider, child) {
                  return StreamProvider<ConnectivityResult>.value(
                    value: networkProvider.networkStatusController.stream,
                    child: Consumer<ConnectivityResult>(
                      builder: (context, value, _) {
                        if(value == null) {
                          return Container(
                            width: double.infinity,
                            height: 100.0,
                            child: Center(
                              child: Text("Error"),
                            ),
                          );
                        }
                        return Container(
                          width: double.infinity,
                          height: 100.0,
                          child: Center(
                            child: Text("${(value != ConnectivityResult.none)? value: 'Offline'}"),
                          ),
                        );
                      },
                    ),
                  );
                },
              )

            ]),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ActionButton(),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              ApiButton()
              ],
          )
        ),
      ),
    );
  }
}

class ApiButton extends StatelessWidget {
  const ApiButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ApiService>(context, listen: false);
    return FloatingActionButton.extended(
        onPressed: () async {
            api.getTasks().then((it) {
              it.forEach((f) {
                print("ID : ${f.id}, Name : ${f.name}");
              });
            }).catchError((onError) {
              print(onError.toString());
            });

        },
        icon: Icon(Icons.done),
        label: Text("REST API"));
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifyObject = Provider.of<NotifyObject>(context, listen: false);
    print("Action Button Built");
    return FloatingActionButton.extended(
        onPressed: () {
          notifyObject.increase();
        },
        label: Text("Increase"),
        icon: Icon(Icons.add),
    );
  }
}
