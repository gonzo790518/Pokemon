//
//  Extension.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/6/2.
//

import Foundation

extension Notification.Name {
    static let favoriteChanged = Notification.Name("favoriteChanged")
}

extension Locale {
    static var preferredLanguageNScripCodes: [String] {
        Locale.preferredLanguages.compactMap {
            if let scriptCode = Locale(identifier: $0).scriptCode,
               let languageCode = Locale(identifier: $0).languageCode {
                return languageCode + "-" + scriptCode
            }
            return Locale(identifier: $0).languageCode
        }
    }
}
