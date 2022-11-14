import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/viewobject/noti.dart';

class NotiListItem extends StatelessWidget {
  const NotiListItem({
    Key? key,
    required this.noti,
    this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  final Noti noti;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: GestureDetector(
          onTap: onTap as void Function()?,
          child: Container(
              // color: noti.isRead == '0'
              //     ? PsColors.backgroundColor
              //     : PsColors.baseColor,
              margin: const EdgeInsets.all(PsDimens.space16),
              child: Ink(
                  color: PsColors.primary500,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(PsDimens.space10),
                        child: Container(
                          width: PsDimens.space64,
                          height: PsDimens.space56,
                          child: PsNetworkImage(
                            photoKey: '',
                            defaultPhoto: noti.defaultPhoto,
                            imageAspectRation: PsConst.Aspect_Ratio_1x,
                            onTap: onTap,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: PsDimens.space8,
                      ),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: PsDimens.space10),
                              child: Text(noti.message!,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.bodyText1),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: PsDimens.space10),
                              child: Text(
                                noti.addedDateStr!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
        ),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation!,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation!.value), 0.0),
                child: child),
          );
        });
  }
}
