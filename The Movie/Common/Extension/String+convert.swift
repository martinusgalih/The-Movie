//
//  String+convert.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import Foundation

extension String {
    func convertMinutesToString() -> String {
        guard let minutes = Int(self) else {
            return ""
        }
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        var result = ""
        
        if hours > 0 {
            result += "\(hours) h "
        }
        
        if remainingMinutes > 0 {
            result += "\(remainingMinutes) m"
        }
        return result.isEmpty ? "0 m" : result
    }
    
    func extractYear() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            return "\(year)"
        } else {
            return nil
        }
    }
}
