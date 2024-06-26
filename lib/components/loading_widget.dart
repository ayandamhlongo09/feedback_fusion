import 'package:feedback_fusion/utils/values/colors.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Color? color;

  const LoadingWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.blue),
      ),
    );
  }
}
