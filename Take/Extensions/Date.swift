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
        return "\(self.getMonthInt())\(style)\(self.getYearInt())\(style)\(self.getYearInt())"
    }
    func monthDayYear() -> String {
        return "\(self.getMonth()) \(self.getDayInt()), \(self.getYearInt())"
    }
    func instanceString() -> String {
        return "\(self.getYearInt())\(self.getMonthInt())\(self.getDayInt())\(self.getHourInt())\(self.getMinuteInt())\(self.getSecondInt())\(self.getNanoSecondInt())"
    }
    
    // getters
    //strings
    func getMonth() -> String {
        let calendar = Calendar.current
        let months = ["January","Febuary","March","April","May","June","July","August","September","October","November","December"]
        return months[calendar.component(.month, from: self)-1]
    }
    //ints
    func getYearInt() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    func getMonthInt() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)-1
    }
    func getDayInt() -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    func getHourInt() -> Int {
        let calendar = Calendar.current
        return calendar.component(.hour, from: self)
    }
    func getMinuteInt() -> Int {
        let calendar = Calendar.current
        return calendar.component(.minute, from: self)
    }
    func getSecondInt() -> Int {
        let calendar = Calendar.current
        return calendar.component(.second, from: self)
    }
    func getNanoSecondInt() -> Int {
        let calendar = Calendar.current
        return calendar.component(.nanosecond, from: self)
    }
    
    //inits
    init(fromString: String, style: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd\(style)MM\(style)yyyy"
        self = formatter.date(from: fromString)!
    }
}
