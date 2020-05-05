//
//  suncalc.swift
//  suncalc
//
//  Created by Shaun Meredith on 10/2/14.
//
//

import Foundation

public final class SunCalc {

    static let times: [(Double, SunTimes, SunTimes)] = [
        (-0.83, .sunrise, .sunset),
        (-0.3, .sunriseEnd, .sunsetStart),
        (-6, .dawn, .dusk),
        (-12, .nauticalDawn, .nauticalDusk),
        (-18, .nightEnd, .night),
        (6, .goldenHourEnd, .goldenHour),
    ]

    class func getSetJ(
        h: Double, phi: Double, dec: Double, lw: Double, n: Double, M: Double, L: Double
    ) -> Double {
        let w: Double = TimeUtils.getHourAngle(h: h, phi: phi, d: dec)
        let a: Double = TimeUtils.getApproxTransit(ht: w, lw: lw, n: n)

        return TimeUtils.getSolarTransitJ(ds: a, M: M, L: L)
    }

    /// Returns all the standard times for the Sun in the give date
    ///
    /// - parameters:
    ///     - date: The target date.
    ///     - latitude: The geographical longitude.
    ///     - longitude: The geographical latitude.
    ///     - observerHeight: The height of the the observer eyes (in meters).
    /// - returns: A dictionary mapping `SunTimes` to `Date` instances.
    public static func getTimes(
        date: Date, latitude: Double, longitude: Double, observerHeight: Double = 0
    ) -> [SunTimes: Date] {
        let lw: Double = Constants.RAD * -longitude
        let phi: Double = Constants.RAD * latitude
        let d: Double = DateUtils.toDays(date: date)

        let n: Double = TimeUtils.getJulianCycle(d: d, lw: lw)
        let ds: Double = TimeUtils.getApproxTransit(ht: 0, lw: lw, n: n)

        let M: Double = SunUtils.getSolarMeanAnomaly(d: ds)
        let L: Double = SunUtils.getEclipticLongitude(M: M)
        let dec: Double = PositionUtils.getDeclination(lambda: L, beta: 0)

        let Jnoon: Double = TimeUtils.getSolarTransitJ(ds: ds, M: M, L: L)

        let deltaH = SunCalc.observerAngle(observerHeight)

        // sun times configuration (angle, morning name, evening name)
        // unrolled the loop working on this data:
        // var times = [
        //             [-0.83, 'sunrise',       'sunset'      ],
        //             [ -0.3, 'sunriseEnd',    'sunsetStart' ],
        //             [   -6, 'dawn',          'dusk'        ],
        //             [  -12, 'nauticalDawn',  'nauticalDusk'],
        //             [  -18, 'nightEnd',      'night'       ],
        //             [    6, 'goldenHourEnd', 'goldenHour'  ]
        //             ];

        var computedTimes: [SunTimes: Date] = [:]
        computedTimes[SunTimes.solarNoon] = DateUtils.fromJulian(j: Jnoon)
        computedTimes[SunTimes.nadir] = DateUtils.fromJulian(j: Jnoon - 0.5)
        for timeVector in SunCalc.times {
            let (h0, morningName, eveningName) = timeVector
            let h = (h0 + deltaH) * Constants.RAD
            let (morningTime, eveningTime) = SunCalc.computeTime(
                JNoon: Jnoon, height: h, phi: phi, lw: lw, declination: dec, julianCycle: n,
                meanAnomaly: M, meanLongitude: L)
            computedTimes[morningName] = morningTime
            computedTimes[eveningName] = eveningTime
        }
        return computedTimes
    }
    private static func computeTime(
        JNoon: Double, height: Double, phi: Double, lw: Double, declination dec: Double,
        julianCycle n: Double, meanAnomaly M: Double, meanLongitude L: Double
    ) -> (morningTime: Date, eveningTime: Date) {
        let JSet = SunCalc.getSetJ(h: height, phi: phi, dec: dec, lw: lw, n: n, M: M, L: L)
        let JRise = JNoon - (JSet - JNoon)
        return (DateUtils.fromJulian(j: JRise), DateUtils.fromJulian(j: JSet))
    }

    class func getSunPosition(timeAndDate: Date, latitude: Double, longitude: Double) -> SunPosition
    {
        let phi: Double = Constants.RAD * latitude
        let d: Double = DateUtils.toDays(date: timeAndDate)

        let c: EquatorialCoordinates = SunUtils.getSunCoords(d: d)
        let H: Double = PositionUtils.getSiderealTime(d: d, longitude: longitude) - c.rightAscension

        return SunPosition(
            azimuth: PositionUtils.getAzimuth(H: H, phi: phi, dec: c.declination),
            altitude: PositionUtils.getAltitude(H: H, phi: phi, dec: c.declination))
    }

