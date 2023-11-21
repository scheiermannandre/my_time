# Deeplinking using Flutters DeepLinking Systems and GoRouter without any special 3rd Party Libraries

# Android

## Helpful Resources
- `https://docs.flutter.dev/cookbook/navigation/set-up-app-links` 
- `https://developer.android.com/training/app-links/verify-android-applinks#manual-verification` -> from headline Manual Verification
- ` https://stackoverflow.com/questions/76808147/flutter-deep-links-not-working-from-browser-but-working-with-adb-command` 
- `https://developers.google.com/digital-asset-links/tools/generator`
- `https://firebase.google.com/support/guides/app-links-universal-links`

0. install `adb` -> run `brew install android-platform-tools`

1. add this to `android/app/src/main/AndroidManifest.xml`

```
            <!-- Deep linking -->
            <meta-data android:name="flutter_deeplinking_enabled" android:value="true" />
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="http" android:host="mighty-time-tracker.web.app" android:pathPrefix="/auth" />
                <data android:scheme="https" android:host="mighty-time-tracker.web.app" android:pathPrefix="/auth" />
            </intent-filter>
```
2. host an `assetlinks.json` file on your domain. In it you need to define something like this:

```
[
    {
        "relation": [
            "delegate_permission/common.handle_all_urls"
        ],
        "target": {
            "namespace": "android_app",
            "package_name": "com.andrescheiermann.mytime",
            "sha256_cert_fingerprints": [
                "DA:60:06:5E:70:11:0B:B4:1F:F6:46:36:8E:D8:1B:6B:E1:99:0A:5F:9B:C5:E5:4C:9F:F5:04:E4:70:2F:7D:79"
            ]
        }
    }
]
```

You can find the sha256_cert_fingerprints either on the google play console or by running this command 
`adb shell pm get-app-links com.andrescheiermann.mytime`

3. By now you should be able to run following command, this will open the android app at the specified destination

```
 adb shell 'am start -a android.intent.action.VIEW \                   
    -c android.intent.category.BROWSABLE \
    -d "https://mighty-time-tracker.web.app/auth"' \
    com.andrescheiermann.mytime
```

4. If this opens you should be able to click a link following the specified path and it should open in the app

# Troubleshooting

If the app does not open the link try following:

1. go to `https://developers.google.com/digital-asset-links/tools/generator` and verify that the deep link functionality is acutally working on android. If not you probably have the wrong sha256 fingerprint
2. run `adb shell pm get-app-links com.andrescheiermann.mytime` -> the result should look something like this. 
!!!!!!!! THE DOMAIN SHOULD BE VERIFIED !!!!!!!!
```
com.andrescheiermann.mytime:
    ID: 67a84d13-4741-44a8-bdb4-6d631d81993d
    Signatures: [DA:60:06:5E:70:11:0B:B4:1F:F6:46:36:8E:D8:1B:6B:E1:99:0A:5F:9B:C5:E5:4C:9F:F5:04:E4:70:2F:7D:79]
    Domain verification state:
      mighty-time-tracker.web.app: verified
```

if not run: 
- `adb shell am compat enable 175408749 com.andrescheiermann.mytime`
- `adb shell pm set-app-links --package com.andrescheiermann.mytime 0 all`
- `adb shell pm verify-app-links --re-verify com.andrescheiermann.mytime`
- run this again `adb shell pm get-app-links com.andrescheiermann.mytime` -> it now should show verified and the app should open via links



# iOS


## Helpful Resources

- `https://docs.flutter.dev/cookbook/navigation/set-up-universal-links`(provided AASA File format is deprecated)
- `https://developer.apple.com/documentation/xcode/supporting-associated-domains` (showing the new valid AASA File format)
- `https://developer.apple.com/documentation/bundleresources/applinks`
- `https://developer.apple.com/documentation/bundleresources/applinks/details/components` (explaining the new format)
- `https://branch.io/resources/aasa-validator` (validator for the AASA File hosted on your domain)
- `https://developer.apple.com/documentation/technotes/tn3155-debugging-universal-links#Host-and-verify-your-AASA` (debugging universal links)

1. in Xcode open the `Info.plist` File -> make sure that you open it in the All Tab, not just Debug, Release etc.
2. add a new row and update the key to `FlutterDeepLinkingEnabled` and change its `Boolean` Value to `true` or `YES` depending on what is the format
3. go to `Targets` and click `Runner` go to the `Signing & Capabilities` Tab. Under the `All` tab add a new Capability and choose Associated Domain.
4. Enter `applinks:<web domain>` and replace `<web domain>` with your own domain name.

