import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/app/bloc/app_bloc.dart';
import 'package:reviza/features/login/login.dart';
import 'package:reviza/ui/theme.dart';
import 'package:reviza/utilities/dialogues/error_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  Future<void> launchAppStoreForRating(BuildContext context) async {
    const String packageName = '....';

    // For Android
    const String androidUrl = 'market://details?id=$packageName';

    // For iOS
    const String iOSUrl = 'itms-apps://itunes.apple.com/app/id$packageName';

    if (await canLaunchUrl(Uri(path: androidUrl))) {
      await launchUrl(Uri(path: androidUrl));
    } else if (await canLaunchUrl(Uri(path: iOSUrl))) {
      await launchUrl(Uri(path: iOSUrl));
    } else {
      // Handle the case where neither the Android nor iOS URL can be launched
      showErrorDialog(
          context, 'Could not launch the app store on both Android and iOS');
    }
  }

  void showAboutUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Us'),
          content: const Wrap(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Welcome to ReviZa,\n\nA powerful study app brought to you by Luso Software.\n\nReviZa is designed to facilitate seamless collaboration among students, enabling them to share study materials such as past papers and school notes. The app also features an AI chatbot for quick assistance with study-related questions.'),
              SizedBox(height: 16),
              Text(
                '\nLuso Software - A Zambian Software Development Company',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                launchUrl(Uri(path: 'https://www.lusosoftware.com'));
              },
              child: const Text('Visit Us 🌐'),
            ),
            TextButton(
              onPressed: () {
                launchUrl(Uri(path: 'mailto:team@lusosoftware.com'));
              },
              child: const Text('Email Us 📧'),
            ),
            TextButton(
              onPressed: () {
                const phoneNumber = '+260762878107';
                launchUrl(Uri(path: 'https://wa.me/$phoneNumber/'));
              },
              child: const Text('WhatsApp Us 💬'),
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
        centerTitle: true,
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
                const phoneNumber = '+260762878107';
                launchUrl(Uri(path: 'https://wa.me/$phoneNumber/'));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate this App'),
              onTap: () {
                // Open app store for rating
                launchAppStoreForRating(context);
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
                Share.share('hello');
                // commingSoon(context);
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
            ListTile(
              leading: Icon(Icons.info),
              title: Text('App Version'),
              subtitle: FutureBuilder(
                  future: getAppVersion(),
                  builder: (context, version) {
                    return Text(version.data ?? '...');
                  }), // Replace with actual app version
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

Future<String> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version; // e.g., "1.0.0"
}
