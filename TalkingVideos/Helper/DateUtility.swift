//
//  DateUtility.swift
//  Bluelight
//
//  Created by Nisha Gupta on 20/05/24.
//

import UIKit

class DateUtility
{
    static let shared = DateUtility()
    
    private let inputDateFormatter: DateFormatter
    private let outputDateFormatter: DateFormatter
    
    private init() {
        // Input formatter to parse the given date string
        inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Output formatter to convert date to desired format
        outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        outputDateFormatter.locale = Locale.current
    }
    
    func convertToReadableFormat(dateString: String) -> String? {
        guard let date = inputDateFormatter.date(from: dateString) else {
            return nil
        }
        return outputDateFormatter.string(from: date)
    }
}
