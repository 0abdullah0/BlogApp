import 'package:blog/models/post.dart';
import 'package:flutter/material.dart';
import './add_post.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timeago/timeago.dart' as timeago;
import './viewPost.dart' as Postview;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseDatabase _database=FirebaseDatabase.instance;
  List<Post> PostsList=<Post>[];
  @override
  void initState() { //LISTNERS
    // TODO: implement initState
    _database.reference().child('posts').onChildAdded.listen(_childAdded);
    _database.reference().child('posts').onChildRemoved.listen(_childRemoved);
    _database.reference().child('posts').onChildChanged.listen(_childChanged);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body:Container(
        color: Colors.black87,
        child: Column(
          children: <Widget>[

            Flexible(
              child: FirebaseAnimatedList(query:_database.reference().child('posts'), itemBuilder:(_,DataSnapshot snap,Animation<double> animation,int index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (contex)=>Postview.PostView(PostsList[index])));
                      },
                      title: Text(PostsList[index].title,style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(bottom:14.0),
                        child: Text(PostsList[index].body),
                      ),
                      trailing: Text(timeago.format(DateTime.fromMicrosecondsSinceEpoch(PostsList[index].date)),
                        style: TextStyle(fontSize: 14.0,color: Colors.grey),),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>AddPost()));
      },
      child:Icon(Icons.edit,color: Colors.white,),
        backgroundColor: Colors.red,
        tooltip: "Add a post",
      ),
    );
  }

  void _childAdded(Event event) {
    setState(() {
      PostsList.add(Post.fromSnapshot(event.snapshot));
    });
  }

  void _childRemoved(Event event) {
    var deletedPost=PostsList.singleWhere((post){
      return post.key==event.snapshot.key;
    });
    setState(() {
      PostsList.removeAt(PostsList.indexOf(deletedPost));
    });

  }

  void _childChanged(Event event) {
    var changedPost=PostsList.singleWhere((post){
      return post.key==event.snapshot.key;
    });

    setState(() {
      PostsList[PostsList.indexOf(changedPost)]=Post.fromSnapshot(event.snapshot);
    });
  }
}
