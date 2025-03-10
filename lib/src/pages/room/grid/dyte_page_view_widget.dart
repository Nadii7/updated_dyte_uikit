import 'package:dyte_uikit/src/pages/room/grid/dyte_tab_viewer_widget.dart';
import 'package:dyte_uikit/src/widgets/molecules/page_indicator.dart';
import 'package:flutter/material.dart';

import 'active_particpants_widget.dart';

class DytePageViewWidget extends StatefulWidget {
  const DytePageViewWidget({super.key});

  @override
  State<DytePageViewWidget> createState() => _DytePageViewWidgetState();
}

class _DytePageViewWidgetState extends State<DytePageViewWidget> {
  final pageController = PageController();

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: pageController,
          onPageChanged: (value) {
            setState(() {
              _currentPage = value;
            });
          },
          children: const [
            DyteTabViewerWidget(),
            ActiveParticipantsWidget(),
          ],
        ),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Center(
            child: PageIndicator(
              currentPage: _currentPage,
              pageCount: 2,
            ),
          ),
        )
      ],
    );
  }
}
