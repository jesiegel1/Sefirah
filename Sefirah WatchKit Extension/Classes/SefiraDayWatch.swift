//
//  SefiraDayWatch.swift
//  Sefirah
//
//  Created by Josh Siegel on 4/28/16.
//  Copyright © 2016 Josh Siegel. All rights reserved.
//

import Foundation
import CoreLocation
import KosherCocoa
import ClockKit
import WatchKit

class SefiraDayWatch: NSObject {
    static let sharedInstance = SefiraDayWatch()
    
    var sefiraDate: Int? {
        didSet {
            if oldValue != self.sefiraDate {
                let complicationServer = CLKComplicationServer.sharedInstance()
                if let activeComplications = complicationServer.activeComplications {
                    for complication in activeComplications {
                        complicationServer.reloadTimeline(for: complication)
                    }
                }
            }
        }
    }
    var tzeis: Date?
    var lastRecordedLocation: KCGeoLocation?
    var lastRecordedCLLocation: CLLocationCoordinate2D?
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    func getLocation() -> Bool {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        //locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                locationManager.requestLocation()
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func setAdjustedSefiraDay(_ location: CLLocationCoordinate2D) {
        let locationKC = KCGeoLocation(latitude: location.latitude, andLongitude: location.longitude, andTimeZone: TimeZone.autoupdatingCurrent)
        
        self.lastRecordedCLLocation = location
        let jewishCalendar = KCJewishCalendar(location: locationKC)
        self.tzeis = jewishCalendar?.tzais()
        self.lastRecordedLocation = locationKC
    
        self.sefiraDate = self.workingDateAdjustedForSunset(tzeis!)
        UserDefaults.standard.set(self.sefiraDate!, forKey: "LastRecordedDay")
        
    }
    
    class func getTzeis(_ location: CLLocationCoordinate2D) -> Date {
        let KClocation = KCGeoLocation(latitude: location.latitude, andLongitude: location.longitude, andTimeZone: TimeZone.autoupdatingCurrent)
        let jewishCalendar = KCJewishCalendar(location: KClocation)
        return jewishCalendar!.tzais()
    }
    
    func workingDateAdjustedForSunset(_ sunset: Date) -> Int {
        
        let isAfterSunset = sunset.timeIntervalSinceNow < 0
        
        var sefiraCount: Int?
        if (isAfterSunset) {
            sefiraCount = KCSefiratHaomerCalculator.dayOfSefira() + 1
        } else {
            sefiraCount = KCSefiratHaomerCalculator.dayOfSefira()
        }
        
        return sefiraCount!
    }
    
}
