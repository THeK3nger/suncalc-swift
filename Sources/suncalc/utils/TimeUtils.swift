//
//  TimeUtils.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//

import Foundation

struct TimeUtils {
    
    /// Provides the date and time of a transit of the Sun
    private static let J0:Double = 0.0009
    
    /// Shows by how much the time of transit can vary because of the eccentricity of the orbit.
    private static let J1:Double = 0.0053
    
    /// Indicates how much the time of transit can change because of the obliquity ε of the ecliptic.
    private static let J2:Double = -0.0069 // Why in the reference material is −0.0068?
    
    /// Is the average length of the solar day (from one transit to the next)
    private static let J3:Double = 1.0000
    // Even if it is not used in this implementation. It is 1 by definition.
	
    /// Get the Julian Cycle given Julian Date and Geographical Longitude
    ///
    /// https://aa.quae.nl/en/reken/zonpositie.html
    ///
    /// - parameters
    ///     - d: The Julian Date since 2000.
    ///     - lw: The geographic west longitude.
    /// - returns: The time of Solar Transit on Earth at the given longitude.
	static func getJulianCycle(d:Double, lw:Double) -> Double {
        return round(d - J0 - lw / (2 * Double.pi))
	}
	
    /// Get the approximate transit of the Sun
    ///
    /// - parameters:
    ///     - ht: Hour Angle
    ///     - lw: The geograpgical west longitude
    ///     - n: The Julian Cycle
	static func getApproxTransit(ht:Double, lw:Double, n:Double) -> Double {
        return J0 + (ht + lw) / (2 * Double.pi) + n
	}
	
    /// Return the Solar Transit
    /// - parameters:
    ///     - ds The approximate Transit
    ///     - M: Mean Anomaly
    ///     - L: The Mean Longitude.
    ///
    /// The mean longitude is the ecliptical longitude that the planet would have if the orbit were a perfect circle.
	static func getSolarTransitJ(ds:Double, M:Double, L:Double) -> Double {
        return DateUtils.J2000 + ds + J1 * sin(M) + J2 * sin(2 * L)
	}
	
    /// Compute the Hour Angle.
    ///
    /// The Hour Angle indicates how long ago (measured in sidereal time) the celestial body
    /// passed through the celestial meridian.
    ///
    /// - parameters:
    ///     - h: Object altitude.
    ///     - phi: Geographical Latitude
    ///     - d: The time in Julian Date
    ///
    /// - returns: The Hour Angle
	static func getHourAngle(h:Double, phi:Double, d:Double) -> Double {
		return acos((sin(h) - sin(phi) * sin(d)) / (cos(phi) * cos(d)))
	}
    
    /// Compute the Solar Transit Julian Date
    ///
    /// - parameters:
    ///     - h: Object altitude.
    ///     - lw: Geographical Longitude
    ///     - phi: Geographical Latitude
    ///     - dec:
    ///     - n: Julian Cycle
    ///     - M: Mean Anomaly
    static func getSetJ(h:Double, lw:Double, phi:Double, dec:Double, n:Double, M:Double, L:Double) -> Double {
        let w:Double = TimeUtils.getHourAngle(h: h, phi: phi, d: dec)
        let a:Double = TimeUtils.getApproxTransit(ht: w, lw: lw, n: n  )
        return TimeUtils.getSolarTransitJ(ds: a, M: M, L: L)
    }
    
}