    /// Return the position of the Moon in the sky in the current date at the given latitude and longitude.
    ///
    /// - parameters:
    ///     - timeAndDate: The target Date.
    ///     - latitude: The geographical latitude.
    ///     - longitude: The geographical longitude.
    /// - returns: The moon position.
    class func getMoonPosition(timeAndDate: Date, latitude: Double, longitude: Double)
        -> MoonPosition
    {
        
        let phi: Double = Constants.RAD * latitude
        let d: Double = DateUtils.toDays(date: timeAndDate)

        let c: GeocentricCoordinates = MoonUtils.getMoonCoords(d: d)
        let H: Double = PositionUtils.getSiderealTime(d: d, longitude: longitude) - c.rightAscension
        
        // formula 14.1 of "Astronomical Algorithms" 2nd edition by Jean Meeus (Willmann-Bell, Richmond) 1998.
        let pa = atan2(sin(H), tan(phi) * cos(c.declination) - sin(c.declination) * cos(H));

        // altitude correction for refraction
        let h = PositionUtils.getAltitude(H: H, phi: phi, dec: c.declination)
        let hCorrect = h + PositionUtils.getAstroRefraction(h: h)

        return MoonPosition(
            azimuth: PositionUtils.getAzimuth(H: H, phi: phi, dec: c.declination), altitude: hCorrect,
            distance: c.distance, parallaticAngle: pa)
    }

    /// Get the Moon illumination at the given Date
    ///
    /// Calculations for illumination parameters of the moon,
    /// based on http://idlastro.gsfc.nasa.gov/ftp/pro/astro/mphase.pro formulas and
    /// Chapter 48 of "Astronomical Algorithms" 2nd edition by Jean Meeus (Willmann-Bell, Richmond) 1998.
    ///
    /// - parameter timeAndDate: The input Date
    /// - returns: the Moon illumination as fraction, phase and angle.
    class func getMoonIllumination(timeAndDate: Date) -> MoonIllumination {
        let d: Double = DateUtils.toDays(date: timeAndDate)
        let s: EquatorialCoordinates = SunUtils.getSunCoords(d: d)
        let m: GeocentricCoordinates = MoonUtils.getMoonCoords(d: d)

        let sdist: Double = 149_598_000  // distance from Earth to Sun in Km

        let phi: Double = acos(
            sin(s.declination) * sin(m.declination) + cos(s.declination) * cos(m.declination)
                * cos(s.rightAscension - m.rightAscension))
        let inc: Double = atan2(sdist * sin(phi), m.distance - sdist * cos(phi))
        let angle: Double = atan2(
            cos(s.declination) * sin(s.rightAscension - m.rightAscension),
            sin(s.declination) * cos(m.declination) - cos(s.declination) * sin(m.declination)
                * cos(s.rightAscension - m.rightAscension))

        let fraction: Double = (1 + cos(inc)) / 2
        let phase: Double = 0.5 + 0.5 * inc * (angle < 0 ? -1 : 1) / Double.pi

        return MoonIllumination(fraction: fraction, phase: phase, angle: angle)
    }

    /// Return the Moon Times
    ///
    /// - parameters:
    ///     - date: The target `Date`
    ///     - latitude: The geographical latitude.
    ///     - longitude: The geographical longitude.
    /// - returns: An object containing Rise/Set times **or** alwaysUp and alwaysDown.
    class func getMoonTimes(date: Date, latitude: Double, longitude: Double) -> MoonTimes {
        let hc: Double = 0.133 * Constants.RAD
        var h0: Double =
            SunCalc.getMoonPosition(timeAndDate: date, latitude: latitude, longitude: longitude)
            .altitude - hc
        var h1: Double = 0
        var h2: Double = 0
        var rise: Double = 0
        var set: Double = 0
        var a: Double = 0
        var b: Double = 0
        var xe: Double = 0
        var ye: Double = 0
        var d: Double = 0
        var roots: Double = 0
        var x1: Double = 0
        var x2: Double = 0
        var dx: Double = 0

        // go in 2-hour chunks, each time seeing if a 3-point quadratic curve crosses zero (which means rise or set)
        for i in stride(from: 1, through: 24, by: 2) {
            h1 =
                SunCalc.getMoonPosition(
                    timeAndDate: DateUtils.getHoursLater(date: date, hours: Double(i))!,
                    latitude: latitude, longitude: longitude
                ).altitude - hc
            h2 =
                SunCalc.getMoonPosition(
                    timeAndDate: DateUtils.getHoursLater(date: date, hours: Double(i + 1))!,
                    latitude: latitude, longitude: longitude
                ).altitude - hc
            a = (h0 + h2) / 2 - h1
            b = (h2 - h0) / 2
            xe = -b / (2 * a)
            ye = (a * xe + b) * xe + h1
            d = b * b - 4 * a * h1
            roots = 0

            if d >= 0 {
                dx = sqrt(d) / (abs(a) * 2)
                x1 = xe - dx
                x2 = xe + dx
                if (abs(x1) <= 1) { roots += 1 }
                if (abs(x2) <= 1) { roots += 1 }
                if (x1 < -1) { x1 = x2 }
            }

            if roots == 1 {
                if (h0 < 0) { rise = Double(i) + x1 } else { set = Double(i) + x1 }
            } else if (roots == 2) {
                rise = Double(i) + (ye < 0 ? x2 : x1)
                set = Double(i) + (ye < 0 ? x1 : x2)
            }

            if (rise != 0) && (set != 0) { break }
            h0 = h2
        }
        
        if (rise == 0) && (set == 0) {
            return ye > 0 ? .AlwaysUp : .AlwaysDown
        }
        
        return .RiseAndSet(DateUtils.getHoursLater(date: date, hours: rise)!, DateUtils.getHoursLater(date: date, hours: set)!)

    }

    private static func observerAngle(_ height: Double) -> Double {
        return -2.076 * sqrt(height) / 60
    }

}
