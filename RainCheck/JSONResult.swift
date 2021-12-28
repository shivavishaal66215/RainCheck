//
//  JSONResult.swift
//  RainCheck
//
//  Created by Vishaal S on 28/12/21.
//

import UIKit

struct JSONResult: Codable{
    var weather: [Weather]
}

struct Weather: Codable{
    var description: String
    var id: Int
    var main: String
}
