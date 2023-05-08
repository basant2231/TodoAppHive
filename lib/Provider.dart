import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NotesApp with ChangeNotifier {
  // so I can access any method
  final notesRef = Hive.box('Notes');

  void addNote({required String title, required String description}) async {
    await notesRef.add({
      'title': title,
      'description': description,
    });
    getNotes();
    notifyListeners();
  }
/************************************************************************** */

  // call notes from cache
  void getNotes() async {
    // Get all the keys in the notesRef map using the keys property, and use map to transform each key into a new map

    notesData = notesRef.keys.map((e) {
      // Get the note data for the current key
      //by this i will access the keys
      final currentNote = notesRef.get(e);

      // Return a new map containing the key, title, and description for the current note
      return {
        'key': e,
        'title': currentNote['title'],
        'description': currentNote['description']
      };
    }).toList(); // Convert the Iterable returned by map to a List
    debugPrint('notes length is ${notesData.length}');
    notifyListeners();
  }

/************************************************************************** */
  bool bottomsheetopened = false;
  void toggleBottomSheet() {
    bottomsheetopened = !bottomsheetopened;
    notifyListeners();
  }

/************************************************************************** */
//i need the key so i can delete the specific one
  void deletenotes({noteskey}) async {
    await notesRef.delete(noteskey);
    getNotes();
    notifyListeners();
  }

/************************************************************************** */
  void updatenote(
      {required String titlecontroller,
      required String descriptioncontroller,
      required notekey}) async {
    await notesRef.put(notekey, {
      'title': titlecontroller,
      'description': descriptioncontroller,
    });
    getNotes();
    notifyListeners();
  }

/************************************************************************** */
  List<Map<String, dynamic>> notesData = [];
  bool searchOpened = false;
  List<Map<String, dynamic>> notesfiltered = [];
  void searchAboutUsers({required String searchbar}) {
    if (searchbar.isNotEmpty) {
      notesfiltered = notesData
          .where((element) => element['title']
              .toString()
              .toLowerCase()
              .startsWith(searchbar.toLowerCase()))
          .toList();
    } else {
      notesfiltered.clear();
    }
    notifyListeners();
  }

  bool searchenabled = false;
  void changeSearchStatus() {
//so it will return all the list back
    if (searchenabled == false) notesfiltered.clear();
    searchenabled = !searchenabled;
    notifyListeners();
  }
}
