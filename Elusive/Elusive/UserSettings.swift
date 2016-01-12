//
//  UserSettings.swift
//  Elusive
//
//  Created by Christian Hoffmann on 10/31/15.
//  Copyright © 2015 c4605. All rights reserved.
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
