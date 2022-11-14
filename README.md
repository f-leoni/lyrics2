# L Y R I C S   2
Find and read your favourite songs' lyrics by (part of the) text, Autor and title or by listening to your song!

# PROJECT DESCRIPTION
This project is a Flutter exercise but it's a complete app and it leverages some flutter features such as:
* Multiple Providers
* Multiple Routers
* Full Localization

# THIRD PARTY LIBRARIES
Lyrics uses some third party libraries such as:
* provider - for state management
* smooth_page_indicator - For Onboarding screen navigation
* xml2json - for XML to JSON conversion
* logger - for logging
* sqflite - for database management
* flutter_acrcloud - For sound recognition
* flutter_icons - For app icons generation
* package_info_plus - To show build information 

# FEATURES LIST
## TODO:
* (feature) Ordering and pagination for favorites page
* (feature) Implement Genius Proxy
* ...

## DONE
* (feature) Database repository 2022/11/04
* (fix) Fix sound recognition
* (feature) Implement show build infos
* (feature) Implement graphics theme (dark and light)
* (feature) swipe to delete favorite
* (feature) Implement Users Registration, Login and profile management via Firebase
* (fix) Use different graphic elements based on active theme


# COMMANDS
## GENERATE LOCALIZATION FILES
flutter gen-l10n

## GENERATE ICONS
flutter pub run flutter_launcher_icons:main

## GENERATE BUNDLE
flutter build appbundle

## GENERATE APK
flutter build apk

## CLEAN PROJECT
flutter clean

## CONNECT TO DB
> adb -s emulator-5554 shell
> > run-as it.zitzusoft.lyrics_2
> > cd /data/user/0/it.zitzusoft.lyrics_2/app_flutter/
> > sqlite3 lyrics.db
> > > .tables

View tables list
> > > .schema favorites

describe table favorites
> > > .schema settings

describe table settings
