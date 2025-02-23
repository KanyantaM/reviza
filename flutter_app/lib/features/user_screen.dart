import 'dart:io';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/app/bloc/app_bloc.dart';
import 'package:reviza/cache/student_cache.dart';
import 'package:reviza/features/login/login.dart';
import 'package:reviza/features/upload_pdf/uplead_pdf_bloc/upload_pdf_bloc.dart';
import 'package:reviza/features/view_subjects/view_subjects_bloc/view_material_bloc.dart';
import 'package:reviza/utilities/dialogues/comming_soon.dart';
// import 'package:share_plus/share_plus.dart';
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

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  context.read<AppBloc>().add(const AppLogoutRequested());
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                icon: Icon(Icons.logout)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            UserStatsCard(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () => _showContactOptions(context),
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
                leading: const Icon(Icons.web),
                title: const Text('Feedback'),
                onTap: () => _launchURL('https://reviza.info/'),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email Us'),
                onTap: () => _launchURL('mailto:support@reviza.info'),
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('WhatsApp Us'),
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

class UserStatsCard extends StatelessWidget {
  const UserStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth > 800;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                maxWidth: 800), // Limits width on large screens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard("Total Activity", [
                  _buildStatRow([
                    BlocBuilder<UploadPdfBloc, UploadPdfState>(
                      builder: (context, state) {
                        return _buildStatItem(Icons.upload, "Uploads",
                            StudentCache.tempStudent.uploadCount.toString());
                      },
                    ),
                    BlocBuilder<ViewMaterialBloc, ViewMaterialState>(
                      builder: (context, state) {
                        return _buildStatItem(Icons.download, "Downloads",
                            StudentCache.tempStudent.downloadCount.toString());
                      },
                    ),
                  ], isWideScreen),
                ]),
                const SizedBox(height: 12),
                _buildCard("Subscription", [
                  _buildStatRow([
                    _buildStatItem(Icons.account_balance_wallet, "Account Type",
                        "Premium"),
                    BlocBuilder<ViewMaterialBloc, ViewMaterialState>(
                      builder: (context, state) {
                        return _buildStatItem(Icons.calendar_month, "Month",
                            "${StudentCache.tempStudent.downloadCount} / ∞");
                      },
                    ),
                  ], isWideScreen),
                  const SizedBox(height: 8),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        commingSoon(context);
                      },
                      icon: const Icon(Icons.shopping_cart,
                          color: Colors.blueAccent),
                      label: const Text("Get More Downloads"),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: const Text(
                      "Earn a free download by uploading material!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                _buildBottomRow(isWideScreen),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(List<Widget> children, bool isWideScreen) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center, // Centers on large screens
      children: children
          .map((e) =>
              SizedBox(width: isWideScreen ? 350 : double.infinity, child: e))
          .toList(),
    );
  }

  Widget _buildStatItem(IconData icon, String title, String value,
      {bool isWarning = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isWarning
            ? Colors.redAccent.withAlpha(100)
            : Colors.green.withAlpha(100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow(bool isWideScreen) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(Icons.warning, "Bad Uploads",
              "${StudentCache.tempStudent.badUploadCount}/5",
              isWarning: true),
        ),
        const SizedBox(width: 16),
        BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return Row(
              children: [
                const Icon(Icons.brightness_6),
                const SizedBox(width: 8),
                const Text('Theme'),
                const SizedBox(width: 8),
                Switch(
                  value: state.theme,
                  onChanged: (bool value) {
                    context.read<AppBloc>().add(ChangeTheme(theme: value));
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
