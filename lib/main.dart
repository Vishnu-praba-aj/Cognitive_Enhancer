import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'main1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Type Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserTypeSelectionPage(),
    );
  }
}

class UserTypeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cognitive Enhancer'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img.png', // Replace this with your image path
                height: 150, // Adjust the height of the image as needed
              ),
              SizedBox(height: 20),
              Text(
                'Select your user type:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Login/Signup page for doctors
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorLoginSignupPage()),
                  );
                },
                child: Text('Doctor'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Login/Signup page for parents
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParentLoginSignupPage()),
                  );
                },
                child: Text('Parent'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DBHelper {
  static Database? _database;

  static Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  static Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'cognitive_enhancer.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY,
          username TEXT,
          password TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS game_data (
          id INTEGER PRIMARY KEY,
          parent_id INTEGER,
          game_name TEXT,
          points INTEGER,
          played_date TEXT
        )
      ''');
    });
  }

  static Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    try {
      await db!.insert('users', user);
      print('User inserted successfully');
      // Navigate to successful signup page or dashboard (replace with your logic)
    } catch (e) {
      print('Error inserting user: $e');
    }
  }

  static Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db!.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<void> insertGameData(Map<String, dynamic> gameData) async {
    final db = await database;
    await db!.insert('game_data', gameData);
  }

  static Future<List<Map<String, dynamic>>> getGameData(int parentId) async {
    final db = await database;
    return await db!.query('game_data', where: 'parent_id = ?', whereArgs: [parentId]);
  }
}

class DoctorLoginSignupPage extends StatelessWidget {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Login/Signup'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String username = _usernameController.text;
                  String password = _passwordController.text;

                  // Perform login validation (*replace with your login logic*)
                  // For now, assuming successful login
                  // You can implement your login validation here

                  // Navigate to Doctor Dashboard or Login Error Page (replace with your logic)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp1()), // Redirect to MyApp1
                  );
                },
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  String username = _usernameController.text;
                  String password = _passwordController.text;

                  // Insert user into the database
                  await DBHelper.insertUser({'username': username, 'password': password});

                  // After successful signup, redirect to MyApp1
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp1()), // Redirect to MyApp1
                  );
                },
                child: Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParentLoginSignupPage extends StatelessWidget {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Login/Signup'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String username = _usernameController.text;
                  String password = _passwordController.text;

                  // Perform login validation (*replace with your login logic*)
                  // For now, assuming successful login
                  // You can implement your login validation here

                  // Navigate to Parent Dashboard or Login Error Page (replace with your logic)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp1()), // Redirect to MyApp1
                  );
                },
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  String username = _usernameController.text;
                  String password = _passwordController.text;

                  // Insert user into the database
                  await DBHelper.insertUser({'username': username, 'password': password});

                  // After successful signup, redirect to MyApp1
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp1()), // Redirect to MyApp1
                  );
                },
                child: Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DoctorDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to Doctor Dashboard!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement any functionality for the doctor dashboard
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}


class ParentDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to Parent Dashboard!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement any functionality for the parent dashboard
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}


//main.dart