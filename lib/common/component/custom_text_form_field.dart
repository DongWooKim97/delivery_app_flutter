import 'package:actual/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;

  const CustomTextFormField({
    required this.onChanged,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );
    
    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureText,
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),
        fillColor: INPUT_BG_COLOR,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }
}

// 1. 텍스트필드 내부 패딩을 설정하기 위해서는 InputDecoration이라는 값을 넣어야함
//    외부에 설정하기 위해서는 해당 위젯 상단에 설정해줘야힘. Padding( ~~ , Widget ( ) )

// 2. hintText는 텍스트필드별로 따로 설정해줘야하는 부분이기 때문에 파라미터로 받아야함.

// 3. 텍스트필드 색 설정 ->fillColor, 이걸 적용시키기위해선 filled(value : bool) 를 true로

// 4. 텍스트필드 Border의 기본값은 underLineInputBorder, 우리가 원하는건 OutlineInputBorder. 따로 설정해줘야함
//    사용 파라미터 = borderSide, width. borderSid e는 테두리사이드!

// 5. border란 모든 Input상태의 기본 스타일 세팅.

// 6. 포커스(클릭했을 때) border는 어떻게? 말 그대로 focusedBorder라는 파라미터를 사용하면 된다.

// 7. obscureText 는 비밀번호를 작성할때만 사용. 동그라미로 대체

// 8. 화면에 텍스트필드가 들어왔을 때 바로 텍스트필드를 열거냐 안열거냐를 결정하는 것. autofocus

// 9. 선택되지 않는 상태에서 활성화되어있는 보더를 지정할 수 있다.

// 10. 전체 크기만큼만 우리가 위젯들을 채울 수가 있는데 , 이 위젯 크기를 넘어서 키보드가 올라와버림.
//    그래서 위젯 위를 덮어버리는거임. 이 화면의 크기를 늘려주면 된다. -> 스크롤이 가능하게 만들어버리면 됨.
//    login_screen에서 SafeArea의 상단 위젯에 SingleChildScrollView를 설정.

// 11. 키보드가 올라온 상태에서 scroll을 한다는 것 자체가 키보드를 안보고싶다는, 그만보고싶다는 UI/UX적인 의미가 있다. 이를 적용시키기 위해
//    keyboardDismissBehavior설정 -> SingleScrollChildView안에!!
//    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, -> enum값을 리턴하는데, enum값을 보면 manual / ★onDrag★
