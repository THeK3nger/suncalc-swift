//
//  SunUtils.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//

import Foundation

class SunUtils {
	
    /// Compute Solar Mean Anomaly
    ///
    /// This is actually the Earth Mean Anomaly. But it is handy to assume it is the Solar Mean Anomaly
    /// if we assume that the Sun orbits the Earth (yes, I know).
    ///
    /// - parameter d The number of decimal days since 2000.
    /// - returns: The Solar Mean Anomaly at the time.
	class func getSolarMeanAnomaly(d:Double) -> Double {
        // The first number (357...) is the Mean Anomaly at time zero (here, 2000).
        //
        // The second number is the angle traversed by the plane as seen from the Sun
        // (or, equivalent, the angle traversed by the Sun as seen from the planet.
        //
        // n = \frac{0.9856076686°}{a^{3/2}}
        //
        // Where `a` is the semiaxis major measured in Astronomical Units.
        // So a = 1 for the Earth (by definition).
		return Constants.RAD * (357.5291 + 0.98560028 * d)
	}
	
    /// Compute the Equation of Center of an object given its Solar Mean Anomaly.
    ///
    /// The [Equation of Center](https://en.wikipedia.org/wiki/Equation_of_the_center) represents
    /// the angular difference between the actual position of a body in its elliptical orbit and the position it would
    /// occupy if its motion were uniform, in a circular orbit of the same period.
    ///
    /// It is usually defined as the difference between the the True Anomaly and the Mean Anomaly.
    ///
    /// The values comes from here: https://aa.quae.nl/en/reken/zonpositie.html
    ///
    /// - parameter M: The Mean Anomaly of the Earth
    /// - returns: The Equation of Center for planet Earth.
	class func getEquationOfCenter(M:Double) -> Double {
        // The hardcoded values depend on the eccentricity value for the Earth.
        // I was not able to double-check these values. For now, I assume
        // they are correct.
        let firstFactor = 1.9148 * sin(M)
        let secondFactor = 0.02 * sin(2 * M)
        let thirdFactor = 0.0003 * sin(3 * M)
		return Constants.RAD * (firstFactor + secondFactor + thirdFactor)
	}
	
    /// Compute the Ecliptic Longitude of the Sun as seen from the Planet.
    ///
    /// As usual, we compute the ecliptic longitude of the planet as seen from the Sun
    /// and then we rotate it by 180°.
    ///
    /// - parameter M: The Solar Mean Anomaly
    /// - returns: The Ecliptic Longitude for the Sun as seen from the Earth.
	class func getEclipticLongitude(M:Double) -> Double {
        let C:Double = SunUtils.getEquationOfCenter(M:M)
		let P:Double = Constants.RAD * 102.9372 // Perihelion of the Earth
        /// Equivalent to True Anomaly + P + Double.pi
        return M + C + P + Double.pi
	}
	
    /// Get the Equatorial Coordinates at the given time.
    ///
    /// - parameter d: The Julian Days since 2000.
    /// - returns: The Equatorial Coordinates of the Sun.
	class func getSunCoords(d:Double) -> EquatorialCoordinates {
        let M:Double = SunUtils.getSolarMeanAnomaly(d:d)
        let L:Double = SunUtils.getEclipticLongitude(M:M)
		
        return EquatorialCoordinates(rightAscension: PositionUtils.getRightAscension(lambda: L, beta: 0), declination: PositionUtils.getDeclination(lambda: L, beta: 0))
	}
}
