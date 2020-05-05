import Foundation

/// Contains common constants.
///
/// - author: Davide Aversa
struct Constants {
    
    /// Obliquity of the ecliptic computed in the year 2000 expressed in radians.
    public static let E: Double = Constants.RAD * 23.4397
    
    /// Multipling constant to convert Degrees into Radians
    public static let RAD: Double = Double.pi / 180.0
	
}
