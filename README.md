# suncalc-swift

![Swift CI](https://github.com/THeK3nger/suncalc-swift/workflows/Swift%20CI/badge.svg?event=push)

This is a port for Swift of https://github.com/mourner/suncalc

This code is based on the original Javascript suncalc by Vladimir Agafonkin ("mourner").

This package is based on the [initial porting by Shaun Meredith](https://github.com/shanus/suncalc-swift).

```swift
// get today's sunlight times for London

let date:Date = Date()
let sunCalc:SunCalc = SunCalc.getTimes(date, latitude: 51.5, longitude: -0.1)

var formatter:DateFormatter = DateFormatter()
formatter.dateFormat = "HH:mm"
formatter.timeZone = TimeZone(abbreviation: "GMT")
var sunriseString:String = formatter.string(from: sunCalc.sunrise)
println("sunrise is at \(sunriseString)")

let sunPos:SunPosition = SunCalc.getSunPosition(date, latitude: 51.5, longitude: -0.1)

var sunriseAzimuth:Double = sunPos.azimuth * 180 / Constants.PI()
println("sunrise azimuth: \(sunriseAzimuth)")
```

## Project Philosophy

This project starts as a 1:1 port of the JavaScript's `suncal` but it will not stay like that. While I'll try to maintain as much as external API compatibility, I prefer to adopt a more _Swifty_ approach, especially for the internal functions.
