import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mechanic/user/chat_screen.dart';
import 'package:mechanic/user/user_home.dart';
import 'package:mechanic/user/user_profile.dart';
import 'package:mechanic/widgets/const.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ScrollController scrollcontroller = ScrollController();
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    scrollcontroller = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  double bottom = 30;

  void _scrollListener() {
    if (scrollcontroller.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (bottom != -100)
        setState(() {
          bottom = -100;
        });
    }
    if (scrollcontroller.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (bottom == -100)
        setState(() {
          bottom = 30;
        });
    }
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    scrollcontroller.removeListener(_scrollListener);
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              UserHomeScreen(
                scrollcontroller: scrollcontroller,
              ),
              UserProfileScreen(
                scrollcontroller: scrollcontroller,
              ),
            ],
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            bottom: bottom,
            left: 30,
            right: 30,
            child: Container(
              decoration: BoxDecoration(
                color: pagesBackgroundColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 1,
                    blurRadius: 20,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 5),
              child: TabBar(
                labelColor: appThemeColor,
                indicatorColor: Colors.transparent,
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: Image(
                      image: AssetImage(
                        'assets/images/home.png',
                      ),
                      width: 20,
                      color: _tabController.index == 0
                          ? appThemeColor
                          : Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Image(
                      image: AssetImage(
                        'assets/images/user.png',
                      ),
                      width: 20,
                      color: _tabController.index == 2
                          ? appThemeColor
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
