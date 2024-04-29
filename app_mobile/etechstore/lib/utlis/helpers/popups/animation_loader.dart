import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AnimationLoaderWidget extends StatefulWidget {
  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const AnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
  });

  @override
  State<AnimationLoaderWidget> createState() => _AnimationLoaderWidgetState();
}

class _AnimationLoaderWidgetState extends State<AnimationLoaderWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
    );

    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        controller.reset();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(
            widget.animation,
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 8,
            repeat: true,
            fit: BoxFit.cover,
            onLoaded: (composition) {
              controller.duration = composition.duration;
              controller.forward();
            },
            controller: controller,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 15,
          ),
          widget.showAction
              ? SizedBox(
                  width: 50,
                  child: OutlinedButton(
                      onPressed: widget.onActionPressed,
                      child: Text(
                        widget.actionText!,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
                      )),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
