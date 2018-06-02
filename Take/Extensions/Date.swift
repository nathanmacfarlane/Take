//
//  Date.swift
//  Take
//
//  Created by Family on 5/23/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation

extension Date {
    
    // formatters
    func monthDayYear(style: String) -> String {
        return "\(self.getMonthInt())\(style)\(self.getDay())\(style)\(self.getYear())"
    }
    func monthDayYear() -> String {
        return "\(self.getMonth()) \(self.getDay()), \(self.getYear())"
    }
    
    // getters
    func getYear() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    func getMonth() -> String {
        let calendar = Calendar.current
        let months = ["January","Febuary","March","April","May","June","July","August","September","October","November","December"]
        return months[calendar.component(.month, from: self)-1]
    }
    func getMonthInt() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)-1
    }
    func getDay() -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    
    init(fromString: String, style: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd\(style)MM\(style)yyyy"
        self = formatter.date(from: fromString)!
    }
}
