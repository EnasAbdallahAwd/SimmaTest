//
//  OffsetTimeHndler.swift

import Foundation
class OffsetTimeHndler: NSObject {
    
    
    class func getDaylightSavingTimeOffset() -> Int {
        // Get the current date and time
        let currentDate = Date()

        // Get the offset time stamp
        let offsetTimeStamp = currentDate.timeIntervalSince1970

        // Get the current time zone
        let timeZone = TimeZone.current

        // Get the GMT offset in seconds for the current date
        let gmtOffset = Int(timeZone.secondsFromGMT(for: currentDate))

        // Get the DST offset in seconds for the current date (0 if DST is not in effect)
        let dstOffset = Int(timeZone.daylightSavingTimeOffset(for: currentDate))

        // Calculate the total time offset as the sum of GMT offset and DST offset
        let totalOffset = gmtOffset + dstOffset

//        // Subtract 2 hours (2 * 3600 seconds) from the total offset
//        totalOffset -= 2 * 3600

        // Print the total offset and offsetTimeStamp (seconds since 1970)
        print(totalOffset, offsetTimeStamp)

        // Return the totalOffset as an Int
        return gmtOffset
    }
}
