import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller; // 나중에 값을 선언할건데, 사용할 땐 선언이 되어있을거야!
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // children에 들어가는 리스트의 길이 , vsync - 컨트롤러를 선언하는 현재의 State를 넣어주면 딤
    // this가 특정 기술을 가지고 있어야함.
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코팩 딜리버리',
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        type: BottomNavigationBarType.shifting,
        onTap: (int index) {
          controller.animateTo(index); // animateTo -> 움직여라 index로!
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '프로필',
          ),
        ],
      ),
      child: TabBarView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(), // 좌우 스크롤 방지.
        children: [
          RestaurantScreen(),
          Center(child: Container(child: Text('음식'))),
          Center(child: Container(child: Text('주문'))),
          Center(child: Container(child: Text('프로필'))),
        ],
      ),
    );
  }
}

// vsync가 파라미터로 있는 함수 및 위젯을 사용할 땐 State뒤에 무조건 with SingleTickerProviderStateMixin을 붙여서 사용해야함.

// TabController를 현재 initState에서 하고있는데, 바로 선언하지 않고 initState에서 선언하기 때문에 late라는 타입을 사용해도 된다.
// late는 바로는 선언하지 않지만, 사용할 땐 선언되어있다고 장담하는 건데, 여기서 그냥 ?를 사용해서 쓰면
// controller를 사용할 때 마다 null-checking을 매번 해줘야해서 불편하다.

// TabBarView를 사용하는 목적은 앱의 하단부 Tabs(홈, 음식, 주문, 프로필)에 맞게끔 View를 설정하기 위함이다.

// 컨트롤러에서 우리가 값이 변경이 될 때 마다 특정 변수를 실행을 해라라고 하면된다.
