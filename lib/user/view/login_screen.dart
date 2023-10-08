import 'dart:convert';
import 'dart:io';

import 'package:actual/common/component/custom_text_form_field.dart';
import 'package:actual/common/const/colors.dart';
import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final storage = FlutterSecureStorage();
    final dio = Dio();
    // localhost: :  Android / IOS
    const emulatorIp = '10.0.2.2:3000';
    const simulatorIp = '127.0.0.1:3000';

    final ip = Platform.isAndroid ? emulatorIp : simulatorIp;

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(height: 16.0),
                _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  height: MediaQuery.of(context).size.height / 5 * 2,
                ),
                CustomTextFormField(
                  onChanged: (String value) {
                    username = value;
                  },
                  hintText: '이메일을 입력해주세요.',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  onChanged: (String value) {
                    password = value;
                  },
                  hintText: '비밀번호를 입력해주세요.',
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final rawString = '$username:$password';

                    Codec<String, String> stringToBase64 = utf8.fuse(base64);
                    String token = stringToBase64.encode(rawString);

                    final resp = await dio.post(
                      'http://$ip/auth/login',
                      options: Options(
                        headers: {
                          'authorization': 'Basic $token',
                        },
                      ),
                    );

                    final refreshToken = resp.data['refreshToken'];
                    final accessToken = resp.data['accessToken'];

                    // flutter_secure_storage에 key & value 저장
                    await storage.write(
                        key: REFRESH_TOKEN_KEY, value: refreshToken);
                    await storage.write(
                        key: ACCESS_TOKEN_KEY, value: accessToken);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RootTab(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: PRIMARY_COLOR,
                  ),
                  child: Text('로그인'),
                ),
                TextButton(
                  onPressed: () async {
                    String refreshToken =
                        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTY5NjU4MTkxNywiZXhwIjoxNjk2NjY4MzE3fQ.Zc7GL8BmNX3xLvZDsXuLD9N8jFwAou402vigQzoGutg';

                    final resp = await dio.post(
                      'http://$ip/auth/token',
                      options: Options(
                        headers: {
                          'authorization': 'Bearer $refreshToken',
                        },
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16.0,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}

// 12. 우리가 IOS시뮬레이터를 쓸 때는 , 시뮬레이터와 컴퓨터의 네트워크가 같다.
//    그러나 안드로이드 에뮬레이터를 쓰시는 경우에는 네트워크가 다르게 설정되어있다.

// 13. 애뮬레이터, 시뮬레이터 적재적소에 쓰기 위해선 Platform.is~~~를 통해 확인할 수 있다.

// 14. utf8은 전세계적으로 가장 많이 사용하고 있는 흔한 코덱

// 15. Codec<String, String> -> 어떤 값을 어떤 값으로 변환할건지 정의하고 있다.
//    일반 스트링을 Base64로 바꿀 수 있는 한 줄의 코드!
//    Codec<String, String> stringToBase64 = utf8.fuse(base64);

// 16. stringToBase64라는 변수에다가 우리가 어떻게 인코딩을 할건지 정리를 하고,
//      정의를 갖고서 String token = stringToBase64.encode(rawString); 를 통해 인코딩한다. rawString값을!@!

// 17. 복습하자. initState()는 await할 수가 없다.
