import 'package:blog/models/post.dart';
import 'package:firebase_database/firebase_database.dart';

class PostService{
  String nodeName="posts";
  FirebaseDatabase database=FirebaseDatabase.instance;
  DatabaseReference _databaseReference;
  Map post;

  PostService(this.post);
  //CRUD OPERATIONS

  addPost(){//pointer refer to posts node
    _databaseReference=database.reference().child(nodeName);
    _databaseReference.push().set(post);
  }
  deletePost(){
    _databaseReference=database.reference().child('$nodeName/${post['key']}');
    _databaseReference.remove();
  }

  updatePost(){
    _databaseReference=database.reference().child('$nodeName/${post['key']}');
    _databaseReference.update(
      {"body":post['body'],"date":post['date'],"title":post['title']}
    );
  }
}