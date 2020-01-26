//
//  NoteSectionModel.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/23.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import Foundation
import RxDataSources

struct NoteSectionModel<ItemType: IdentifiableType> {
    var header: String
    var items: [ItemType]

    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
    }
}

extension NoteSectionModel: SectionModelType {
    
    typealias Item = ItemType

    init(original: NoteSectionModel<ItemType>, items: [ItemType]) {
        self.header = original.header
        self.items = items
    }
}

