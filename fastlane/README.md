fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### notify_discord
```
fastlane notify_discord
```
Message to Discord via WebHook
### notify_test
```
fastlane notify_test
```
Test lane for Discord notification

----

## iOS
### ios build_for_testing
```
fastlane ios build_for_testing
```
Installs CocoaPods deps and runs clean build
### ios run_app_tests
```
fastlane ios run_app_tests
```
Only runs app tests.
### ios build_and_test
```
fastlane ios build_and_test
```
Combines two lanes `:build_for_testing` and `:run_app_tests`

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
