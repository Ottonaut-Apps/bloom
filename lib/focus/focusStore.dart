import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

class ABCStorage{

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    if(await File('$path/focus.txt').exists() == false){
      return await new File('$path/focus.txt').create(recursive: false);
    }

    return File('$path/focus.txt');
  }

  Future<String> readFile() async {
    String content;
    try {
      final file = await _localFile;

      content = await file.readAsString();
      return content;
    } catch (e) {
      print(e.toString());
      return "Error";
    }
  }

  Future<void> writeFile(String text) async {
    final file = await _localFile;

    // Write the file
    file.writeAsString("$text");
  }

  Future<void> writeFile2() async {
    final file = await _localFile;

    // Write the file
    file.delete();
  }

  Future<void> createLine(String id, String title, bool private) async {
    Line line = Line(id, title, private);

    String db = (await readFile()).toString();

    String newline = line.toString();

    if(db == ""){
      db += newline;
    } else{
      db += "\n" + newline;
    }
    await writeFile(db);
  }

  Future<void> createLineFromLine(Line line) async {
    String db = (await readFile()).toString();

    String newline = line.toString();

    if(db == "") {
      db += newline;
    }else{
      db += "\n" + newline;
    }


    await writeFile(db);
  }

  Future<Line> getLine(String id) async {
    String db = await readFile();
    List lines = db.split('\n');
    String string = "";

    for(int i = 0; i < lines.length; i++) {
      if(lines[i].toString().contains(id)){
        string = lines[i].toString();
        break;
      }
    }
    List elements = string.split(',');

    Line line = Line(elements[0], elements[1], elements[2] == "true");
    line = line.toLine(string);
    return line;
  }

  Future<void> updateLine(String id) async {
    Line line = await getLine(id);

    /*
    Ziel: Titel, privat oder Buchstaben zu updaten
    Titel & privat aus dem "Liste bearbeiten" Menü
    Benötigt: Line, neue Werte
     */
    await deleteLine(line.id);
    await createLineFromLine(line);
  }

  Future<void> deleteLine(String id) async {
    String db = await readFile();
    List lines = db.split('\n');
    String newDb = "";

    if(lines[0].toString().contains(id) == false){
      newDb += lines[0].toString();
    }
    for(int i = 1; i < lines.length; i++) {
      if(lines[i].toString().contains(id)){
      }else{
        if(newDb == "") {
          newDb += lines[i].toString();
        }else{
          newDb += "\n" + lines[i].toString();
        }
      }
    }

    await writeFile(newDb);
  }

/*
  function writeFile(String string): void

  function readFile(): Line[]

     file.readAsString -> String -> Line[]

     String -> String + \n + String + ...
     Vereinzelte Strings -> Line konverter
     "uuid,private,..." ---> s.split(',') --> Array<String>  res --> UUID id = res[0], private = res[1] ...
     Converted Strings -> Array --> return

     type Line {
     UUid id;
     boolean privqte;
     String a;
     ...
     }


  void createLine(Vars) async {
  var db = readFile()
  const line = Vars umgewandelt in valide Line
  db = db + "\n" + line
  writeFile(db)
 }

  function getLine(UUID id): Line[]

  function updateLine(Line[]): void

  function deleteLine(UUID id): void
   */
}

class Line {
  String id = "";
  String title = 'Beispiel';
  bool private = true;

  Line(String id, String title, bool private) {
    this.id = id;
    this.title = title;
    this.private = private;
  }

  /*
  function getUniqueId() {
    Hole DB -> Hole einzelne IDs
    Uuid uuid = new Uuid()

    String newId = erste bereits existierende Id
    while(newId == existierende Ids) {
      newId = uuid.v4()
    }

    return newId
  }

  String id = getUniqueId();

  var line = Line(id, ...)
   */

  Line.withABC(String id, String title, bool private){
  }

  void setTitle(String title) {
    this.title = title;
  }

  Line toLine(String string) {
    List<String> elements = string.split(',');

    return Line.withABC(
        elements[0], elements[1], elements[2].toLowerCase() == 'true',
    );
  }

  @override
  String toString() {
    return '$id,$title,$private';
  }
}