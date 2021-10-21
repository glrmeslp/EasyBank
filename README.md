<h1 align="center"> EasyBank </h1>

> Project Status: under development :warning:

### Topics
  * [Project description](#project-description)
  * [What the platform is capable of doing](#what-the-app-is-able-to-do)
  * [Getting Started](#getting-started)
  * [Dependencies](#dependencies)
  * [License](#license)
  
## Project description

EasyBank is a money manager for board games. This app keeps track of accounts in a room so you can enjoy the game without worrying about counting money anymore. 
Each room represents a game that can have multiple accounts.

## What the app is able to do

- Authentication with email
- Room creation: A new account is created.
- Room join: If you already have an account in this room. A new account will not be created.

## Getting Started 

Clone this project and cd into the EasyBank directory. Run pod install. This command will install all of the required cocoapods for this project and generate a .xcworkspace project. 
Go ahead and open the EasyBank.xcworkspace project.

### Terminal commands to clone and open the project!

```bash
$ git clone https://github.com/glrmeslp/EasyBank.git

$ cd EasyBank/

$ pod install --repo-update

$ open EasyBank.xcworkspace
```
## Connecting to the [Firebase Console](https://console.firebase.google.com/)

We will need to connect our project with the [Firebase Console](https://console.firebase.google.com/). For an in depth explanation, you can read more about [adding Firebase to your iOS Project.](https://firebase.google.com/docs/ios/setup)

### Here's a summary of the steps!

1. Visit the [Firebase Console](https://console.firebase.google.com/) and create a new app.
2. Add an iOS app to the project. Make sure the Bundle Identifier you set for this iOS App matches that of the one in this project.
3. Download the GoogleService-Info.plist when prompted.
4. Drag the downloaded GoogleService-Info.plist into the opened project app. In Xcode, you can also add this file to the project by going to File-> Add Files to 'EasyBank' and selecting the downloaded .plist file. Be sure to add the .plist file to the app's main target.
5. At this point, you can build and run the EasyBank!

### Console

In the Firebase console for your project, you'll need to enable the following auth providers:
- Email/Password

Visit [Firebase Authentication](https://firebase.google.com/docs/auth) for more details

## Dependencies

- [Firebase Firestore](https://firebase.google.com/docs/firestore)
- [FirebaseUI with Email](https://firebase.google.com/docs/auth/ios/firebaseui)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/glrmeslp/EasyBank/blob/master/LICENSE) file for details



