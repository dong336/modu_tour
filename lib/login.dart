import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modu_tour/data/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  final String _databaseURL =
      'https://modu-tour-9d818-default-rtdb.firebaseio.com/';

  double opacity = 0;
  AnimationController? _animationController;
  Animation? _animation;
  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;

  @override
  void initState() {
    super.initState();

    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0, end: pi * 2).animate(_animationController!);
    _animationController!.repeat();

    Timer(const Duration(seconds: 2), () {
      setState(() {
        opacity = 1;
      });
    });

    reference =
        FirebaseDatabase.instance.refFromURL(_databaseURL).child('user');

    print(reference);
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  void makeDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController!,
                builder: (BuildContext context, Widget? child) {
                  return Transform.rotate(
                    angle: _animation!.value,
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.airplanemode_active,
                  color: Colors.deepOrangeAccent,
                  size: 80,
                ),
              ),
              const SizedBox(
                height: 100,
                child: Center(
                  child: Text('모두의 여행',
                      style: TextStyle(
                        fontSize: 30,
                      )),
                ),
              ),
              AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(seconds: 1),
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _idTextController,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          labelText: '아이디',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _pwTextController,
                        obscureText: true,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          labelText: '비밀번호',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/sign')
                          ,
                          child: const Text('회원가입'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (_idTextController!.value.text.isEmpty ||
                                _pwTextController!.value.text.isEmpty) {
                              makeDialog('빈칸이 있습니다');
                            } else {
                              reference!
                                  .child(_idTextController!.value.text)
                                  .onValue
                                  .listen((event) {
                                if (event.snapshot.value == null) {
                                  makeDialog('아이디가 없습니다');
                                } else {
                                  reference!
                                      .child(_idTextController!.value.text)
                                      .onChildAdded
                                      .listen((event) {
                                    User user =
                                    User.fromSnapshot(event.snapshot);
                                    var bytes = utf8
                                        .encode(_pwTextController!.value.text);
                                    var digest = sha1.convert(bytes);
                                    if (user.pw == digest.toString()) {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/main',
                                          arguments: _idTextController!.value.text);
                                    } else {
                                      makeDialog('비밀번호가 틀립니다');
                                    }
                                  });
                                }
                              });
                            }
                          },
                          child: const Text('로그인'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
