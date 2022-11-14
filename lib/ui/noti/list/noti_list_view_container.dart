

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/ui/noti/list/noti_list_view.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class NotiListContainerView extends StatefulWidget {
  @override
  _NotiListContainerViewState createState() => _NotiListContainerViewState();
}

class _NotiListContainerViewState extends State<NotiListContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
              systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),  
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.backArrowColor),
          title: Text(Utils.getString(context, 'noti_list__toolbar_name'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold)
                //  .copyWith(color: Utils.isLightMode(context)? PsColors.primary500 : PsColors.primaryDarkWhite)
                  ),
          elevation: 0,
        ),
        body: Container(
          color: PsColors.baseColor,
          height: double.infinity,
          child: NotiListView(),
        ),
      ),
    );
  }
}
