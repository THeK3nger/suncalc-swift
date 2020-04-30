//
//  PositionUtils.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//

import Foundation

final class PositionUtils {
	
    /// Compute the Right Ascension given ecliptic latitude and longitude.
    ///
    ///  The right ascension shows how far the body is from the vernal equinox, as measured along the celestial equator,
    ///  and determines (together with other things) when the object is visible.
    ///
    ///  The function takes as input the **geocentric ecliptic latitude and longitude**. The latitude
    ///  indicates how far the oject is from the ecliptic (the apparent path of the sun in the sky). The longitude
    ///  indicates how far the object is from the _vernal equinox_ measured along the eclpitic.
    ///
    /// - parameters:
    ///     - lambda Ecliptic Longitude (λ \[lambda\])
    ///     - beta Ecliptic Latitude (β \[beta\]
    /// - returns: the Right Ascension α \[alpha\]
	static func getRightAscension(lambda l:Double, beta b:Double) -> Double {
		return atan2(sin(l) * cos(Constants.E) - tan(b) * sin(Constants.E), cos(l))
	}
	
    /// Compute Declination given exliptic latitude and longitude.
    ///
    /// The declination shows how far the body is from the celestial equator and determines from which
    /// parts of the Earth the object can be visible.
    ///
    /// - parameters:
    ///     - lambda Ecliptic Longitude (λ \[lambda\])
    ///     - beta Ecliptic Latitude (β \[beta\]
    /// - returns: the Declination δ \[delta\]
	static func getDeclination(lambda l:Double, beta b:Double) -> Double {
		return asin(sin(b) * cos(Constants.E) + cos(b) * sin(Constants.E) * sin(l))
	}
    
    /// Compute the azimuth given its Hour Angle (H), declination and geographical latitude of the observer.
    ///
    /// The Azimuth indicates the direction along the horizon. It is measured in degrees and it is zero on South.
    ///
    /// - parameters:
    ///     - H The Hour Angle
    ///     - phi The geographical latitude of the observer
    ///     - dec The declination of the object.
    /// - returns: The azimuth expressed in radians.
	static func getAzimuth(H:Double, phi:Double, dec:Double) -> Double {
        return atan2(sin(H), cos(H) * sin(phi) - tan(dec) * cos(phi))
	}
	
    /// Compute the altitude of an object given its Hour Angle (H), declination and geographical latitude of the observer..
    ///
    /// The altitude indicates the hieght of the object. The altitude is 0° at the horizon, +90° in the zenith.
    ///
    /// - parameters:
    ///     - H The Hour Angle
    ///     - phi The geographical latitude of the observer
    ///     - dec The declination of the object.
    /// - returns: The altitude expressed in radians.
	static func getAltitude(H:Double, phi:Double, dec:Double) -> Double {
		 return asin(sin(phi) * sin(dec) + cos(phi) * cos(dec) * cos(H))
	}
	
    /// Compute the Sideral Time given the number of days since 2000 and the geographical longitude.
    ///
    /// Where a celestial body appears to be in the sky for you depends on the orientation of the Earth
    /// at your location compared to the stars. This angle is captured in the sidereal time θ (theta).
    /// The sidereal time at a certain moment is equal to the right ascension that transits (
    /// culminates, passes through the celestial meridian) at that moment.
    ///
    /// - parameters:
    ///     - d: The number of days since 2000 Jan 1st.
    ///     - longitude: The geographical longitude of the observer.
	static func getSiderealTime(d:Double, longitude:Double) -> Double {
        /*
         * NOTE:
         * In the original implementation this function takes `lw` as input.
         * `lw` is not the normal longitude! Instead, in the original suncalc
         * implementation, the authors always use `lw  = rad * -lng,` that is:
         * reflected and converted into radians.
         *
         * I do not know why they do that and why they do that "outside" of this
         * function. I decided to break the 1:1 map because I think it is more clear
         * in this way.
         */
        let lw = Constants.RAD * -longitude
        
        // Implementation note. These seems a lot of magic numbers. So that is the
        // explanation:
        // This part -> (280.16 + 360.9856235 * d) is the sidereal time at the prime
        // meridian (i.e., Greenwich). 280.16 is `theta_0`, that is the sidereal time value
        // on JD2000 (the Julian Day of 2000).
        // 360.9856235 is "how much the earth rotate in a mean solar day".
        // The last value is quite stable while the first one is given and I do not know
        // the computation.
		return Constants.RAD * (280.16 + 360.9856235 * d) - lw
	}
    
    /// Compute the effect of the atmospheric rerefraction in the apparent height of an object.
    ///
    /// To find the new height you can write:
    ///
    /// ```
    /// let newH = h + getAstroRefraction(h)
    /// ```
    ///
    /// - parameter h The input altitude of an object in the celestial sphere.
    /// - returns: The difference in apparent height.
    static func getAstroRefraction(h:Double) -> Double {
        // The formula works only for positive altitudes.
        let hCalc = h >= 0 ? h : 0;
        
        // Based on the formula 16.4 of "Astronomical Algorithms" 2nd edition by Jean Meeus (Willmann-Bell, Richmond) 1998.
        // 1.02 / tan(h + 10.26 / (h + 5.10)) h in degrees, result in arc minutes -> converted to rad:
        return 0.0002967 / tan(hCalc + 0.00312536 / (hCalc + 0.08901179));
    }

}
