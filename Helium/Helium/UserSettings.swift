//
//  UserSettings.swift
//  Helium
//
//  Created by Christian Hoffmann on 10/31/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import Foundation

public enum UserSetting {
    case DisabledFullScreenFloat

    var userDefaultsKey: String {
        switch self {
        case .DisabledFullScreenFloat: return "disabledFullScreenFloat"
        }
    }
}
