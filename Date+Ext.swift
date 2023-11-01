//
//  Date+Ext.swift
//  BeHealthly
//
//  Created by Jason Dubon on 11/1/23.
//

import Foundation

extension Date {
    
    static var startOfDay: Date {
        return Calendar.current.startOfDay(for: .now)
    }
    
    static var startOfWeek: Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // Sunday as the first day of the week, change it if needed
        
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date.now)
        components.weekday = calendar.firstWeekday
        
        return calendar.date(from: components) ?? .now
    }
}
