test:
	@echo "╠ Running test..."
	flutter test
	@echo "SUCCESSS: All tests passed!"

deploy-android:
	@echo "╠ Sending Android Build to Google Play Store.."
    cd android && bundle install
    cd android/fastlane && bundle exec fastlane deploy


# deploy-ios:
#     @echo "╠ Sending iOS Build to TestFlight..."
#     cd ios/fastlane && bundle exec fastlane deploy

# deploy-web:
#     @echo "╠ Sending Build to Firebase Hosting..."
#     flutter build web
#     firebase deploy

deploy: test deploy-android
# deploy: test deploy-android deploy-ios deploy-web

.PHONY: test deploy-android deploy-ios deploy-web
