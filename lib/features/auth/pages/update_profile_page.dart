import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/features/home/bloc/get_profile_cubit/get_profile_cubit.dart';

import '../../../core/colors.dart';
import '../../../core/helpers.dart';
import '../../global/widgets/custom_snack_bar.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../../home/model/profile.dart';
import '../../reels/blocs/file_processing_cubit/file_processing_cubit.dart';
import '../../reels/blocs/file_upl_cover_image_bloc/file_upl_cover_image_bloc.dart';
import '../../reels/model/meninki_file.dart';
import '../../store/pages/store_create_page.dart';
import '../bloc/register_cubit/register_cubit.dart';

// ─────────────────────────────────────────────────────────────────────────────
// UpdateProfilePage — Light theme, consistent with previous pages
//
// Pass the current [profile] as a constructor argument.
// ─────────────────────────────────────────────────────────────────────────────

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key, required this.profile});

  final Profile profile;

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late final TextEditingController _firstNameCont;
  late final TextEditingController _lastNameCont;
  late final TextEditingController _usernameCont;
  // late final TextEditingController _phoneCont;

  MeninkiFile? coverImage;

  @override
  void initState() {
    super.initState();
    widget.profile.cover_image?.status = 'ready';
    _firstNameCont = TextEditingController(text: widget.profile.first_name ?? '');
    _lastNameCont = TextEditingController(text: widget.profile.last_name ?? '');
    _usernameCont = TextEditingController(text: widget.profile.username ?? '');
    // _phoneCont = TextEditingController(text: widget.profile.phonenumber ?? '');
    if (widget.profile.cover_image != null) {
      coverImage = widget.profile.cover_image;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _firstNameCont.dispose();
    _lastNameCont.dispose();
    _usernameCont.dispose();
    // _phoneCont.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    context.read<FileUplCoverImageBloc>().add(Clear());
    super.deactivate();
  }

  void _submit(BuildContext context) {
    HapticFeedback.mediumImpact();
    final body = <String, dynamic>{
      if (_firstNameCont.text.trim().isNotEmpty &&
          _firstNameCont.text.trim() != widget.profile.first_name)
        'first_name': _firstNameCont.text.trim(),
      if (_lastNameCont.text.trim().isNotEmpty &&
          _lastNameCont.text.trim() != widget.profile.last_name)
        'last_name': _lastNameCont.text.trim(),
      if (_usernameCont.text.trim().isNotEmpty &&
          _usernameCont.text.trim() != widget.profile.username)
        'username': _usernameCont.text.trim(),
      // if (_phoneCont.text.trim().isNotEmpty && _phoneCont.text.trim() != widget.profile.phonenumber)
      //   'phonenumber': _phoneCont.text.trim(),
      if (coverImage != null && coverImage?.id != widget.profile.cover_image?.id)
        'cover_image_id': coverImage?.id,
    };
    context.read<RegisterCubit>().updateProfile(body);
  }

  @override
  Widget build(BuildContext context) {
    final lg = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is UpdateSuccess) {
              context.read<GetProfileCubit>().refreshMyProfile();
              CustomSnackBar.showSnackBar(context: context, title: lg.success);
              Go.pop();
            }
            if (state is RegisterFailed) {
              CustomSnackBar.showSnackBar(
                context: context,
                title: state.failure.message ?? lg.smthWentWrong,
                isError: true,
              );
            }
          },
        ),
        BlocListener<FileUplCoverImageBloc, FileUplCoverImageState>(
          listener: (context, state) {
            if (state is FileUploadCoverImageFailure) {
              CustomSnackBar.showSnackBar(
                context: context,
                title: state.failure.message ?? lg.smthWentWrong,
                isError: true,
              );
            }
            if (state is FileUploadCoverImageSuccess) {
              coverImage = state.file;
              CustomSnackBar.showSnackBar(
                context: context,
                title: AppLocalizations.of(context)!.success,
                isError: false,
              );
            }
          },
        ),
        BlocListener<FileProcessingCubit, FileProcessingState>(
          listener: (context, state) {
            if (state is FileProcessingUpdated) {
              if (state.file.id == coverImage?.id) {
                coverImage = state.file;
                setState(() {});
              }
            }
          },
        ),
      ],
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
            lg.updateProfile, // add to l10n
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: _SaveButton(onTap: () => _submit(context), lg: lg),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ── cover image picker ─────────────────────────────────────
                BlocBuilder<FileUplCoverImageBloc, FileUplCoverImageState>(
                  builder: (context, state) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () async {
                        if (state is! FileUploadingCoverImage) {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            lockParentWindow: true,
                          );

                          if (result != null) {
                            File original = File(result.files.single.path!);
                            if (isVideo(original)) {
                              CustomSnackBar.showYellowSnackBar(
                                context: context,
                                title: lg.chooseImage,
                              );
                              return;
                            }

                            final croppedFile = await ImageCropper().cropImage(
                              sourcePath: original.path,
                              aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
                              uiSettings: [
                                AndroidUiSettings(
                                  toolbarTitle: 'Crop Image',
                                  toolbarColor: Colors.black,
                                  toolbarWidgetColor: Colors.white,
                                  initAspectRatio: CropAspectRatioPreset.square,
                                  lockAspectRatio: true,
                                  hideBottomControls: true,
                                ),
                                IOSUiSettings(
                                  title: 'Crop Image',
                                  aspectRatioLockEnabled: true,
                                  aspectRatioPickerButtonHidden: true,
                                  rotateButtonsHidden: true,
                                  resetButtonHidden: true,
                                ),
                              ],
                            );

                            if (croppedFile == null) {
                              // User cancelled cropping
                              return;
                            }

                            final file = File(croppedFile.path);
                            coverImage = null;
                            setState(() {});
                            context.read<FileUplCoverImageBloc>().add(UploadFile(file));
                          }
                        }
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Color(0xFFF3F3F3), width: 1),
                              ),
                              child:
                                  coverImage?.status == 'ready'
                                      ? MeninkiNetworkImage(
                                        borderRadius: 100,
                                        file: coverImage!,
                                        networkImageType: NetworkImageType.small,
                                        fit: BoxFit.cover,
                                      )
                                      : UploadingCoverImage(
                                        height: 70,
                                        width: 70,
                                        coverImage: coverImage,
                                        loadingProgress:
                                            state is FileUploadingCoverImage
                                                ? state.progress
                                                : null,
                                      ),
                            ),
                          ),
                          Box(w: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(AppLocalizations.of(context)!.storeAvatar),
                              Text(
                                AppLocalizations.of(context)!.clickToChange,
                                style: TextStyle(fontSize: 12, color: Color(0xFF969696)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // ── name fields ────────────────────────────────────────────
                _SectionCard(
                  children: [
                    _ProfileField(
                      controller: _firstNameCont,
                      label: lg.firstName, // add to l10n
                      hint: lg.firstNameHint, // add to l10n
                      icon: Icons.person_outline_rounded,
                      textCapitalization: TextCapitalization.words,
                    ),
                    _FieldDivider(),
                    _ProfileField(
                      controller: _lastNameCont,
                      label: lg.lastName, // add to l10n
                      hint: lg.lastNameHint, // add to l10n
                      icon: Icons.person_outline_rounded,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── username + phone ───────────────────────────────────────
                _SectionCard(
                  children: [
                    _ProfileField(
                      controller: _usernameCont,
                      label: lg.username, // add to l10n
                      hint: '@username',
                      icon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.text,
                    ),
                    // _FieldDivider(),
                    // _ProfileField(
                    //   controller: _phoneCont,
                    //   label: lg.phoneNumber, // add to l10n
                    //   hint: 'XX XXXXXX',
                    //   icon: Icons.phone_outlined,
                    //   prefix: '+993 ',
                    //   keyboardType: TextInputType.phone,
                    // ),
                  ],
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
// _CoverImageRow  — placeholder row for your existing image-picker component
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// _SectionCard  — white card wrapping one or more fields
// ─────────────────────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ProfileField  — label + text input row inside a card
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.prefix,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? prefix;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          // label column
          SizedBox(
            width: 100,
            child: Row(
              children: [
                Icon(icon, size: 16, color: const Color(0xFFBBBBBB)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // input
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                prefixText: prefix,
                prefixStyle: const TextStyle(color: Color(0xFF888888), fontSize: 14),
                hintStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// thin divider between fields inside a card
class _FieldDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Divider(color: Color(0xFFF0F0F0), height: 1, thickness: 1),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SaveButton
// ─────────────────────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onTap, required this.lg});

  final VoidCallback onTap;
  final AppLocalizations lg;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  height: 54,
                  decoration: BoxDecoration(
                    color: Col.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child:
                        state is RegisterLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              lg.save, // add to l10n
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
