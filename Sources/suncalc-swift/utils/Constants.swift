//
//  Constants.swift
//  suncalc-example
//
//  Created by Shaun Meredith on 10/2/14.
//

import Foundation

class Constants {
	
	class func RAD() -> Double {
        return Double.pi / 180.0
	}
	
	class func E() -> Double {
		return Constants.RAD() * 23.4397 // obliquity of the earth
	}
	
	class func PI() -> Double {
        return Double.pi
	}
}
