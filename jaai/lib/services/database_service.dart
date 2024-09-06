import 'package:jaai/models/message.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // Singleton pattern
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  final String _tableName = 'messages';

  DatabaseService._constructor();

  // Open the database if not already opened
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  // Initialize and create the database
  Future<Database> _initDatabase() async {
    try {
      final databaseDirPath = await getDatabasesPath();
      final databasePath = join(databaseDirPath, "messages_db.db");

      final database = await openDatabase(
        databasePath,
        version: 1,
        onCreate: (db, version) {
          db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            message TEXT NOT NULL,
            isSentByMe INTEGER NOT NULL,
            date TEXT
          )
          ''');
        },
      );
      return database;
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  // Insert a message into the database
  Future<void> insertMessage(String message, bool isSentByMe) async {
    try {
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
        conflictAlgorithm: ConflictAlgorithm.replace, // Handles duplicates
      );
    } catch (e) {
      print("Error inserting message: $e");
    }
  }

  // Retrieve messages from the database as a list
  Future<List<Message>> getMessages() async {
    try {
      final db = await database;
      final data = await db.query(_tableName);
      return data.map((e) {
        return Message(
          id: e['id'] as int,
          message: e['message'] as String,
          isSentByMe: e['isSentByMe'] as int,
          timestamp: e['date'] as String,
        );
      }).toList();
    } catch (e) {
      print("Error retrieving messages: $e");
      return [];
    }
  }

  // Retrieve messages as a stream for real-time updates
  Stream<List<Message>> getMessagesStream() async* {
    final db = await database;
    try {
      while (true) {
        final data = await db.query(_tableName);
        yield data.map((e) {
          return Message(
            id: e['id'] as int,
            message: e['message'] as String,
            isSentByMe: e['isSentByMe'] as int,
            timestamp: e['date'] as String,
          );
        }).toList();
        await Future.delayed(
            const Duration(seconds: 1)); // Polling every 1 second
      }
    } catch (e) {
      print("Error streaming messages: $e");
    }
  }

  // Batch insert messages for better performance
  Future<void> insertMessagesBatch(List<Message> messages) async {
    final db = await database;
    Batch batch = db.batch();

    for (var message in messages) {
      batch.insert(
        _tableName,
        {
          'message': message.message,
          'isSentByMe': message.isSentByMe,
          'date': message.timestamp,
        },
      );
    }

    await batch.commit(noResult: true);
  }
}
