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
}

