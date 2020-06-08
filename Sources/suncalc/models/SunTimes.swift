//
//  File.swift
//  
//
//  Created by Davide Aversa on 03/05/2020.
//

import Foundation

public struct SunTimes {
    public var sunrise: Date
    public var sunset: Date
    public var sunriseEnd: Date
    public var sunsetStart: Date
    public var dawn: Date
    public var dusk: Date
    public var nauticalDawn: Date
    public var nauticalDusk: Date
    public var nightEnd: Date
    public var night: Date
    public var goldenHourEnd: Date
    public var goldenHour: Date
    public var solarNoon: Date
    public var nadir: Date
    
    internal static func fromMap(table: [SunTimesEnum: Date]) -> SunTimes {
        return SunTimes(sunrise: table[.sunrise]!,
                        sunset: table[.sunset]!,
                        sunriseEnd: table[.sunriseEnd]!,
                        sunsetStart: table[.sunsetStart]!,
                        dawn: table[.dawn]!,
                        dusk: table[.sunrise]!,
                        nauticalDawn: table[.nauticalDawn]!,
                        nauticalDusk: table[.nauticalDusk]!,
                        nightEnd: table[.nightEnd]!,
                        night: table[.night]!,
                        goldenHourEnd: table[.goldenHourEnd]!,
                        goldenHour: table[.goldenHour]!,
                        solarNoon: table[.solarNoon]!,
                        nadir: table[.nadir]!)
    }
}

public enum SunTimesEnum: String {
    case sunrise = "sunrise"
    case sunset = "sunset"
    case sunriseEnd = "sunriseEnd"
    case sunsetStart = "sunsetStart"
    case dawn = "dawn"
    case dusk = "dusk"
    case nauticalDawn = "nauticalDawn"
    case nauticalDusk = "nauticalDusk"
    case nightEnd = "nightEnd"
    case night = "night"
    case goldenHourEnd = "goldenHourEnd"
    case goldenHour = "goldenHour"
    case solarNoon = "solarNoon"
    case nadir = "nadir"
}
