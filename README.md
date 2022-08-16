<p align="center">

<img src= "https://user-images.githubusercontent.com/104851148/184946228-803f6e57-4c2e-4689-a84e-eb8671ba1267.gif" width="35%" height="35%"/>


</p>

# RestaurantPickerProject
Personal Project: an app that picks a random restaurant from Yelp API using SwiftUI, Combine Framework, CoreData, and CoreLocation.  
 I used Yelp’s API to pull from their database of thousands of restaurants according to location, rating, and whether they are currently 
open. To decode the data from the API I used the Combine Framework which is Apple’s take on  functional reactive programming. Combine is great when you want to create an app that reacts to a variety of inputs where user events such as text fields or taps on UI 
elements make up the data being streamed. It allows for simpler asynchronous code and multithreading which is extremely useful for 
user interface applications since a lot of their requests are done on the main thread. It allowed me to seamlessly make multiple network calls from different endpoints and customize exactly what data I wanted to pull like reviews, restaurant details, photos, etc. and populate them effectively on all of my views. To find the users current location I used the CoreLocation framework that updates whenever you change locations. With that information I was also able to link Apple Maps so that you could navigate to the restaurant of your choosing. There is also a feature for you to favorite and unfavorite restaurants with just the click of a button. The favorited restaurants are immediately added to a favorites list that you can also randomly choose from. I was able to persist this data by using Core Data.

<p align="center">
<img src="https://user-images.githubusercontent.com/104851148/184946765-45557413-5d70-4d93-a640-e53193a38b5e.gif" width="35%" height="35%"/>
</p>
<p align="center">
<img src="https://user-images.githubusercontent.com/104851148/184688888-59808c6a-689c-4caf-b623-41f6d96513e7.png" width="35%" height="35%"/>
</p>

## Resources:

- https://www.yelp.com/developers/documentation/v3/get_started
- https://developer.apple.com/documentation/coredata
- https://developer.apple.com/documentation/combine
