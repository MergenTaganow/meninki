import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../core/helpers.dart';

class Sizes {
  Sizes();
  double dpWidth(BuildContext context) => //for tablet
      MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width;

  double? btnWidth(double width) => //for tablet
      width < 400 ? width - 32 : 400;
}

class CustomSnackBar {
  static void showSnackBar({
    required BuildContext context,
    required String title,
    bool isError = false,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    double dpWidth = Sizes().dpWidth(context);
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: isError ? Col.redTask : Col.greenTask,
          duration: duration,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(dpWidth * 0.02)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          showCloseIcon: true,
          closeIconColor: Col.white,
          elevation: dpWidth * 0.01,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          content: Row(
            children: [
              Svvg.asset(
                isError ? 'danger' : 'active',
                h: dpWidth * 0.05,
                w: dpWidth * 0.05,
                color: Colors.white,
              ),
              Box(w: dpWidth * 0.03),
              Expanded(
                child: Text(
                  title,
                  maxLines: 5,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // log('Failed to show Snackbar with title:$title');
    }
  }

  static void showYellowSnackBar({
    required BuildContext context,
    required String title,
    Duration duration = const Duration(milliseconds: 4000),
  }) {
    double dpWidth = Sizes().dpWidth(context);
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Col.primYellow,
          duration: duration,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(dpWidth * 0.02)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 70, horizontal: 15),
          showCloseIcon: true,
          closeIconColor: Col.white,
          elevation: dpWidth * 0.01,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          content: Row(
            children: [
              Svvg.asset('danger', h: dpWidth * 0.05, w: dpWidth * 0.05, color: Col.white),
              Box(w: dpWidth * 0.03),
              Flexible(
                child: Text(
                  title,
                  maxLines: 5,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // log('Failed to show Snackbar with title:$title');
    }
  }

  static newDesignSnackBar({
    required BuildContext context,
    required String title,
    required bool isError,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    double dpWidth = Sizes().dpWidth(context);
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          duration: duration,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dpWidth * 0.02),
            side: BorderSide(
              color: isError ? const Color(0xFFD32F2F) : const Color(0xFF1E4620),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
          showCloseIcon: true,
          closeIconColor: Col.white,
          elevation: dpWidth * 0.01,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.antiAlias,
          content: Row(
            children: [
              Svvg.asset(isError ? 'dangerNew' : 'success', h: dpWidth * 0.05, w: dpWidth * 0.05),
              Box(w: dpWidth * 0.03),
              Expanded(
                child: Text(
                  title,
                  maxLines: 5,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isError ? const Color(0xFF5F2120) : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // log('Failed to show Snackbar with title:$title');
    }
  }

  static void showTopSnackBar({
    required BuildContext context,
    required String title,
    bool isError = false,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    double dpWidth = Sizes().dpWidth(context);
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder:
          (context) => _TopSnackBarWidget(
            title: title,
            isError: isError,
            dpWidth: dpWidth,
            duration: duration,
            onDismiss: () => entry.remove(),
          ),
    );

    overlay.insert(entry);
  }

  static void showCopiedSnackBar(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _CopiedToastWidget(
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
}

class _TopSnackBarWidget extends StatefulWidget {
  final String title;
  final bool isError;
  final double dpWidth;
  final Duration duration;
  final VoidCallback onDismiss;

  const _TopSnackBarWidget({
    required this.title,
    required this.isError,
    required this.dpWidth,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_TopSnackBarWidget> createState() => _TopSnackBarWidgetState();
}

class _TopSnackBarWidgetState extends State<_TopSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1), // starts above screen
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Auto-dismiss after duration
    Future.delayed(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).viewPadding.top;

    return Positioned(
      top: topPadding + 12,
      left: 15,
      right: 15,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: _dismiss, // tap to close
              onVerticalDragEnd: (d) {
                if (d.primaryVelocity != null && d.primaryVelocity! < 0) {
                  _dismiss(); // swipe up to close
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: widget.isError ? Col.redTask : Col.greenTask,
                  borderRadius: BorderRadius.circular(widget.dpWidth * 0.02),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: widget.dpWidth * 0.01,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Svvg.asset(
                      widget.isError ? 'danger' : 'active',
                      h: widget.dpWidth * 0.05,
                      w: widget.dpWidth * 0.05,
                      color: Colors.white,
                    ),
                    Box(w: widget.dpWidth * 0.03),
                    Expanded(
                      child: Text(
                        widget.title,
                        maxLines: 5,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.left,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Icon(Icons.close, color: Col.white, size: widget.dpWidth * 0.05),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CopiedToastWidget extends StatefulWidget {
  final VoidCallback onDismiss;

  const _CopiedToastWidget({required this.onDismiss});

  @override
  State<_CopiedToastWidget> createState() => _CopiedToastWidgetState();
}

class _CopiedToastWidgetState extends State<_CopiedToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 200),
    );

    _scaleAnim = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    Future.delayed(const Duration(milliseconds: 1200), _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      // floats above keyboard if open, otherwise sits at ~40% height
      bottom: bottomPadding > 0
          ? bottomPadding + 16
          : screenHeight * 0.12,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  // dark pill — visible on any background
                  color: Colors.black.withOpacity(0.78),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.linkCopied,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
