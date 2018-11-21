# mealplan

This is a simple app that lets you predefine meals. Then when you 
select your meals for the week it will create a shopping list for you.
It also provides the ability to add ad-hoc items to your list.

![App Image](screenshots/app.png?raw=True)

## Setup

You need to setup the datastore to get this app working. It can either
use firestore or it can use an in-memory database. Directions are as
follows.

### Firestore
To get this app working with firebase you need to setup firebase. Go to [firebase console](https://console.firebase.google.com/). There you can create firebase apps for iOS and Android. Put the iOS file `GoogleService-Info.plist` in the `ios` directory. Put the Android file `google-services.json` in the `android/app` directlry. Finally populate a `json` file at `assets/firestore.json` with the data:
```
{
    "googleAppID": "xxx",
    "gcmSenderID": "xxx",
    "apiKey": "xxx",
    "projectID": "xxx",
    "bundleID": "xxx"
}
```

### Memory
You can alternatively use this app with an in memory database (although you may still need to create some of the above mentioned files). To set it to use the in memory database change `_DatabaseProviderState.database` to be `DatabaseType.memory` in `lib/data/database_provider.dart`.