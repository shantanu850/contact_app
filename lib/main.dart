import 'dart:math';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> contacts = [];
  List<Contact> results = [];
  bool load,isSearching;
  List<Color> randomeColoe = [
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.green,
    Colors.redAccent,
  ];
  Random randome = new Random(4);
  TextEditingController searchCont = new TextEditingController();
  getContacts()async{
    List<Contact> _contacts = (await ContactsService.getContacts().whenComplete((){
      load = false;
    })).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  void initState() {
    load = true;
    isSearching = false;
    getContacts();
    searchCont.addListener(() {
      search();
    });
    super.initState();
  }
  search(){
    List<Contact> cont = [];
    cont.addAll(contacts);
    if(searchCont.text.isNotEmpty){
      cont.retainWhere((element) {
        String searchTerm = searchCont.text.toLowerCase();
        String contactsName = element.displayName.toLowerCase();
        return contactsName.contains(searchTerm);
      }
      );
      setState((){
        results = cont;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,84),
        child: Container(
          margin: EdgeInsets.only(top:30,left:20,right:20,bottom:20),
          child: Card(
            elevation: 10,
            child: ListTile(
              leading:Icon(Icons.menu) ,
              title: TextField(
                onChanged:(v){
                  setState(() {
                    isSearching = true;
                  });
                },
                controller: searchCont,
                decoration: InputDecoration(
                ),
              ),
              trailing:IconButton(icon:Icon(Icons.perm_identity), onPressed: null),
            ),
          ),
        ),
      ),
      body:Container(
        child:(load==false)?Container(
          padding: EdgeInsets.symmetric(horizontal:20),
          child: ListView.builder(
              itemCount: (isSearching==true)?results.length:contacts.length,
              itemBuilder:(contaxt,index){
                Contact conta = (isSearching==true)?results[index]:contacts[index];
                return ListTile(
                  onTap:(){
                    _showContact(context,contacts[index]);
                  },
                  leading:(conta.avatar != null && conta.avatar.length >0)?
                  CircleAvatar(
                    backgroundImage:MemoryImage(conta.avatar),
                  ):CircleAvatar(
                      child:Text(conta.initials())),
                  title:Text(conta.displayName),
                  subtitle: Text((conta.phones.isNotEmpty)?conta.phones.elementAt(0).value:"No Number"),
                );
              }),
        ):Container(
            alignment:Alignment.center,
            child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void _showContact(context,contact){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            padding: EdgeInsets.all(20),
            child: new Wrap(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(10),
                  alignment:Alignment.topCenter,
                  child:(contact.avatar != null && contact.avatar.length >0)?
                  CircleAvatar(
                    radius: 70,
                    backgroundImage:MemoryImage(contact.avatar),
                  ):CircleAvatar(
                      radius: 70,
                      child:Text(contact.initials(),
                        style:TextStyle(
                          fontSize:36,
                          fontWeight: FontWeight.bold,
                        ),)),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child:Text((contact.phones.isNotEmpty)?contact.phones.elementAt(0).value:"No Number",
                    style:TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FlatButton.icon(
                        color:Colors.blue,
                        textColor: Colors.white,
                        icon:Icon(Icons.phone),
                        onPressed:(){
                          String num = "tel:"+contact.phones.elementAt(0).value;
                          launch(num);
                        },
                        label: Text("Call"),
                      ),
                      SizedBox(width:10,),
                      FlatButton.icon(
                        color:Colors.blue,
                        textColor: Colors.white,
                        icon:Icon(Icons.message),
                        onPressed:(){

                        },
                        label: Text("Text"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> contacts;
  bool load;
  getContacts()async{
    List<Contact> _contacts = (await ContactsService.getContacts().whenComplete((){
      load = false;
    })).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  void initState() {
    load = true;
    getContacts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Container(
        child:(load==false)?ListView.builder(
            itemCount: contacts.length,
            itemBuilder:(contaxt,index){
              return ListTile(
                leading:(contacts[index].avatar != null && contacts[index].avatar.length >0)?
                CircleAvatar(
                  backgroundImage:MemoryImage(contacts[index].avatar),
                ):CircleAvatar(
                    child:Text(contacts[index].initials())),
                title:Text(contacts[index].displayName),
                subtitle: Text((contacts[index].phones.isNotEmpty)?contacts[index].phones.elementAt(0).value:"No Number"),
              );
            }):Text("loading"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
 */