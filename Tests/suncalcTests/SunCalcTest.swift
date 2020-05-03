//
//  File.swift
//  
//
//  Created by Davide Aversa on 28/04/2020.
//

import Foundation
import XCTest
import suncalc

class SunCalcTest: XCTestCase {
    func testGetTimes() {
        // Check Solar Times in Rome on 2020/04/29
        // We use SunCalc original implementation for reference values.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = TimeZone(abbreviation: "CET")
        let someDateTime = formatter.date(from: "2020/04/29")
        
        let romeLat = 41.89193
        let romeLon = 12.51133
        
        let sunTimes = SunCalc.getTimes(date: someDateTime!, latitude: romeLat, longitude: romeLon)
        
        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "HH:mm"
        outFormatter.timeZone = TimeZone(abbreviation: "CET")
        let sunriseString = outFormatter.string(from: sunTimes[.sunrise]!)
        
        XCTAssertEqual(sunriseString, "06:11", "Incorrect Sunrise Time")
    }
}
