import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../data/sqlite_settings_repository.dart';
import '../models/setting.dart';

class ProxySelector extends StatefulWidget {
  const ProxySelector({Key? key}) : super(key: key);

  @override
  State<ProxySelector> createState() => _ProxySelectorState();
}

class _ProxySelectorState extends State<ProxySelector> {
  static const List<String> services = <String>['Genius', 'ChartLyrics'];
  @override
  Widget build(BuildContext context) {
    var users = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    //users.init();
    String dropdownValue = users.useGenius ? services.first : services.last;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppLocalizations.of(context)!.msgUseService,
            style: users.themeData.textTheme.bodyText2),
        const SizedBox(width: 10,),
        DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.miscellaneous_services),
            items: services.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: users.themeData.textTheme.bodyText2,
                ),
              );
            }).toList(),
            onChanged: (String? value) async {
              setState(() {
                dropdownValue = value!;
                if (dropdownValue == services.first) {
                  users.useGenius = true;
                } else {
                  users.useGenius = false;
                }
              });
              final sqlRepository =
              Provider.of<SQLiteSettingsRepository>(context, listen: false);
              //sqlRepository.init();
              if (dropdownValue == services.first) {
                await sqlRepository.insertSetting(
                    Setting(setting: Setting.geniusProxy, value: "true"));
              } else {
                await sqlRepository.insertSetting(
                    Setting(setting: Setting.geniusProxy, value: "false"));
              }
            }),
      ],
    );
  }
}
