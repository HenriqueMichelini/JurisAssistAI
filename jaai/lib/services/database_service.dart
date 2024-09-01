import 'package:jaai/models/message.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  //  making this class a singleton.
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _tableName = 'messages';

  DatabaseService._constructor();

  //  checks if the database is open, if not, it open it.
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  //  opens and create the database i'm going to use.
  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "messages_db.db");

    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_tableName (
          id INTEGER primary key autoincrement,
          message TEXT not null,
          isSentByMe INTEGER not null,
          date TEXT
        )
        ''');
      },
    );
    return database;
  }

  void insertMessage(String message, bool isSentByMe) async {
    final db = await database;
    int _isSentByMe = isSentByMe ? 1 : 0;
    String date = DateTime.now().toIso8601String();

    await db.insert(
      _tableName,
      {
        'message': message,
        'isSentByMe': _isSentByMe,
        'date': date,
      },
    );
  }

  Future<List<Message>> getMessages() async {
    final db = await database;
    final data = await db.query(_tableName);
    List<Message> messages = data
        .map(
          (e) => Message(
              id: e["id"] as int,
              message: e["message"] as String,
              isSentByMe: e["isSentByMe"] as int,
              timestamp: e["date"] as String),
        )
        .toList();
    return messages;
  }
}
