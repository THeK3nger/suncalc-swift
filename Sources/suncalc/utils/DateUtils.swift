//
//  DateUtils.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//

import Foundation

public typealias JulianDate = Double

public class DateUtils {
    
    /// Julian Date for 1970
    static let J1970:JulianDate = 2440588
    
    /// Julian Date for 2000
    static let J2000:JulianDate = 2451545
    
    private static let SECONDS_PER_DAY:TimeInterval = 60 * 60 * 24
	
    /// Convert a `Date` into Julian Date
    /// - parameter date Input date
    /// - returns: the input date expressed as `JulianDate`
	static func toJulian(date:Date) -> JulianDate {
		return (date.timeIntervalSince1970 / SECONDS_PER_DAY) - 0.5 + J1970
	}
	
    /// Convert a `JulianDate` into `Date`
    /// - parameter j Input `JulianDate`
    /// - returns: the input fate expressed as `Date`
	static func fromJulian(j:JulianDate) -> Date {
		let timeInterval = (j + 0.5 - J1970) * SECONDS_PER_DAY
		return Date(timeIntervalSince1970: timeInterval)
	}
	
    /// Returns the number of days since 2000.
    /// - parameter date Input `Date`
    /// - returns: the number of days since 2000
	static func toDays(date:Date) -> Double {
        // TODO: Is this a built in function in Date? Can I avoid an extra call and conversion?
        return DateUtils.toJulian(date: date) - J2000
	}
    
    /// Sum `hours` to `date`
    /// - parameters:
    ///     - date The input `Date`
    ///     - hours The number of hours to add.
    /// - returns: The sum of `date` and `hours` hours.
    static func getHoursLater(date:Date, hours:Double) -> Date? {
        let calendar:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return calendar.date(byAdding: .second, value: Int(hours*60*60), to: date)
    }
}
