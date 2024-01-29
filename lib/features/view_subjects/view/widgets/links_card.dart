import 'package:flutter/material.dart';

class ExpandingCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function(bool isOpen) onToggle;

  const ExpandingCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<ExpandingCard> createState() => _ExpandingCardState();
}

class _ExpandingCardState extends State<ExpandingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightFactorAnimation;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightFactorAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleCard() {
    setState(() {
      isOpen = !isOpen;
      isOpen ? _animationController.forward() : _animationController.reverse();
      widget.onToggle(isOpen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 350.0,
          height: isOpen ? 250.0 : 160.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5.0,
                blurRadius: 7.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: _toggleCard,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '🌐',
                        textScaleFactor: 3.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(
                              'Tap to see more',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: !isOpen ? Colors.grey : Colors.amberAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _heightFactorAnimation,
                      builder: (context, child) {
                        return ClipRect(
                          child: Align(
                            heightFactor: _heightFactorAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: ListView(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Description:\t',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                widget.subtitle,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Open Link'),
                          ),
                          const SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
