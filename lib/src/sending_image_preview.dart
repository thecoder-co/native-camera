// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import './camera_preview_buttons.dart';

class SendingImageViewPage extends StatefulWidget {
  String path;

  SendingImageViewPage({
    super.key,
    required this.path,
  });

  @override
  State<SendingImageViewPage> createState() => _SendingImageViewPageState();
}

class _SendingImageViewPageState extends State<SendingImageViewPage> {
  bool isFeed = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Image.file(
              File(widget.path),
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
            const CameraPreviewButtons(),
          ],
        ),
      ),
    );
  }
}

class FeedButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget icon;
  final String text;
  const FeedButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: ShapeDecoration(
          color: Color(isSelected ? 0xFF353535 : 0xFF202020),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 5),
            Text(text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ))
          ],
        ),
      ),
    );
  }
}
