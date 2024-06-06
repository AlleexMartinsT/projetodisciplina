import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserStorage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    print('User file path: $path/users.json');
    return File('$path/users.json');
  }

  static Future<Map<String, String>> readUsers() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        return Map<String, String>.from(jsonDecode(contents));
      } else {
        return {};
      }
    } catch (e) {
      print('Error reading users: $e');
      return {};
    }
  }

  static Future<File> writeUsers(Map<String, String> users) async {
    final file = await _localFile;
    print('Writing users to file');
    return file.writeAsString(jsonEncode(users));
  }

  static Future<void> registerUser(String email, String password) async {
    final users = await readUsers();
    users[email] = password;
    await writeUsers(users);
  }

  static Future<bool> authenticateUser(String email, String password) async {
    final users = await readUsers();
    return users[email] == password;
  }
}
