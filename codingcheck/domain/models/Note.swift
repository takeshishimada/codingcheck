//
//  DailyItem.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/23.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class Note: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var date = Date()
    @objc dynamic var text = ""
    @objc dynamic var createdAt = Date()
    @objc dynamic var updatedAt = Date()

    override static func primaryKey() -> String? {
        return "id"
    }
    
}

extension Note: IdentifiableType {
    typealias Identity = String

    var identity: String {
        return id
    }
}
