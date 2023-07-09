# MyTime
Get it here: https://play.google.com/store/apps/details?id=com.andrescheiermann.mytime

## Introduction

MyTime is a time-tracking app that aims to replace common time-tracking solutions that many employers use. The problem that those solutions have: They are not made for the employees, but rather for employers and their clients.

The idea was to make an app, that serves the User, by making it easy to track their working times across different Categories and different Projects. Furthermore it turns out to also be a great tool to track your hobbies, chores, free time activities and more.

Besides that MyTime was developed as a learning project.

The development of MyTime followed the goal to learn more about

- App Architecture
- State Management
- Testing
- Routing
- Error Handling

in Flutter.

Currently it is not following all the best practices, especially it is lacking automated tests, which is due to the fact of moving faster.

## Current Status

MyTime is at the moment a offline first application. It uses Realm DB to persist and retrieve user data. As all the data is stored on the user's device there is no authentication yet.

Furthermore it follows the layered Architecture and splits the code into the following layers:

- **Presentation:** Holding all code targeting Screens/Pages/Views.
- **Controller:** Holding all code targeting the Management of Screens/Pages/View making them easily exchangeable.
- **Service:** Holding all code that implements domain logic.
- **Repository:** Holding all code that interacts with the database.

Currently the Layers are distributed globally, meaning the lib folder contains the layers.

For separation and Dependency Injection Riverpod is used.

Furthermore the app was successfully published to the Android PlayStore. Due to some minor Bugs the next version is already published to Google and is waiting for approval. (08.07.23)

## Roadmap

### Q3 2023

- **App Store Release:** MyTime will be released to the Apple App Store.
- **Automatic Releases:** MyTime will be releasing new versions automatically to the Stores by using GitHub Action Workflows.
- **Restructuring to Feature-First:** MyTimes folder structure will be changed to Feature-First.
- **Test Coverage:** MyTime will have 100% test coverage, in order to secure the already existing and upcoming functionalities. Furthermore MyTimes new features will be developed using TDD.
- **Design System:** MyTimes Design System will be improved and changed so, that the Design System will be tokenized. Figma should be utilized.
- **Statistics Overview:** MyTimes will get new screens, so Users can better track and analyze their times.
- **Firebase Migration:** MyTime will migrate to the Services that Firebase is providing including Authentication and data storage.
