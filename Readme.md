# Take!
A CSC 436 *(and hopefully senior)* project by Nathan Macfarlane in Spring 2018

## Before you Compile
Please run on an iPhone 7 or 8 (the app hasn't been optimized for any other sizes yet).

## To Begin:
The google login isn't fully configured yet so please follow the instructions below to create an account.

1. Select **Sign Up** next to the *Need and Account?* prompt on the bottom of the screen.
2. Fill in the **Email** and **Password** fields with your desired entities

## Search Tab
*Information regarding the first tab*

1. Several routes should be automatically queried from Google Firebase on load. When you select the search field and hit **Search** from the keyboard, data from the **Mountain Project API** is printed in the console. (For now just local routes to SLO.)
2. The filter button toggles a container view that allows the user to filter routes. *(This filter button and the search field don't currently working with the Firebase Data.)*
3. Tap on the **image on the left** with the area label overlay to view information about the routes surrounding area *(as of yet, this is just non-accurate, static data...)*
4. Tap **anywhere else in the cell** to segue to the route's information. This information is dynamically populated from Google Firebase.
5. I think the comments button is broken :(
6. Select the **Augmented** button to segue to a view that *will* allow the user to point their phone at the rock and view routes augmented over the camera.
7. To edit the route, choose the **edit** button at the top.
8. From the edit screen, you can modify any of the information about the route. When you hit the **Save** button, the data is updated in Firebase

## Profile Tab
*Information regarding the second tab*

Most of the informaton here is hard-coded. I probably won't implement the majority of this tab unless this app becomes my senior project and I have the time to dedicate to it.

1. Tap to toggle between **Ticks, Favorites, and To-Dos**.
2. **Swipe to delete** a route *(or tick)* from the user's favorites.
3. **Tap a route** in any of the previously mentioned categories to segue to the **route detail**.

Coming soon on this page: 

* A prettier looking chart corresponding to the number of climbs the user has done over the previous months
* A social platform (haven't really thought this one through yet).


## Map Tab
*Information regarding the third tab*

This tab is not completed. 