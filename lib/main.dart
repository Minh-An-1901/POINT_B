import 'package:flutter/material.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      home: NoteList(),
    );
  }
}

class Note {
  String title;
  String content;

  Note(this.title, this.content);
}

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  final List<Note> _notes = <Note>[];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Thêm tiêu đề của bạn ở đây
            SizedBox(height: 0.10), // Tạo một khoảng cách 20px
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm thông tin ghi chú ở đây',
              ),
              onChanged: (value) => setState(() {}),
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(height: 20.0), // Tạo một khoảng cách 20px từ phía trên
              ..._notes.map((note) {
                if (_searchController.text.isNotEmpty &&
                    !note.title.contains(_searchController.text)) {
                  return Container(); // Return an empty container for non-matching items
                }
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(note.title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetail(note: note),
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Note'),
                            content: Text('Are you sure you want to delete this note?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () {
                                  setState(() {
                                    _notes.remove(note);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              }).toList(),
              const Positioned(
                top: 0,
                bottom: 90,
                left: 80,
                right: 0,
                child: Center(
                  child: Text(
                    'ỨNG DỤNG \n GHI CHÚ',
                    style: TextStyle(
                      color: Colors.transparent,
                      fontSize: 50,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 0),
                          blurRadius: 7,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Note? newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteEditor()),
          );
          if (newNote != null) {
            setState(() {
              _notes.add(newNote);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NoteEditor extends StatefulWidget {
  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Note'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Title'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: InputDecoration(hintText: 'Content'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_titleController.text.isNotEmpty &&
              _contentController.text.isNotEmpty) {
            final Note newNote = Note(
              _titleController.text,
              _contentController.text,
            );
            Navigator.pop(context, newNote);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Title and content cannot be empty.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

class NoteDetail extends StatelessWidget {
  final Note note;

  NoteDetail({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(note.content),
      ),
    );
  }
}
