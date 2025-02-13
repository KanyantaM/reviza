import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/app/bloc/app_bloc.dart';
import 'package:reviza/features/login/login.dart';
import 'package:reviza/ui/theme.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchAppStoreForRating(BuildContext context) async {
    const String packageName = 'info.reviza.app';

    final String androidUrl = 'market://details?id=$packageName';
    final String iOSUrl = 'itms-apps://itunes.apple.com/app/id$packageName';
    if (Platform.isIOS) {
      _launchURL(iOSUrl);
    } else {
      _launchURL(androidUrl);
    }
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
            TextButton.icon(
                onPressed: () => _launchURL('https://reviza.info'),
                label: Icon(CupertinoIcons.compass))
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
                      context.read<AppBloc>().add(ChangeTheme(
                          theme: value ? ReviZaTheme.light : ReviZaTheme.dark));
                    },
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () => _showContactOptions(context),
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
                    'Download ReviZa:\nhttps://reviza.info/download';
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

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Feedback'),
                onTap: () => _launchURL('https://wa.me/+260761951544/'),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email Us 📧'),
                onTap: () => _launchURL('mailto:support@reviza.info'),
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('WhatsApp Us 📞'),
                onTap: () => _launchURL('https://wa.me/+260761951544/'),
              ),
              const Divider(),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }
}
