import 'package:flutter/material.dart';
import 'package:lyrics2/data/firebase_user_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProxySelector extends StatelessWidget {
  const ProxySelector({super.key});

  static const List<String> services = <String>['Genius', 'ChartLyrics'];

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<FirebaseUserRepository>(context, listen: false);
    String dropdownValue = users.useGenius ? services.first : services.last;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.msgUseService,
                  style: users.themeData.textTheme.bodyMedium),
              DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.miscellaneous_services),
                  items: services.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: users.themeData.textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      dropdownValue = value;
                      if (dropdownValue == services.first) {
                        users.useGenius = true;
                      } else {
                        users.useGenius = false;
                      }
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }
}