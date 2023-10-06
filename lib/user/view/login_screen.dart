import 'package:actual/common/component/custom_text_form_field.dart';
import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        top: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Title(),
            _SubTitle(),
            Image.asset(
              'asset/img/misc/logo.png',
              height: MediaQuery.of(context).size.height / 5 * 2,
            ),
            CustomTextFormField(
              onChanged: (String value) {},
              hintText: '이메일을 입력해주세요.',
            ),
            CustomTextFormField(
              onChanged: (String value) {},
              hintText: '비밀번호를 입력해주세요.',
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: PRIMARY_COLOR,
              ),
              child: Text('로그인'),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
              child: Text('회원가입'),
            ),
          ],
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
