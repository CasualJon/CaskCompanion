//
//  DateHandler.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/4/17.
//  Copyright © 2017 Jon Cyrus. All rights reserved.
//

import UIKit

class DateHandler: NSDate {
    /////////////////////////////////////////////////////////////////////////////////////
    //  Making DateHandler class a Singleton (lol)
    /////////////////////////////////////////////////////////////////////////////////////
    static let shared: DateHandler = DateHandler()
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    
    //  NAME:   getSecondsToStore()
    //  USAGE:  Gets the current date/time and formats them as a Double to store into the db
    //  PARAMS: None
    //  RETURN: Double
    //  BUGS:   None known
    func getSecondsToStore() -> Double {
        let now = Date()
        let seconds = now.timeIntervalSinceReferenceDate
        
        return seconds
    }
    
    
    //  NAME:   getDateFromSeconds()
    //  USAGE:  Takes a Double retrieved from the db and converts it to a date object
    //  PARAMS: seconds: Double
    //  RETURN: Date
    //  BUGS:   None known
    func getDateFromSeconds(seconds: Double) -> Date {
        let swapback = Date(timeIntervalSinceReferenceDate: seconds)
        
        return swapback
    }
    
    
    //  NAME:   convertDateToString()
    //  USAGE:  Takes a Date object and formats it as a string in the local timezone for display
    //  PARAMS: dateVal: Date
    //  RETURN: String
    //  BUGS:   None known
    func convertDateToString(dateVal: Date) -> String {
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: dateVal)
        
        return timeStamp
    }
}
