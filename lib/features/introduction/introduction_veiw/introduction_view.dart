import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lottie/lottie.dart';
import 'package:reviza/ui/home_screen/app_home.dart';
import 'package:reviza/features/introduction/introduction_bloc/bloc/introduction_bloc_bloc.dart';
import 'package:reviza/features/introduction/introduction_veiw/helpers/ColorsSys.dart';
import 'package:animate_do/animate_do.dart';
import 'package:reviza/features/introduction/introduction_veiw/helpers/Strings.dart';
import 'package:reviza/features/introduction/introduction_veiw/widgets/registerStudent.dart';
import 'package:reviza/widgets/no_data.dart';
import 'package:reviza/misc/course_info.dart';

class IntroductionView extends StatefulWidget {
  const IntroductionView({super.key, required this.studentId});

  final String studentId;

  @override
  State<IntroductionView> createState() => _IntroductionViewState();
}

class _IntroductionViewState extends State<IntroductionView> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    context
        .read<IntroductionBloc>()
        .add(CheckIntroductionStatus(studentId: widget.studentId));
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroductionBloc, IntroductionState>(
      builder: (context, state) {
        if (kDebugMode) {
          print(state);
        }
        if (state is IntroductionNotIntroduced) {
          return _introductionView();
        }
        if (state is IntroductionCheckingStatus) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          );
        }
        if (state is IntroductionIntroduced) {
          return MyHomePage(uid: widget.studentId);
        }
        if (state is IntroductionErrorState) {
          NoDataCuate(issue: state.message);
        }
        return Container();
      },
    );
  }

  Scaffold _introductionView() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                currentIndex = 3;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20, top: 20),
              child: Text(
                'Skip',
                style: TextStyle(
                    color: ColorSys.gray,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: <Widget>[
              _makePage(
                image: 'assets/images/intro/fatimah.jpg',
                title: Strings.stepOneTitle,
                content: Strings.stepOneContent,
              ),
              _makePage(
                reverse: true,
                image: 'assets/images/intro/sharing ideas.jpg',
                title: Strings.stepTwoTitle,
                content: Strings.stepTwoContent,
              ),
              _makePage(
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
          Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndicator(),
            ),
          )
        ],
      ),
    );
  }

  Widget _makePage({
    image,
    title,
    content,
    reverse = false,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !reverse
              ? Column(
                  children: <Widget>[
                    FadeInUp(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(image),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                )
              : const SizedBox(),
          FadeInUp(
              duration: const Duration(milliseconds: 900),
              child: Text(
                title,
                style: TextStyle(
                    color: ColorSys.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
          const SizedBox(
            height: 20,
          ),
          FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorSys.gray,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              )),
          reverse
              ? Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(image),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: ColorSys.secoundry, borderRadius: BorderRadius.circular(5)),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 4; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}
