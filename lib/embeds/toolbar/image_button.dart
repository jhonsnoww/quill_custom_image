import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../embed_types.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    required this.icon,
    required this.controller,
    this.iconSize = kDefaultIconSize,
    this.onImagePickCallback,
    this.fillColor,
    this.filePickImpl,
    this.webImagePickImpl,
    this.iconTheme,
    this.dialogTheme,
    this.tooltip,
    this.linkRegExp,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;

  final Color? fillColor;

  final QuillController controller;

  final OnImagePickCallback? onImagePickCallback;

  final WebImagePickImpl? webImagePickImpl;

  final FilePickImpl? filePickImpl;

  final QuillIconTheme? iconTheme;

  final QuillDialogTheme? dialogTheme;
  final String? tooltip;
  final RegExp? linkRegExp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconColor = iconTheme?.iconUnselectedColor ?? theme.iconTheme.color;
    final iconFillColor =
        iconTheme?.iconUnselectedFillColor ?? (fillColor ?? theme.canvasColor);

    return QuillIconButton(
      icon: Icon(icon, size: iconSize, color: iconColor),
      tooltip: tooltip,
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * 1.77,
      fillColor: iconFillColor,
      borderRadius: iconTheme?.borderRadius ?? 2,
      onPressed: () => _onPressedHandler(context),
    );
  }

  Future<void> _onPressedHandler(BuildContext context) async {
    if (onImagePickCallback != null) {
      _pickImage(context);
    }
  }

  void _pickImage(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth && context.mounted) {
      // Granted.
      final List<AssetEntity>? result = await AssetPicker.pickAssets(context,
          pickerConfig: const AssetPickerConfig(
              maxAssets: 3,
              requestType: RequestType.image,
              keepScrollOffset: true));

      if (result != null) {
        final List<AssetEntity> re = result.reversed.toList();

        if (re.isNotEmpty) {
          for (var i = 0; i < re.length; i++) {
            final index = controller.selection.baseOffset;
            final length = controller.selection.extentOffset - index;
            log('index : $index | len : $length');
            File? file = await re[i].file;

            String? imageUrl = file!.path;

            onImagePickCallback?.call(file);

            controller.replaceText(
                index, length, BlockEmbed.image(imageUrl), null);
            controller.replaceText(index, length, '\n', controller.selection);
            controller.updateSelection(
                TextSelection.collapsed(offset: controller.document.length),
                ChangeSource.LOCAL);
          }
        }
      }
    } else {
      // Limited(iOS) or Rejected, use `==` for more precise judgements.
      // You can call `PhotoManager.openSetting()` to open settings for further steps.
    }
  }
}
