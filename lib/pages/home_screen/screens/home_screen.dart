import 'package:flutter/material.dart';
import 'package:jsps_depo/pages/home_screen/drawer/example_sidebar.dart';
import 'package:jsps_depo/pages/home_screen/screens/page_view_content.dart';
import 'package:jsps_depo/pages/home_screen/widgets/home_screen_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(250),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: AppBar(
            flexibleSpace: PageViewContent(),
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: HomeScreenIcons(),
      ),
    );
  }
}
