import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../data/sqlite_settings_repository.dart';
import '../models/setting.dart';

class ProxySelector extends StatefulWidget {
  //var callback = <Future<void> Function(BuildContext context)>[];
  final Function callback;

  const ProxySelector({Key? key,
    required this.callback}) : super(key: key);

  @override
  State<ProxySelector> createState() => _ProxySelectorState();
}

class _ProxySelectorState extends State<ProxySelector> {
  static const List<String> services = <String>['Genius', 'ChartLyrics'];
  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<SQLiteSettingsRepository>(context, listen: false);
    //settings.init();
    String dropdownValue = settings.useGenius ? services.first : services.last;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppLocalizations.of(context)!.msgUseService,
            style: settings.themeData.textTheme.bodyMedium),
        const SizedBox(width: 10,),
        DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.miscellaneous_services),
            items: services.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: settings.themeData.textTheme.bodyMedium,
                ),
              );
            }).toList(),
            onChanged: (String? value) async {
              setState(() {
                dropdownValue = value!;
                if (dropdownValue == services.first) {
                  settings.useGenius = true;
                } else {
                  settings.useGenius = false;
                }
              });
              // Call callback only if not null!
              widget.callback(context);
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
