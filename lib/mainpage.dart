import 'package:figure_flutter/browse.dart';
import 'package:figure_flutter/main.dart';
import 'package:figure_flutter/upload.dart';
import 'package:flutter/material.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<StatefulWidget> createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        Container(
          alignment: Alignment.center,
          child: const BrowsePage(),
        ),
        Container(
          alignment: Alignment.center,
          child: BrowsePage(profileId: sessionProfile.id),
        ),
        const UploadWidget()
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) => setState(() => {
              if (index != 3)
                {currentPageIndex = index}
              else
                {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return (AlertDialog(
                            title: const Text('Logout'),
                            content: const Text('Are you sure you want to logout?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context, 'Logout');
                                    await localStorage.clear();
                                    sessionToken = "";
                                    setState(() {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const MyApp()),
                                            (route) => false,
                                      );
                                    });
                                  },
                                  child: const Text('Logout'))
                            ]));
                      })
                }
            }),
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Browse'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.upload), label: 'Upload'),
          NavigationDestination(icon: Icon(Icons.logout), label: 'Logout'),
        ],
      ),
    );
  }
}
