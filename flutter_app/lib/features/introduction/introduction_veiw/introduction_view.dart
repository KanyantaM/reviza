import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reviza/ui/home_screen/app_home.dart';
import 'package:reviza/features/introduction/introduction_bloc/bloc/introduction_bloc_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:reviza/features/introduction/introduction_veiw/helpers/const_strings.dart';
import 'package:reviza/features/introduction/introduction_veiw/widgets/register_student.dart';
import 'package:reviza/widgets/no_data.dart';
import 'package:study_material_repository/study_material_repository.dart';

class IntroductionView extends StatefulWidget {
  const IntroductionView({super.key, required this.studentId});

  final String studentId;

  @override
  State<IntroductionView> createState() => _IntroductionViewState();
}

class _IntroductionViewState extends State<IntroductionView> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IntroductionBloc, IntroductionState>(
      listener: (context, state) {
        while (state is IntroductionInitial) {
          context
              .read<IntroductionBloc>()
              .add(CheckIntroductionStatus(studentId: widget.studentId));
        }
      },
      builder: (context, state) {
        if (state is IntroductionCheckingStatus) {
          return _buildLoadingState(context);
        } else if (state is IntroductionIntroduced) {
          return MyHomePage(uid: widget.studentId);
        } else if (state is IntroductionErrorState) {
          return NoDataCuate(issue: state.message);
        } else if (state is IntroductionNotIntroduced) {
          // Skip introduction screen for non-mobile platforms
          if (!Platform.isAndroid && !Platform.isIOS) {
            return CourseSelectionWidget(
              data: data,
              studentId: widget.studentId,
            );
          }
          return _introductionView(context);
        }
        context
            .read<IntroductionBloc>()
            .add(CheckIntroductionStatus(studentId: widget.studentId));
        return Scaffold(
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Scaffold _introductionView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(currentIndex != 3 ? "Welcome" : 'Select Your Courses'),
        actions: [if (currentIndex != 3) _buildSkipButton()],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (page) => setState(() => currentIndex = page),
            children: [
              _buildIntroPage(
                context,
                image: 'assets/images/intro/fatimah.jpg',
                title: Strings.stepOneTitle,
                content: Strings.stepOneContent,
              ),
              _buildIntroPage(
                context,
                image: 'assets/images/intro/sharing ideas.jpg',
                title: Strings.stepTwoTitle,
                content: Strings.stepTwoContent,
                reverse: true,
              ),
              _buildIntroPage(
                context,
                image: 'assets/images/intro/graduate.jpg',
                title: Strings.stepThreeTitle,
                content: Strings.stepThreeContent,
              ),
              CourseSelectionWidget(
                data: data,
                studentId: widget.studentId,
              ),
            ],
          ),
          if (currentIndex != 3) _buildPageIndicator(context),
        ],
      ),
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          currentIndex = 3;
          _pageController
              .jumpToPage(3); // Ensure PageView navigates to the last page
        });
      },
      child: const Text(
        'Skip',
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildIntroPage(
    BuildContext context, {
    required String image,
    required String title,
    required String content,
    bool reverse = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!reverse) _buildImage(image),
          _buildTitleText(title, context),
          const SizedBox(height: 20),
          _buildContentText(content),
          if (reverse) _buildImage(image),
        ],
      ),
    );
  }

  Widget _buildImage(String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FadeInUp(child: Image.asset(image)),
    );
  }

  Widget _buildTitleText(String title, BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 900),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContentText(String content) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1200),
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    return Positioned(
      bottom: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (index) => _buildIndicator(context, isActive: currentIndex == index),
        ),
      ),
    );
  }

  Widget _buildIndicator(
    BuildContext context, {
    required bool isActive,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
