//
//  eventModel.swift
//  getFun
//
//  Created by Jia Wang on 7/20/16.
//  Copyright © 2016 Jia Wang. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class eventModel {
    
  
    
    static func getEvent(lat: String, lng: String, distance: String,
                         eventDate: String, eventCategory: String,
                         completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        
        // switch parameters to vaiid inputs
        // let pickerData = [["Today", "This Week", "This weekend", "This Month"],
        //["music","music-festivals","comedy","family_fun_kids","performing_arts","attractions","sports","science"]]
        var eventdate = ""
        var category = ""
        
        switch (eventDate){
        case "This Week":
            eventdate = "This%20Week"
        case "This Weekend":
            eventdate = "This%20Weekend"
        case "This Month":
            eventdate = "This%20Month"
        default:
           eventdate = "Today"
        }
        
        switch (eventCategory){
        case "Night Life":
            category = "singles_social"
        case "Music":
             category = "music"
        case "Music Festivals":
            category = "music-festivals"
        case "Comedy":
            category = "comedy"
        case "Family":
            category = "family_fun_kids"
        case "Performing Arts":
            category = "performing_arts"
        case "Museums":
            category = "attractions"
        case "Sports":
            category = "sports"
        case "Science":
            category = "science"
        default:
            category = "art"
        }
        
        let lati = lat
        let lngt = lng
        let dist = distance
        
        
        //This%20Week
        
        print("eventMode.getEvent")
        print(lati, lngt)
        print("distance: \(dist)")
        print(eventdate)
        print(category)
        // Specify the url that we will be sending the GET Request to
        let url = NSURL(string: "http://api.eventful.com/json/events/search?app_key=2gS7597vgV7hhSL8&within=\(dist)&category=\(category)&date=\(eventdate)&where=\(lati),\(lngt)&sort_order=popularity")
        print("*********** printing API request URL ****************")
        print(url)
        // Create an NSURLSession to handle the request tasks
        let session = NSURLSession.sharedSession()
        
        // Create a "data task" which will request some data from a URL and then run the completion handler that we are passing into the getAllPeople function itself
        let task = session.dataTaskWithURL(url!, completionHandler: completionHandler)
        
        // Actually "execute" the task. This is the line that actually makes the request that we set up above
        task.resume()
    }
}