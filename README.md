# SpaceShipsApp

## About

An iOS application for overviewing ships that assist SpaceX launches, including ASDS drone ships, tugs, fairing recovery ships, and various support ships.

## Overview

Application is available from iOS 15 and consists of three screens:
1. Login Screen
2. Ships List Screen
3. Ships Details Screen
<br><br>

### Login Screen

<img src="https://github.com/user-attachments/assets/d0cea9f9-8ea7-4764-9c6b-5bd7e0482913" width="265" >
<img src="https://github.com/user-attachments/assets/770f9519-fbd4-42e6-acb7-12aabb468211" width="265" >
<img src="https://github.com/user-attachments/assets/8b6e5e19-0614-44ab-809a-74dcbcb03045" width="265" >
<br><br>

Login Screen displays an application name and login fields. User is able to login using initialy predefined credentials or continue as a Guest for trialing an application. In case of logging in as a Guest, User's interactions with ships will not be saved. Additionally, Login Screen includes basic validation of User's email. After pressing Login or Continue as a Guest button, a loading indicator will be displayed with a 2 seconds delay before login success/failure to simulate a real login process.
<br><br>

### Ships List Screen

<img src="https://github.com/user-attachments/assets/87b0eecd-9a7d-47a2-a8a3-f01460525a38" width="265" >
<img src="https://github.com/user-attachments/assets/0cb94f1f-c7a2-4062-a3bb-eb746f53648c" width="265" >
<br><br>

Ships List Screen shows stored locally list of SpaceX ships with their basic information and images. Ships are displyed in a form of alphabetically sorted table. Ship's cell is tapable and will navigate user to the Ship Details Screen. All interaction with ship's cell including deletion and insertion are animated. Navigation Bar of Ships List Screen has two available buttons: Restore ships and Exit/Logout button. Restore ships button allows user to restore all previously deleted ships back to the ships list. Exit/Logout button is displayed depending on user login status Guest/User and returns user to the login screen. In case of Guest status, alert with gratitude for trialing an application will be displayed before returning to Login Screen.
<br><br>

### Ship Details Screen

<img src="https://github.com/user-attachments/assets/ea837123-d666-4d22-98df-9681a19f8565" width="265" >
<img src="https://github.com/user-attachments/assets/c127be00-34b3-4fa9-990d-f3a5c5ae9acf" width="265" >
<br><br>

Ship Details Screen shows selected ship image with detailed information about it: Name, Type, Built Year, Weight in kg, Home Port and Ship's Roles. Ship Details Screen is displayed modally over Ships List Screen and has return button on the Navigation Bar.
<br><br>

### Offline Mode

<img src="https://github.com/user-attachments/assets/eebab2f9-ac6a-49ad-a319-89310eeb113e" width="265" >
<img src="https://github.com/user-attachments/assets/347a41e9-2c26-444c-bd38-68c7d7dc5463" width="265" >
<img src="https://github.com/user-attachments/assets/70dd5649-2a27-4b82-aa09-d7417a0f2d58" width="265" >
<br><br>

If no internet connection is detected, the banner with appropriate message will be displayed to the user below the Navigation Bar. In case of Login Screen, only banner will be displayed, restricting logging process without internet connection.
<br><br>

### Data storing

Information about all ships and user's ships is stored locally on the user device using Core Data. Login credentials are also stored locally using Keychain.  

## Project setup
### Setting initial credentials

<img width="1224" alt="Screenshot 2025-02-26 at 17 14 05" src="https://github.com/user-attachments/assets/627f5cc5-132b-452a-a17f-a3acffef8eaa" />

Setting users initial credentials can be done by calling function setInitialCredentials() inside SceneDelegate class.


## Technologies & Implementation

|      Category       |  Solution   |
|---------------------|:------------|
| Language            | Swift       |
| UI framework        | UIKit       |
| Networking          | URLSession  |
| Multithreading      | GCD         |
| Data persistence    | Core Data, Keychain   |
| Architecture pattern| MVVM        |
| Data Binding        | RxSwift     |

## Contacts

Telegram: @vllmnd

Email: uladzislauklunduk@gmail.com

LinkedIn: www.linkedin.com/in/ulkl
