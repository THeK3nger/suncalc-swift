# suncalc-swift

![Swift CI](https://github.com/THeK3nger/suncalc-swift/workflows/Swift%20CI/badge.svg?event=push)

This is a port for Swift of https://github.com/mourner/suncalc

This code is based on the original Javascript suncalc by Vladimir Agafonkin ("mourner").

This package is based on the [initial porting by Shaun Meredith](https://github.com/shanus/suncalc-swift).

```swift
// We use SunCalc original implementation for reference values.
let formatter = DateFormatter()
formatter.dateFormat = "yyyy/MM/dd"
let someDateTime = formatter.date(from: "2020/04/29")

let romeLat = 41.89193
let romeLon = 12.51133

let sunTimes = SunCalc.getTimes(date: someDateTime!, latitude: romeLat, longitude: romeLon)

let outFormatter = DateFormatter()
outFormatter.dateFormat = "HH:mm"
outFormatter.timeZone = TimeZone(abbreviation: "CET")
let sunriseString = outFormatter.string(from: sunTimes[.sunrise]!)

XCTAssertEqual(sunriseString, "06:11", "Incorrect title")
```

## Project Philosophy

This project starts as a 1:1 port of the JavaScript's `suncalcb` but it will not stay like that. While I'll try to maintain as much as external API compatibility, I prefer to adopt a more _Swifty_ approach, especially for the internal functions.
