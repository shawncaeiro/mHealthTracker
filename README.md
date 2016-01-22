# mHealthTracker
mHealth Simple App
mHealth Hello World Project – Step Counter
Shawn Caeiro

Project Link : https://github.com/shawncaeiro/mHealthTracker

This iOS application tracks a user’s daily steps and checks to see if the user has reached their step goal (threshold). If they are still working towards their threshold, HELLO is displayed. Once they reach their goal, WORLD is displayed.

This system connects a Parse database and the iPhone’s Pedometer sensor to an iOS app to track, store, and analyze user steps.

The Parse database allows for data to be stored in a cloud database.  In the App_Delegate.swift file, Parse application keys are stored allowing for information from the application to be POSTed to the Parse database. Information is POSTed to the database by serializing information into a Parse object and saving that object in the app background, sending a POST request to the database.

The iPhone pedometer sensor is accessed through the CMPedometer app. Through that class, step count can be sent to an application. The iPhone uses acceleromator sensors to track how many steps a person. The sensors are able to be called through this class, and that information can be analyzed and sent to a databse.
 
The iOS application connects to a Parse database. Data is stored in a table named “healthTracker”. In that data, step count is stored, as well as the start and end time period that step count covers. Every time the Pedometer sensor sends data, the app POSTs the data to the database. Every time the app receives a step data point from the sensor, it checks whether or not that step count is greater than the daily goal/ threshold. Depending on if it is, HELLO or WORLD is displayed. A text field is also provided for if a user wishes to change their daily step goal.

Most of the application code is found in the HealthViewController.swift file. See that file for comments on how the app works.

How to run application

Note!!!! – Project can only be run on a Mac with xCode installed. 

1.	Download github repo.
2.	Open mHealthTracker.xcodeproj
3.	In the top left corner, pick the device you wish to run the app on & click play.
4.	Ensure that the mHealthTracker app is allowed to access “Motion & Fitness” . If it is not, please enable it, fully restart the app (by leaving the app, double clicking home and swiping the app away).
5.	(“Motion & Fitness” access is found in Settings -> mHealthTracker)
