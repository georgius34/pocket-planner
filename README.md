# pocketplanner

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

how to install flutter & dart:
Part 1
https://youtu.be/VFDbZk2xhO4?si=igzUc6gSiMkpAgew
Part 2
https://youtu.be/p7MkQHfVbcQ?si=-RfznHZYeTz_DLcS

Link guide:
https://www.youtube.com/watch?v=9YuKvGElOe8&t=5s
progress: 55:49

-TO RUN (klik kanan main.dart > run without debug)

-TO INSTALL FIREBASE:
install firebase CLI
npm install -g firebase-tools
dart pub global activate flutterfire_cli
flutterfire configure (pilih database Pocket Planner > Android)


Note: 
jika ketemu error ini saat run flutterfire configure
firebase : File C:\Users\Lenovo\AppData\Roaming\npm\firebase.ps1 cannot be loaded because running scripts is disabled on this system. For more information, se 
e about_Execution_Policies at https:/go.microsoft.com/fwlink/?LinkID=135170.
At line:1 char:1
+ firebase login
+ ~~~~~~~~
    + CategoryInfo          : SecurityError: (:) [], PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess

1. Buka windows power shell as admin
2. run Set-ExecutionPolicy RemoteSigned 
3. Jalankan flutterfire configure
4. pilih database pocket_planner

tutorial: https://youtu.be/2kYT1bCf6Uw?si=hXZN5Rw0zbrCOMNY

Add Dependencies di pubspec.yaml:
 firebase_core: ^2.27.2
firebase_auth: ^4.18.0
cloud_firestore: ^4.15.10

create new page (template)
stl > flutter stateless/full widget







- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
