import 'package:flutter/material.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/widgets/CustomDropDown/select_drop_list.dart';
import 'package:provider/provider.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final AppBar appBar;
  final List<Widget> widgets;

  /// you can add more fields that meet your needs

  const BaseAppBar(this.title, this.appBar, this.widgets);

  @override
  Widget build(BuildContext context) {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);

    return AppBar(
        title: Text(ApplicationLocalizations.of(context)
            .translate(i18.common.MGRAM_SEVA)),
        actions: [
          SimpleAccountMenu(
            iconColor: Colors.white,
            onChange: (index) {
              print(index);
            },
            input: commonProvider.userDetails!.userRequest!.roles!,
          )
        ]);
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
