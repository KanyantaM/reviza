// import 'package:flutter/material.dart';

// class StepsScreen extends StatefulWidget {
//   const StepsScreen({super.key});

//   @override
//   State<StepsScreen> createState() => _StepsScreenState();
// }

// class _StepsScreenState extends State<StepsScreen> {
//   int currentStep = 0;
//   TextEditingController issueController = TextEditingController();
//   TextEditingController reviewController = TextEditingController();
//   String screenshotPath = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Report an Issue'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: Stepper(
//                 type: StepperType.vertical,
//                 currentStep: currentStep,
//                 onStepContinue: () {
//                   setState(() {
//                     if (currentStep < 2) {
//                       currentStep += 1;
//                     } else {
//                       // Implement send logic
//                       print('Issue: ${issueController.text}');
//                       print('Screenshot Path: $screenshotPath');
//                       print('Review: ${reviewController.text}');
//                       // Reset the form after sending
//                       issueController.clear();
//                       reviewController.clear();
//                       screenshotPath = '';
//                       currentStep = 0;
//                     }
//                   });
//                 },
//                 onStepCancel: () {
//                   setState(() {
//                     if (currentStep > 0) {
//                       currentStep -= 1;
//                     }
//                   });
//                 },
//                 steps: [
//                   Step(
//                     title: const Text('Enter Issue'),
//                     content: Column(
//                       children: [
//                         TextFormField(
//                           controller: issueController,
//                           decoration: const InputDecoration(labelText: 'Describe the Issue'),
//                           maxLines: 3,
//                         ),
//                       ],
//                     ),
//                     isActive: currentStep == 0,
//                   ),
//                   Step(
//                     title: const Text('Add Screenshot'),
//                     content: Column(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             // Implement screenshot logic
//                             // For simplicity, I'm just using a placeholder path
//                             setState(() {
//                               screenshotPath = '/path/to/screenshot.png';
//                             });
//                           },
//                           child: const Text('Add Screenshot'),
//                         ),
//                         if (screenshotPath.isNotEmpty)
//                           Image.network(
//                             screenshotPath,
//                             height: 100,
//                           ), // Display the selected screenshot
//                       ],
//                     ),
//                     isActive: currentStep == 1,
//                   ),
//                   Step(
//                     title: const Text('Extra Details'),
//                     content: Column(
//                       children: [
//                         TextFormField(
//                           controller: reviewController,
//                           decoration: const InputDecoration(labelText: 'Details'),
//                           maxLines: 3,
//                         ),
//                       ],
//                     ),
//                     isActive: currentStep == 2,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentStep,
//         onTap: (index) {
//           setState(() {
//             currentStep = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.description),
//             label: 'Issue',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.camera_alt),
//             label: 'Screenshot',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.rate_review),
//             label: 'Review',
//           ),
//         ],
//       ),
//     );
//   }
// }