5. create an Apple-App-Site-Association File (DO NOT USE THE FORMAT PROVIDED IN THE FLUTTER OR FIREBASE DOCUMENTATION IT IS DEPRECATED AND WILL NOT WORK!)
use this link instead: `https://developer.apple.com/documentation/xcode/supporting-associated-domains`

it should look similar to this:

```
{
    "applinks": {
        "apps": [],
        "details": [
            {
                "appIDs": [
                    "UK8VJ5JDSZ.com.andrescheiermann.mytime"
                ],
                "components": [
                    {
                        "/": "/authHandler"
                    }
                ]
            }
        ]
    }
}
```

one appID is made up of `<TeamID.Bundle Identifier`
the components define the paths that should be linked to your app. Reference about how to set them and which parameters are available can be found here: 
`https://developer.apple.com/documentation/bundleresources/applinks/details/components`

6. Host the file in your domain so that it is accessible at `https://<your-domain>/.well-known/apple-app-site-association`, you can do this using firebase hosting
7. Verify that you can access the file in your browser by going to the url where the file should be hosted
8. go to `https://branch.io/resources/aasa-validator/#resultsbox` and type in your web domain the Apple App Prefix (it's actually your team id) and your apps bundle identifiert
 only if this test is green it means that your AASA File and its format are valid and it can be reached through web
9. verify that your AASA file is succesfully hosted by Apples CDN (Content Delivery Network) (this can take up to a week or 24 hours depending on the source you are reading, while implementing I noticed that it also was hosted within 15 - 30 minutes) -> you can do this by either typing `https://app-site-association.cdn-apple.com/a/v1/<your-domain>` in the browser or by executing `sudo swcutil dl -d <your-domain>` in your terminal. In the first case you should the the exact AASA file content that you provide in your domain, in the latter it looks like a json-like script, but also showing the same content that you provided in your domain, simply in another format
10. if you can verify step 8 and 9 you can either open a link on the device (physical or simulator) or type `xcrun simctl openurl booted https://<web domain>/<your-path>` in the terminal which should open the app


# Hosting with Firebase Hosting

## Helpful Resources

- `https://firebase.google.com/docs/hosting/quickstart`
- `https://firebase.google.com/support/guides/app-links-universal-links`

1. To host the files necessary for Deep Linking in Flutter using Firebase Hosting you need to follow the steps in this link `https://firebase.google.com/docs/hosting/quickstart`
2. install the Firebase CLI
3. initialize your web-domain project by executing `firebase init hosting` your you will have the option to configure some settings regarding the directory in which your static files will lie and the connection to other firebase projects 
4. if you have already your own static files (html, css, js/ts) you need to paste them in the provided directory, if you didn't specify them you will find them in `./public`
5. when done configuring you should find a `firebase.json` file, initially it should look like this

``` 
{
  "hosting": {
    "public": "public",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ]
  }
}
```
6. hosting the `assetlinks.json` file, requires you to add the file in the `./.well-known/` folder
your folder structure should now look like this
```
<Your Project>
    - public (or the directory you configured)
        - .well-known
            - assetlinks.json
```
7. in the next step you should configure that the `assetlinks.json` file is exposed to the browser. Therefore you need to edit the `firebase.json` config and add a header config.
This is how the config should look like after this step.
```
{
  "hosting": {
    "public": "public",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "headers": [
      {
        "source": "/.well-known/assetlinks.json",
        "headers": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ]
      }
    ]
  }
}
```

8. hosting the AASA file in your firebase hosted domain requires you to add the `apple-app-site-association` file in the `./.well-known/` folder
your folder structure should now look like this
```
<Your Project>
    - public (or the directory you configured)
        - .well-known
            - assetlinks.json
            - apple-app-site-association
```
9. in the next step you should configure that the `apple-app-site-association` file is exposed to the browser. Therefore you need to edit the `firebase.json` config and add a header config.
This is how the config should look like after this step.
```
{
  "hosting": {
    "public": "public",
    "appAssociation": "NONE",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "headers": [
      {
        "source": "/.well-known/assetlinks.json",
        "headers": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ]
      },
      {
        "source": "/.well-known/apple-app-site-association",
        "headers": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ]
      }
    ]
  }
}
```

10. in order to make your `apple-app-site-association` file verifiable yu also need to add a `web.config` file in to you `public` folder or in the directory you configured for deploying
11. open the `web.config` file and paste `<mimeMap fileExtension=”.” mimeType=”application/json” />` inside of the file
12. execute `firebase deploy --only hosting` with this you domain should be up and running 
