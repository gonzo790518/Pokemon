//
//  General.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/6/2.
//

import Foundation

class General {
    static let shared = General()

    func formatNumber(_ number: Int) -> String {
        
        return String(format: "%04d", number)
    }
    
    func extractID(keyword: String, from urlString: String) -> String? {
        
        let pattern = "/\(keyword)/(\\d+)/"
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsString = urlString as NSString
            let results = regex.matches(in: urlString, range: NSRange(location: 0, length: nsString.length))
            
            if let match = results.first {
                let range = match.range(at: 1)
                return nsString.substring(with: range)
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
        }
        
        return nil
    }
}

