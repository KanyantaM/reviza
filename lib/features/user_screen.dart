import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/app/bloc/app_bloc.dart';
import 'package:reviza/features/login/login.dart';
import 'package:reviza/features/report.dart';
import 'package:reviza/ui/theme.dart';
import 'package:reviza/utilities/dialogues/comming_soon.dart';
import 'package:url_launcher/url_launcher.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  Future<void> launchAppStoreForRating() async {
    const String packageName =
        'your_app_package_name'; // Replace with your app's package name

    // For Android
    final String androidUrl = 'market://details?id=$packageName';

    // For iOS
    final String iOSUrl = 'itms-apps://itunes.apple.com/app/id$packageName';

    if (await canLaunch(androidUrl)) {
      await launch(androidUrl);
    } else if (await canLaunch(iOSUrl)) {
      await launch(iOSUrl);
    } else {
      // Handle the case where neither the Android nor iOS URL can be launched
      print('Could not launch the app store on both Android and iOS');
    }
  }

  void showAboutUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Us'),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'ReviZa - A Study Sharing App, developed by the Luso Software Team'),
              SizedBox(height: 16),
              Text('Luso Software - A Zambian Software Development Company'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                launch('https://www.lusosoftware.com');
              },
              child: const Text('Visit Us'),
            ),
            TextButton(
              onPressed: () {
                launch('mailto:team@lusosoftware.com');
              },
              child: const Text('Email Us'),
            ),
            TextButton(
              onPressed: () {
                const phoneNumber = '0761951544';
                launch('https://wa.me/$phoneNumber/');
              },
              child: const Text('WhatsApp Us'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                return ListTile(
                  leading: const Icon(Icons.brightness_6),
                  title: const Text('Switch Theme'),
                  trailing: Switch(
                    value: state.theme ==
                        ReviZaTheme
                            .light, // Replace with actual theme switch logic
                    onChanged: (bool value) {
                      // Dispatch a ChangeTheme event to trigger the theme switch logic
                      context.read<AppBloc>().add(ChangeTheme());
                    },
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () async {
                // sendWhatsAppMessage();
                // Navigate to feedback screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StepsScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate this App'),
              onTap: () {
                // Open app store for rating
                launchAppStoreForRating();
                // commingSoon(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                showAboutUsDialog(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Tell a Friend'),
              onTap: () {
                // Implement tell a friend logic, should be able to let the app be shared on various social media platforms
                //TODO
                commingSoon(context);
              },
            ),
            const Divider(),
            // ListTile(
            //   leading: const Icon(Icons.code),
            //   title: const Text('Check us out on Github'),
            //   onTap: () {},
            // ),
            // const Divider(),
            // ListTile(
            //   leading: const Icon(Icons.chat),
            //   title: const Text('Join us on WhatsApp'),
            //   onTap: () {
            //     // Implement WhatsApp join logic to let one join business whatsapp group
            //   },
            // ),
            // const Divider(),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('App Version'),
              subtitle: Text('1.0.0'), // Replace with actual app version
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                context.read<AppBloc>().add(const AppLogoutRequested());
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
