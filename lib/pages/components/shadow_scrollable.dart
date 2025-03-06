import 'package:flutter/material.dart';

class ShadowScrollable extends StatefulWidget {
  final ScrollController scrollController;
  final Color colorShadow;
  final double heightShadow;
  final Widget child;
  final Duration timeCreateShadow;
  const ShadowScrollable(
      {super.key,
      required this.scrollController,
      required this.colorShadow,
      required this.heightShadow,
      required this.child,
      this.timeCreateShadow = Duration.zero});

  @override
  State<ShadowScrollable> createState() => _ShadowScrollableState();
}

class _ShadowScrollableState extends State<ShadowScrollable> {
  bool _showTopShadow = false;
  bool _showBottomShadow = false;

  void _updateShadows() {
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;

    if (!mounted) return; // Ensure widget is still in the tree

    if (currentScroll > 0 && _showTopShadow == false) {
      setState(() {
        _showTopShadow = true;
      });
    } else if (currentScroll == 0 && _showTopShadow == true) {
      setState(() {
        _showTopShadow = false;
      });
    }

    if (currentScroll < maxScroll && _showBottomShadow == false) {
      setState(() {
        _showBottomShadow = true;
      });
    } else if (currentScroll == maxScroll && _showBottomShadow == true) {
      setState(() {
        _showBottomShadow = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Khởi tạo showBottomShadow.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Delayed vào để UI render ra đã. Do cái Dialog bên trang Edit. Vãi. Để v thôi chớ chắc làm cách khác.
      Future.delayed(widget.timeCreateShadow, () {
        setState(() {
          _showBottomShadow = widget.scrollController.offset <
              widget.scrollController.position.maxScrollExtent;
        });
      });
    });

    widget.scrollController.addListener(_updateShadows);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Scrollable Item
        widget.child,
        // 2 Shadow 2 đầu
        if (_showTopShadow)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.colorShadow,
                    widget.colorShadow.withOpacity(0)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

        if (_showBottomShadow)
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: Container(
              // Shadow dưới bottm heigt phải cộng thêm 1 và position phải lùi về 1. Vì Stack nó ước lượng sai vị trí. Đặt nhít lên trên một chút.
              height: widget.heightShadow + 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.colorShadow,
                    widget.colorShadow.withOpacity(0)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
