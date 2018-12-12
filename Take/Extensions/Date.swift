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
        return "\(self.getInt(type: .month))\(style)\(self.getInt(type: .day))\(style)\(self.getInt(type: .year))"
    }
    func monthDayYear() -> String {
        return "\(self.getMonth()) \(self.getInt(type: .day)), \(self.getInt(type: .year))"
    }
    func monthDayYearHour() -> String {
        return "\(self.getMonth()) \(self.getInt(type: .day)), \(self.getInt(type: .year)), \(self.getInt(type: .hour)):00"
    }
    func instanceString() -> String {
        return "\(self.getInt(type: .year))\(self.getInt(type: .month))\(self.getInt(type: .day))\(self.getInt(type: .hour))\(self.getInt(type: .hour))\(self.getInt(type: .second))\(self.getInt(type: .nanosecond))"
    }

    func getMonth() -> String {
        let calendar = Calendar.current
        let months = ["January", "Febuary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        return months[calendar.component(.month, from: self) - 1]
    }

    func getInt(type: Calendar.Component) -> Int {
        return Calendar.current.component(type, from: self)
    }

    mutating func setYear(to year: Int) {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month, .day, .hour], from: self)
        component.year = year
        guard let newDate = Calendar.current.date(from: component) else { return }
        self = newDate
    }

    //inits
    init?(fromString: String, style: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd\(style)MM\(style)yyyy"
        guard let newDate = formatter.date(from: fromString) else { return nil }
        self = newDate
    }
}
