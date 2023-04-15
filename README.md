# HelpCAR - Ride to Wellness

## Project Description

HelpCAR is a mobile application designed to provide medical transport assistance to people living in rural and remote areas. The app connects volunteer helpers with patients who need assistance in getting to medical facilities. HelpCAR uses advanced algorithms and Google Maps SDK to efficiently match helpers with patients based on their location and travel details. Additionally, the app offers a carpooling feature for urban and semi-urban users, reducing environmental impact while promoting community building.

The problem HelpCAR addresses is the lack of accessible and affordable transportation in rural and remote areas, which can lead to delayed or missed medical appointments and lower chances of survival for patients. HelpCAR aims to bridge this gap by leveraging technology to connect helpers and patients efficiently and quickly.

Our application allows volunteer drivers to add their travel details, including their source, destination, and time of travel, and also allows patients to search for active helpers in their area. The app's algorithm matches patients with the closest volunteer driver, ensuring timely access to medical facilities. The user-friendly and accessible nature of the app makes it easy for both helpers and patients to use, promoting volunteerism and community building while improving access to medical care.

HelpCAR was developed using modern technologies such as Firebase Real Time Database, Google Maps SDK, and a Virtual Machine running on Google Cloud Servers powered by an AMD EPYC Chip. These technologies were chosen for their reliability, scalability, and ability to handle real-time data.

Overall, HelpCAR aims to make a tangible impact in the lives of people in need by promoting volunteerism, community building, and improving access to medical care. With the potential to expand to other underserved areas and offer more services in the future, HelpCAR has the potential to significantly improve the lives of those who need it most.

## Proposed Solution

HelpCAR is designed to be user-friendly, accessible, and community-driven. It offers a range of features that make it easy for volunteer helpers to connect with patients who need medical transportation in rural and remote areas. Here are some of the key features that our app offers:

### Registration and Login

Upon launching the app, users can either log in if they already have an account or register if they are new to the app. Our registration process is quick and easy, so you can start using the app in no time.

### Volunteer Helpers

The volunteer helpers feature is a great way for users to offer their help to those in need of medical transportation in rural and countryside areas. To get started, users simply need to add their travel details, including the source of their journey, destination, and the time they plan to travel. This way, people who need medical transportation can easily search for active helpers in their area.

One of the great things about this feature is that helpers have the flexibility to change or delete their travel details at any time before or during the journey. This means that helpers can easily adjust their travel plans to accommodate any unforeseen circumstances or last-minute changes.

### Help Seeker

The Help Seeker feature is a simple yet effective way for individuals in need of medical transport assistance to connect with available volunteer helpers. Users can enter their destination and search for any active helpers in their area.

The app's algorithm performs a swift search for active helpers within the user's area and matches them with the closest volunteer available. Once a match is made, the contact details of both parties are exchanged, allowing for easy communication and coordination of transport services.

### Carpooling

Users in urban and semi-urban areas can also use these features to carpool with others, which not only reduces traffic congestion and air pollution but also helps in conserving fuel. This positive impact on the environment can benefit everyone in the community.

### Technologies Used

We have implemented this feature using the Google Maps SDK and Firebase Real-Time Database. The algorithm runs on a Virtual Machine on Google Cloud Servers powered by an AMD EPYC Chip. These modern and reliable technologies ensure that our app is efficient, scalable, and can handle real-time data.

By promoting volunteerism, community building, and improving access to medical care, HelpCAR is making a tangible impact in the lives of people in need. It is a user-friendly and accessible solution to a pressing societal problem, and we hope to continue making a positive impact in the future.

## Tech Stacks and Tools

1. Flutter
2. Google Maps SDK
3. Google Cloud
4. AMD Virtual Machine
5. Firebase Authentication and Real Time Database
6. GitHub

## Challenges Faced

1. Developing the algorithm for matching users with suitable helpers.
2. Real-time data handling.
3. Running the app on an AMD Virtual Machine.

## How to install and run the project?

Step 1 :
Clone the repository to your local machine:
```
git clone https://github.com/soumeshmohanty0220/helpcar.git
```

Step 2 :
Make sure you have Flutter installed on your machine. You can download it from the official Flutter website: 
```
https://flutter.dev/docs/get-started/install
```
Step 3 :
Open the project in your preferred editor.

Step 4 : 
Run the following command in your terminal to download the required packages:
```
flutter pub get 
```

Step 5 :
Connect your device or start an emulator.If you are using an android emulator please make sure you are using the emulator which has Google Play Sevices available in it. Otherwise if you are using your device, please ensure to turn ON USB debugging mode.

Step 6 :
Run the following command to build and launch the app:
```
flutter run
```
