//
//  MoonIllumination.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//

import Foundation

/// Stores the Moon Illumination data according to fraction, phase and angle.
///
/// Returns an object with the following properties:
///
/// Moon phase value should be interpreted like this:
///
/// | Phase | Name            |
/// | -----:| --------------- |
/// | 0     | New Moon        |
/// |       | Waxing Crescent |
/// | 0.25  | First Quarter   |
/// |       | Waxing Gibbous  |
/// | 0.5   | Full Moon       |
/// |       | Waning Gibbous  |
/// | 0.75  | Last Quarter    |
/// |       | Waning Crescent |
///
/// By subtracting the `parallacticAngle` from the `angle` one can get the zenith angle of the moons bright limb (anticlockwise).
/// The zenith angle can be used do draw the moon shape from the observers perspective (e.g. moon lying on its back).
struct MoonIllumination {
    
    /// illuminated fraction of the moon; varies from `0.0` (new moon) to `1.0` (full moon)
	let fraction:Double
    
    /// moon phase; varies from `0.0` to `1.0`, described abow
	let phase:Double
    
    /// midpoint angle in radians of the illuminated limb of the moon reckoned eastward from the north point of the disk;
    /// the moon is waxing if the angle is negative, and waning if positive
	let angle:Double
	
	internal init(fraction:Double, phase:Double, angle:Double) {
		self.fraction = fraction
		self.phase = phase
		self.angle = angle
	}
	
}
