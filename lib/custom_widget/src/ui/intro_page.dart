import 'package:flutter/material.dart';
import 'package:ohm_pad/custom_widget/src/model/page_view_model.dart';
import 'package:ohm_pad/custom_widget/src/ui/intro_content.dart';
import 'package:ohm_pad/utils/size_utils.dart';

extension ReversedList<T> on List<T> {
  List<T> asReversed(bool reverse) {
    return reverse ? this.reversed.toList() : this;
  }
}

class IntroPage extends StatefulWidget {
  final PageViewModel page;
  final ScrollController? scrollController;
  final bool isTopSafeArea;
  final bool isBottomSafeArea;

  const IntroPage({
    Key? key,
    required this.page,
    this.scrollController,
    required this.isTopSafeArea,
    required this.isBottomSafeArea,
  }) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget _buildStack() {
    final content = IntroContent(page: widget.page, isFullScreen: true);

    return Stack(
      alignment: Alignment.bottomCenter,
      // fit: StackFit.expand,
      children: [
        if (widget.page.image != null)
          Positioned.fill(child: widget.page.image!),
        Positioned.fill(
          child: Column(
            children: [
              ...[
                Spacer(flex: widget.page.decoration.imageFlex),
                Expanded(
                  flex: widget.page.decoration.bodyFlex,
                  child: widget.page.useScrollView
                      ? SingleChildScrollView(
                          controller: widget.scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: content,
                        )
                      : content,
                ),
              ].asReversed(widget.page.reverse),
              SafeArea(top: false, child: const SizedBox(height: 60.0)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlex() {
    return Stack(
      children: [
        if (widget.page.image != null && !widget.page.decoration.isHowToUse)
          Positioned.fill(child: widget.page.image!, bottom: SizeUtils.get(30)),
        if (widget.page.image != null && !widget.page.decoration.isHowToUse)
          Positioned(
            left: SizeUtils.get(10),
            right: SizeUtils.get(10),
            bottom: SizeUtils.get(120),
            child: IntroContent(page: widget.page),
          ),
        if (widget.page.decoration.isHowToUse)
          Container(
            color: widget.page.decoration.pageColor,
            decoration: widget.page.decoration.boxDecoration,
            margin: EdgeInsets.only(bottom: 100.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (widget.page.image != null)
                    Expanded(
                      child: Align(
                        alignment: widget.page.decoration.imageAlignment,
                        child: Padding(
                          padding: widget.page.decoration.imagePadding,
                          child: widget.page.decoration.isHowToUse
                              ? widget.page.image
                              : Container(),
                        ),
                      ),
                    ),
                  // Spacer(),
                  Align(
                    alignment: widget.page.decoration.bodyAlignment,
                    child: widget.page.useScrollView
                        ? SingleChildScrollView(
                            controller: widget.scrollController,
                            physics: const BouncingScrollPhysics(),
                            child: IntroContent(page: widget.page),
                          )
                        : IntroContent(page: widget.page),
                  ),
                  // Spacer(),
                  // Spacer(),
                ].asReversed(widget.page.reverse),
              ),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    if (widget.page.decoration.fullScreen) {
      return _buildStack();
    }
    return SafeArea(
      top: widget.isTopSafeArea,
      bottom: widget.isBottomSafeArea,
      child: _buildFlex(),
    );
  }
}
