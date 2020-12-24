import 'package:blog/db/PostService.dart';
import 'package:blog/models/post.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  final GlobalKey<FormState> formKey=new GlobalKey();
  Post post=Post(0," "," ");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
        elevation: 0.0,
      ),
      body: new Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText:"add title",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (val)=>post.title=val,
                  validator: (val){
                    if(val.isEmpty){
                      return "title can't be empty";
                    } else if(val.length>16)
                      return "no more  than 16";
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText:"add body",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (val)=>post.body=val,
                  validator: (val){
                    if(val.isEmpty){
                      return "body can't be empty";
                    }
                  },
                ),
              )
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        insertPost();
          Navigator.pop(context);
      },
        child:Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.red,
        tooltip: "Add a post",
      ),
    );
  }

  void insertPost() {
    final FormState form=formKey.currentState;
    if(form.validate()){
      form.save();
      form.reset();
      post.date=DateTime.now().microsecondsSinceEpoch;
      PostService postService=PostService(post.toMap());
      postService.addPost();
    }
  }
}

