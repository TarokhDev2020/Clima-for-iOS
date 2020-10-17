//
//  Settings.swift
//  Clima
//
//  Created by Tarokh on 8/6/20.
//  Copyright © 2020 Tarokh. All rights reserved.
//

import Foundation

class GlobalSetting {
    static let shared = GlobalSetting()
    let apikey = "YOUR API KEY HERE"
}

struct Routes {
    static let s = GlobalSetting.shared
    static let baseURL = "http://api.openweathermap.org/data/2.5/weather?appid=\(s.apikey)"
}
