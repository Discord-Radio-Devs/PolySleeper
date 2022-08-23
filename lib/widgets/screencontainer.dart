import 'package:flutter/material.dart';

class ScreenContainer extends StatelessWidget {
  final Widget child;
  const ScreenContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          FlutterError.onError = (details) {
            FlutterError.presentError(details);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text((details.summary).toString()),
              backgroundColor: Theme.of(context).errorColor,
            ));
          };

          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth,
                  ),
                  child: SafeArea(
                    // glorified bastard
                    minimum: const EdgeInsets.all(16),
                    child: child,
                  )));
        },
      ),
    );
  }
}
