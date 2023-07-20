### Deploy App to Google Play Store 

Main Source -> https://docs.flutter.dev/deployment/cd#fastlane
Fastlane -> https://docs.fastlane.tools/

Pre-Condition: 
1. Build and Release App manually to Play Store -> https://docs.flutter.dev/deployment/android
2. have access to upload signing key file

1. Install fastlane `brew install fastlane`
2. Build Project `flutter build appbundle`
3. Initialize the fastlane `cd android && fastlane init`
4. Go to the Fastlane Appfile ([project]/android/fastlane/Appfile)
5. set package_name with the value of package name in AndroidManifest.xml
7. Set up your local login credentials for the store follow the instruction -> https://docs.fastlane.tools/getting-started/android/setup/#setting-up-supply
8. copy play store secret JSON file into [project]/android
9. add play store secret JSON file to `.gitignore`
10. update/add the line `json_key_file("./NAME_OF_PLAY_STORE_SECRET_FILE.json")` 
11. run `fastlane supply init`
12. go [project]/android/fastlane and create a Fastfile script
```
# This file contains the fastlane.tools configuration
# You can find the documentation at https://docs.fastlane.tools
#
# For a list of all available actions, check out
#
#     https://docs.fastlane.tools/actions
#
# For a list of all available plugins, check out
#
#     https://docs.fastlane.tools/plugins/available-plugins
#

# Uncomment the line if you want fastlane to automatically update itself
# update_fastlane

default_platform(:android)

lane :beta do
  # Adjust the `build_type` and `flavor` params as needed to build the right APK for your setup
  gradle(
    task: 'assemble',
    build_type: 'Release'
  )

  # ...
end

lane :playstore do
  gradle(
    task: 'assemble',
    build_type: 'Release'
  )
  upload_to_play_store(
    aab: "../build/app/outputs/bundle/release/app-release.aab"  )
  # upload_to_play_store # Uploads the APK built in the gradle step above and releases it to all production users
end
```

13. copy upload signing key file file into [project]/android
14. add upload signing key file to `.gitignore`
15. open [project]/android/app/build.gradle
16. change 
```
  signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
```

to

```
  signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile file('../YOUR_UPLOAD_SIGNING_KEY_NAME.jks')
           storePassword keystoreProperties['storePassword']
       }
   }
```

17. in the project rood create a folder `.github` cd into it and create a folder called `workflows`
18. inside [project]/.github/workflows create `deploy.yml`
19. put following code inside:
```
name: Deploy

on:
  workflow_dispatch:

jobs:
  android:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Code
      uses: actions/checkout@v3

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        channel: stable
        cache: true

    - name: Set up key.properties
      run: |
        echo "keyPassword=${{ secrets.KEY_PASSWORD }}" > android/key.properties
        echo "storePassword=${{ secrets.STORE_PASSWORD }}" >> android/key.properties
        echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
        echo "${{ secrets.STORE_FILE_CONTENT }}" | base64 --decode > android/upload-keystore.jks

    - name: Set up Play Store Secret
      run: |
        echo "${{ secrets.PLAY_STORE_SECRET }}" | base64 --decode > android/myTime_play_store_credentials.json

    - name: Setup Fastlane
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: 2.6
        rubygems: latest

    - name: Setup Java
      uses: actions/setup-java@v3
      with:
        distribution: 'zulu'
        java-version: "12.x"
        cache: 'gradle' 

    - name: Get Dependencies
      run: |
        flutter clean
        flutter pub get
       
    - name: Build App Bundle
      run: |
        flutter build appbundle    

    - name: Deploy
      run: |
        cd android 
        bundle install
        bundle exec fastlane playstore
```

20. in GitHub go to `settings/secrets/actions`
21. Create secret for `KEY_PASSWORD` paste value from [project]/android/key.properties -> `keyPassword`
22. Create secret for `STORE_PASSWORD` paste value from [project]/android/key.properties -> `storePassword`
23. Create secret for `KEY_ALIAS` paste value from [project]/android/key.properties -> `keyAlias`
24. encrypt and copy value of upload signing key by using `base64 -i path/to/upload_key.jks | pbcopy` on mac
25. Create secret for `STORE_FILE_CONTENT` paste the just copied value
26. encrypt and copy value of play store secret file by using `base64 -i path/to/play_store_secret_file.json | pbcopy` on mac
27. Create secret for `PLAY_STORE_SECRET` paste the just copied value
28. go to [project]/android 
29. create `Gemfile` and add the content
```
source "https://rubygems.org"

gem "fastlane"
```
30. run `bundle update`
31. commit and push code