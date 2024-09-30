//
//  DateFormatterUtils.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import Foundation

class Utils {    
    // using in hourly view and daily view
    static func formattedDateWithWeekdayAndDay(from timestamp: TimeInterval) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
        }
    
    
    static func dayOfWeek(from timestamp: TimeInterval) -> String? {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"  // "EEE" will give the abbreviated day of the week
        
        return dateFormatter.string(from: date).uppercased()
    }
}
