# Preliminaries
1. register at https://developer.apple.com/
2. purchase annual license 99€

# Register your app on App Store Connect
## Register a Bundle ID
1. Register Bundle ID. Go to https://developer.apple.com/ click Identifiers under Program Resources (https://developer.apple.com/account/resources/identifiers/list)
2. Click + to create a new Bundle ID.
3. Enter an app name, select Explicit App ID, and enter an ID in the format 'com.domain.app' i.e. 'com.andrescheiermann.mytime'
4. Select the services your app uses, then click Continue.
5. On the next page, confirm the details and click Register to register your Bundle ID.

## Create an application record on App Store Connect

1. go to https://developer.apple.com/
2. On the App Store Connect landing page, click Apps.
3. Click + in the top-left corner of the Apps page, then select New App.
4. Choose device, fill in name, choose BundleId that you previosly created, enter a unique random sku. Click Create


# Review Xcode project Settings
1. open the ios folder in xcode
2. in the left pane click runner, on the further right pane under runner click on runner

## General Tab
In the identity section
 - update `Display Name`
 - update `Bundle Identifier` according to what you have set while registering the app

## Signin&Capabilities Tab
 - set `Automatically manage signing` to `true`
 - set `Team` otherwise you can't build the app
 - check that `Bundle Identifier` is according to what you have set while registering the app

 ## Build Settings Tab
 In the Deployment section check the `iOS Deployment Target` according to Flutter, it supports iOS 11 and later check https://docs.flutter.dev/deployment/ios

# Updating the app’s deployment version
If you changed `Deployment Target` in your Xcode project, open `ios/Flutter/AppframeworkInfo.plist` in your Flutter app and update the ` MinimumOSVersion` value to match.

# Add an app icon
Use external packages

# Add a launch image
Use external packages

# Update Version in pubspec.yaml

# Create an app bundle
1. run `flutter build ipa`




