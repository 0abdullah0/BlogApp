import 'package:blog/db/PostService.dart';
import 'package:blog/models/post.dart';
import 'package:flutter/material.dart';

class EditPost extends StatefulWidget {
  final Post post; //old post

  const EditPost(this.post);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {

  final GlobalKey<FormState> formKey=new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EDIT Post"),
        elevation: 0.0,
      ),
      body: new Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.post.title,
                  decoration: InputDecoration(
                    labelText:"add title",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (val)=>widget.post.title=val,
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
                  initialValue: widget.post.body,
                  decoration: InputDecoration(
                    labelText:"add body",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (val)=>widget.post.body=val,
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
        child:Icon(Icons.edit,color: Colors.white,),
        backgroundColor: Colors.red,
        tooltip: "Edit a post",
      ),
    );
  }

  void insertPost() {
    final FormState form=formKey.currentState;
    if(form.validate()){
      form.save();
      form.reset();
      widget.post.date=DateTime.now().microsecondsSinceEpoch;
      PostService postService=PostService(widget.post.toMap());
      postService.updatePost();
    }
  }
}
