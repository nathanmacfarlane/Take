# Take!
A CSC 436 *(and hopefully senior)* project by Nathan Macfarlane in Spring 2018

## Before you Compile
Please run on an iPhone 7 or 8 (the app hasn't been optimized for any other sizes yet).

## To Begin:
The google login isn't fully configured yet so please follow the instructions below to create an account.

1. Select **Sign Up** next to the *Need and Account?* prompt on the bottom of the screen.
2. Fill in the **Email** and **Password** fields with your desired entities
3. Alternatively, if you have an account, make sure *LOGIN* is displayed on the top and enter your credentials.

## Search Tab
*Information regarding the search tab*

1. Type in the search bar to search for a specific area (like San Luis Obispo) or a route (like Camel)
2. The filter button toggles a container view that allows the user to filter routes.
4. Tap in the cell to segue to the route's information. This information is dynamically populated from Google Firebase and the Mountain Project API.
5. Comments won't be implemented until later this summer. 
6. Select the **Augmented** button to segue to a view that will allow the user to point their phone at the rock and view routes augmented over the camera. 
7. For testing purposes, choose *I AM TESTING* since you won't be near the route. There are no AR diagrams uploaded or queried from firebase yet. So you'll need to add them by chosing the *edit* button and then the plus button next to *AR Diagrams*. Chose edit photo and select and image and then draw on the image. The lines will only be stored locally and aren't persisted on firebase yet but it works for the scope of testing the technology.
8. After saving the diagram, you can select the *Augmented* button again and you should be able to point the camera at the source of the image and it will appear overlayed. 
7. To edit the route, choose the **edit** button at the top.
8. From the edit screen, you can modify any of the information about the route. When you hit the **Save** button, the data is updated in Firebase

## Profile Tab
*Information regarding the profile tab*

Most of the informaton here is hard-coded. I probably won't implement the majority of this tab unless this app becomes my senior project and I have the time to dedicate to it.

Coming soon on this page: 

* A prettier looking chart corresponding to the number of climbs the user has done over the previous months
* A social platform (haven't really thought this one through yet).


## Map Tab
*Information regarding the map tab*

1. To view areas, pan around the map. You'll notice that pins dynamically drop on the map (look at the bishop peak area in SLO). 
2. Tap *Make New Area* and you'll segue to a view where you can pan around the map and long press to create a new region. 
3. After creating a new region, you will be able to select the region and view stats about the area... also coming this summer
