//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by Kathleen Garrity on 3/23/20.
//  Copyright © 2020 Kathleen Garrity. All rights reserved.
//

import Foundation

class WeatherDetail: WeatherLocation {
    
    struct Result: Codable {
        var timezone: String
        var currently: Currently
        var daily: Daily
    }
    
    struct Currently: Codable {
        var temperature: Double
        var time: TimeInterval
    }
    
    struct Daily: Codable {
        var summary: String
        var icon: String
        
    }
    
    var timezone = ""
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dailyIcon = ""
    
    
    func getData(completed: @escaping () -> () ) {
        let coordinates = "\(latitude),\(longitude)"
        let urlString = "\(APIUrls.darkSkyURL)\(APIkeys.darkSkyKey)/\(coordinates)"
        
        print("🕸 We are accessing the URL \(urlString)")
        
        // Create a URL
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            completed()
    
            return
        }
        
        // Create session
        let session = URLSession.shared
        
        // Get data with .dataTask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription)")
            }
            
            do {
                let result = try JSONDecoder().decode(Result.self, from: data!)
                self.timezone = result.timezone
                self.currentTime = result.currently.time
                self.temperature = Int(result.currently.temperature.rounded())
                self.summary = result.daily.summary
                self.dailyIcon = result.daily.icon
                
                
            } catch {
                print("😡 JSON ERROR: \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
}
