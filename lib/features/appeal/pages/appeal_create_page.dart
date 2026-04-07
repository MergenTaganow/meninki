import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/data/dynamic_localization.dart';
import 'package:meninki/features/global/widgets/custom_snack_bar.dart';

import '../../../core/colors.dart';
import '../bloc/appeal_cubit/appeal_cubit.dart';

class AppealPage extends StatefulWidget {
  /// [type]  — one of AppealType constants
  /// [topic] — selected before navigating here
  const AppealPage({
    super.key,
    required this.type,
    required this.typeId,
    required this.typeName,
    required this.topic,
  });

  final String type;
  final String? typeName;
  final String typeId;
  final String topic;

  @override
  State<AppealPage> createState() => _AppealPageState();
}

class _AppealPageState extends State<AppealPage> {
  final TextEditingController _bodyCont = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _charCount = 0;
  static const int _maxChars = 500;

  @override
  void initState() {
    super.initState();
    _bodyCont.addListener(() {
      setState(() => _charCount = _bodyCont.text.length);
    });
  }

  @override
  void dispose() {
    _bodyCont.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_bodyCont.text.trim().isEmpty) return;
    HapticFeedback.mediumImpact();
    // TODO: wire up your cubit/bloc here
    context.read<AppealCubit>().doAppeal(
      type: widget.type,
      topic: widget.topic,
      body: _bodyCont.text.trim(),
      id: widget.typeId,
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case Appeal.reel:
        return Icons.play_circle_outline_rounded;
      case Appeal.product:
        return Icons.inventory_2_outlined;
      case Appeal.profile:
        return Icons.person_outline_rounded;
      case Appeal.market:
        return Icons.storefront_outlined;
      case Appeal.adds:
        return Icons.campaign_outlined;
      default:
        return Icons.flag_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lg = AppLocalizations.of(context)!;
    final bool canSubmit = _charCount > 0;

    return BlocListener<AppealCubit, AppealState>(
      listener: (context, state) {
        if (state is AppealSuccess) {
          CustomSnackBar.showSnackBar(context: context, title: "Appeal was send");
          Go.pop();
        }
        if (state is AppealFailed) {
          CustomSnackBar.showSnackBar(
            context: context,
            title: state.failure.message ?? lg.smthWentWrong,
            isError: true,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F5),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A1A), size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            lg.appeal, // add to l10n
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: _SubmitButton(
          enabled: canSubmit,
          onTap: () => _submit(context),
          lg: lg,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ── context card (type + topic) ────────────────────────────
                _ContextCard(
                  typeIcon: _typeIcon(widget.type),
                  typeLabel: widget.typeName ?? DynamicLocalization.translate(widget.type),
                  topicLabel: DynamicLocalization.translate(widget.topic),
                  lg: lg,
                ),

                const SizedBox(height: 16),

                // ── body input card ────────────────────────────────────────
                _BodyInputCard(
                  controller: _bodyCont,
                  focusNode: _focusNode,
                  charCount: _charCount,
                  maxChars: _maxChars,
                  lg: lg,
                ),

                const SizedBox(height: 110),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ContextCard  — shows what the appeal is about
// ─────────────────────────────────────────────────────────────────────────────

class _ContextCard extends StatelessWidget {
  const _ContextCard({
    required this.typeIcon,
    required this.typeLabel,
    required this.topicLabel,
    required this.lg,
  });

  final IconData typeIcon;
  final String typeLabel;
  final String topicLabel;
  final AppLocalizations lg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // type row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Col.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(typeIcon, color: Col.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lg.appealFor, // add to l10n e.g. "Appeal for"
                    style: const TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    typeLabel,
                    style: const TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: const Color(0xFFEEEEEE), height: 1, thickness: 1),
          ),

          // topic row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.label_outline_rounded, color: Color(0xFF888888), size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lg.appealTopic, // add to l10n e.g. "Topic"
                    style: const TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    topicLabel,
                    style: const TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _BodyInputCard  — text field + char counter
// ─────────────────────────────────────────────────────────────────────────────

class _BodyInputCard extends StatelessWidget {
  const _BodyInputCard({
    required this.controller,
    required this.focusNode,
    required this.charCount,
    required this.maxChars,
    required this.lg,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int charCount;
  final int maxChars;
  final AppLocalizations lg;

  @override
  Widget build(BuildContext context) {
    final bool nearLimit = charCount >= maxChars * 0.85;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lg.appealDescription, // add to l10n e.g. "Description"
            style: const TextStyle(
              color: Color(0xFF999999),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            focusNode: focusNode,
            maxLines: 7,
            minLines: 5,
            maxLength: maxChars,
            style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 14, height: 1.5),
            decoration: InputDecoration(
              counterText: '', // hide default counter, we draw our own
              hintText: lg.appealHint, // add to l10n
              hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14, height: 1.5),
              filled: true,
              fillColor: const Color(0xFFF8F8F8),
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Col.primary, width: 1.4),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // char counter
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$charCount / $maxChars',
              style: TextStyle(
                color: nearLimit ? const Color(0xFFEF4444) : const Color(0xFFBBBBBB),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SubmitButton
// ─────────────────────────────────────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.enabled, required this.onTap, required this.lg});

  final bool enabled;
  final VoidCallback onTap;
  final AppLocalizations lg;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppealCubit, AppealState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: enabled ? onTap : null,
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  height: 54,
                  decoration: BoxDecoration(
                    color: enabled ? Col.primary : Col.primary.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child:
                        state is AppealLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              lg.submitAppeal, // add to l10n e.g. "Submit Appeal"
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.1,
                              ),
                            ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
