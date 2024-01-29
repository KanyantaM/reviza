import 'package:flutter/material.dart';
import 'package:reviza/features/report.dart';

class UserScreen extends StatelessWidget {
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
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User Name'),
              onTap: () {
                // Navigate to user profile or details screen
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Switch Theme'),
              trailing: Switch(
                value: true, // Replace with actual theme switch logic
                onChanged: (bool value) {
                  // Implement theme switch logic
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () {
                // Navigate to feedback screen
                Navigator.push(context, MaterialPageRoute(builder: (context)=> StepsScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Account Settings'),
              onTap: () {
                // Navigate to account settings screen
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate this App'),
              onTap: () {
                // Open app store for rating
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                // Navigate to about us screen
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Tell a Friend'),
              onTap: () {
                // Implement tell a friend logic
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Check us out on GitHub'),
              onTap: () {
                // Open GitHub page
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Join us on WhatsApp'),
              onTap: () {
                // Implement WhatsApp join logic
              },
            ),
            const Divider(),
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
                // Implement logout logic
              },
            ),
          ],
        ),
      ),
    );
  }
}