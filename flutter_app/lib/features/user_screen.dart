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

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        showErrorDialog(context, 'Could not open the link.');
      }
    } catch (e) {
      showErrorDialog(context, 'An error occurred: $e');
    }
  }

  Future<void> launchAppStoreForRating(BuildContext context) async {
    const String packageName = 'info.reviza.app';

    final String androidUrl = 'market://details?id=$packageName';
    final String iOSUrl = 'itms-apps://itunes.apple.com/app/id$packageName';

    await _launchUrl(context, androidUrl);
    await _launchUrl(context, iOSUrl);
  }

  void showAboutUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Us'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to ReviZa,\n\nReviZa facilitates seamless collaboration among students, '
                'enabling them to share study materials such as past papers and school notes. '
                'The app also features an AI chatbot for quick assistance with study-related questions.',
              ),
              SizedBox(height: 16),
              Text(
                'Thank you for downloading - Kanyanta M. (Founder ReviZa)',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => _launchUrl(context, 'https://reviza.info'),
              child: const Text('Visit Us 🌐'),
            ),
            TextButton(
              onPressed: () =>
                  _launchUrl(context, 'mailto:support@reviza.info'),
              child: const Text('Email Us 📧'),
            ),
            TextButton(
              onPressed: () =>
                  _launchUrl(context, 'https://wa.me/+260762878107/'),
              child: const Text('WhatsApp Us 📞'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Screen'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                return ListTile(
                  leading: const Icon(Icons.brightness_6),
                  title: const Text('Switch Theme'),
                  trailing: Switch(
                    value: state.theme == ReviZaTheme.light,
                    onChanged: (bool value) {
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
              onTap: () => _launchUrl(context, 'https://wa.me/+260762878107/'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate this App'),
              onTap: () => launchAppStoreForRating(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () => showAboutUsDialog(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Tell a Friend'),
              onTap: () {
                const String shareText =
                    'Download ReviZa:\nhttps://reviza.info';
                Share.share(shareText);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('App Version'),
              subtitle: FutureBuilder<String>(
                future: getAppVersion(),
                builder: (context, snapshot) {
                  return Text(snapshot.data ?? 'Loading...');
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                context.read<AppBloc>().add(const AppLogoutRequested());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
