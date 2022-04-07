import 'package:flutter/material.dart';

import '../app_theme.dart';

class RetryWidget extends StatelessWidget {
  RetryWidget({required this.onTapCallback, Key? key}) : super(key: key);
  Function onTapCallback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          onTapCallback;
        },
        child: const Text(
          "网络异常，点击重试 !",
          style: TextStyle(color: AppTheme.warning, fontSize: 30),
        ),
      ),
    );
  }
}
