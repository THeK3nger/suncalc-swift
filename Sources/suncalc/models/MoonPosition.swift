//
//  MoonPosition.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//

import Foundation

struct MoonPosition {
	let azimuth:Double
	let altitude:Double
	let distance:Double
    let parallaticAngle:Double
	
    internal init(azimuth: Double, altitude: Double, distance: Double, parallaticAngle: Double) {
        self.azimuth = azimuth
        self.altitude = altitude
        self.distance = distance
        self.parallaticAngle = parallaticAngle
    }
}
