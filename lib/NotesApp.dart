import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'EditNote.dart';
import 'Provider.dart';

class NotesScreen extends StatefulWidget {
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  final titleController = TextEditingController();
  final descController = TextEditingController();
@override
void initState() {
  super.initState();
  Future.microtask(() {
    Provider.of<NotesApp>(context, listen: false).getNotes();
  });
}


  @override
  Widget build(BuildContext context) {
  final provider = Provider.of<NotesApp>(context, listen: true);
    return Scaffold(
      key: scaffoldkey,
      floatingActionButton: FloatingActionButton(
        child: Icon(provider.bottomsheetopened ? Icons.clear : Icons.add),
        onPressed: () {
          if (provider.bottomsheetopened == false) {
            scaffoldkey.currentState!
                .showBottomSheet((context) => Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 12.5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                                hintText: 'title',
                                border: UnderlineInputBorder()),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: descController,
                            decoration: InputDecoration(
                                hintText: 'description',
                                border: UnderlineInputBorder()),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: MaterialButton(
                              color: Colors.teal,
                              onPressed: () {
                                if (titleController.text.isNotEmpty &&
                                    descController.text.isNotEmpty) {
                                  provider.addNote(
                                      title: titleController.text,
                                      description: descController.text);
                                  titleController.clear();
                                  descController.clear();
                                  Navigator.pop(context);
                                  provider.toggleBottomSheet();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Please fill the textformfield,try again!')));
                                }
                              },
                              child: Text(
                                'Add Note',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
                .closed
                .then((value) {
              debugPrint('closed');
            });
            provider.toggleBottomSheet();
          } else {
            provider.toggleBottomSheet();
            Navigator.pop(context);
          }
        },
      ),
      appBar: AppBar(
  actions: [
    IconButton(
      onPressed: () {
        provider.changeSearchStatus();
      },
      icon: Icon(provider.searchenabled ? Icons.clear : Icons.search),
    ),
  ],
  title: provider.searchenabled
      ? TextFormField(
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            provider.searchAboutUsers(searchbar:value);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search about User',
            hintStyle: TextStyle(color: Colors.white),
          ),
        )
      : Text('Notes'),
),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.notesData[index]['title'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(provider.notesData[index]['description']),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditNotes(
                                    description: provider.notesfiltered.isEmpty? provider.notesData[index]['description']:provider.notesfiltered[index]['description'],
                                    noteskey: provider.notesfiltered.isEmpty? provider.notesData[index]['key']:provider.notesfiltered[index]['key'],
                                    title: provider.notesfiltered.isEmpty? provider.notesData[index]['title']:provider.notesfiltered[index]['title'],
                                  )));
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          provider.deletenotes(
                              noteskey: provider.notesData[index]['key']);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(
            height: 10,
          ),
          itemCount:  provider.notesfiltered.isEmpty?provider.notesData.length:provider.notesfiltered.length,
        ),
      ),
    );
  }
}

/* throught the ref i said give me the keys i want to loop throught that keys
     so i use map  to return map i get the map that is stored inside the cache */
