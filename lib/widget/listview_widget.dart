import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/providers/users_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListViewWidget extends StatefulWidget {
  final UsersProvider usersProvider;

  const ListViewWidget({
    required this.usersProvider,
    Key? key,
  }) : super(key: key);

  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  final scrollController = ScrollController();
  int cou=0;

  List<int?> likels = List.filled(200, 0, growable: true);

  Future<void> _incrementCounter(int rank) async {
   // final SharedPreferences prefs = await _prefs;
    //final int counter = (prefs.getInt('counter') ?? 0) + 1;
    likels[rank]=likels[rank]!+1;


    List<String> myListOfStrings=  likels.map((i)=>i.toString()).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> myList = (prefs.getStringList('mylist') ?? <String>[]) ;
    List<int> myOriginaList = myList.map((i)=> int.parse(i)).toList();
    print('Your list  $myOriginaList');
    await prefs.setStringList('mylist', myListOfStrings);


  }

  List<int?> sharels = List.filled(200, 0, growable: true);

  Future<void> sharecount(int rank) async {
    // final SharedPreferences prefs = await _prefs;
    //final int counter = (prefs.getInt('counter') ?? 0) + 1;
    sharels[rank]=sharels[rank]!+1;


    List<String> myListOfStrings=  sharels.map((i)=>i.toString()).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> myList = (prefs.getStringList('mylist2') ?? <String>[]) ;
    List<int> myOriginaList = myList.map((i)=> int.parse(i)).toList();
    print('Your list  $myOriginaList');
    await prefs.setStringList('mylist2', myListOfStrings);


  }

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);
    widget.usersProvider.fetchNextUsers();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
        scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (widget.usersProvider.hasNext) {
        widget.usersProvider.fetchNextUsers();
      }
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
    controller: scrollController,
    padding: EdgeInsets.all(12),
    children: [
      ...widget.usersProvider.users
          .map((user) => Container(child: Column(
        children: [
          Text(user.name),
          Image.network(user.imageUrl,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
          Row(
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.thumb_up_alt_outlined,
                    ),
                    iconSize: 40,
                    color: Colors.blue,
                    splashColor: Colors.grey,
                    onPressed: () {
                      _incrementCounter(user.rank);
                      setState(() {

                      });
                      /*  FirebaseFirestore.instance
                    .collection('data').doc()
                    .update({'text': 'data added through app'});*/
                    },
                  ),
                  Text(likels[user.rank].toString())
                ],
              ),

            IconButton(
              icon: Icon(
                Icons.comment_outlined,
              ),
              iconSize: 40,
              color: Colors.blue,
              splashColor: Colors.grey,
              onPressed: () {},
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.share_outlined,
                  ),
                  iconSize: 40,
                  color: Colors.blue,
                  splashColor: Colors.grey,
                  onPressed: () {
                    sharecount(user.rank);
                  },
                ),
                Text(sharels[user.rank].toString())
              ],
            )

          ],)

        ],
      ),))/*ListTile(
        title: Text(user.name),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.imageUrl),

        ),
      ))*/
          .toList(),
      if (widget.usersProvider.hasNext)
        Center(
          child: GestureDetector(
            onTap: widget.usersProvider.fetchNextUsers,
            child: Container(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
    ],
  );
}