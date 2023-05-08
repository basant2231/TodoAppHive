import 'package:flutter/material.dart';
import 'package:hivenotesapp/NotesApp.dart';
import 'package:provider/provider.dart';

import 'Provider.dart';

class EditNotes extends StatelessWidget {
  final String title;
  final String description;
  final  noteskey;
  EditNotes({
    required this.title,
    required this.description,
    required this.noteskey,
  });
  final titleController = TextEditingController();
  final descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotesApp>(context, listen: true);
    titleController.text = title;
    descController.text = description;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (titleController.text != title ||
              descController.text != description) {
            provider.updatenote(notekey:noteskey,
                titlecontroller: titleController.text,
                descriptioncontroller: descController.text);
                Navigator.push(context,MaterialPageRoute(builder: (context) =>NotesScreen()) );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("there is no changes on data")));
          }
        },
        child: Icon(Icons.edit),
      ),
      appBar: AppBar(
        
        elevation: 0,
        title: Text('Edit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(border: UnderlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(border: UnderlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }
}
