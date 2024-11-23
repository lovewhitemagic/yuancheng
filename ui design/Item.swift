//
//  Item.swift
//  ui design
//
//  Created by Hui Peng on 2024/11/3.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
