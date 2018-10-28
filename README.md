# mealplan

This is a simple app that lets you predefine meals. Then when you select your meals for the week it will create a shopping list for you.

## Setup

To get this app working you need to setup firebase. Go to [firebase console](https://console.firebase.google.com/). There you can create firebase apps for iOS and Android. Put the iOS file `GoogleService-Info.plist` in the `ios` directory. Put the Android file `google-services.json` in the `android/app` directlry. Finally populate a `json` file at `assets/firestore.json` with the data:
```
{
    "googleAppID": "xxx",
    "gcmSenderID": "xxx",
    "apiKey": "xxx",
    "projectID": "xxx",
    "bundleID": "xxx"
}
```