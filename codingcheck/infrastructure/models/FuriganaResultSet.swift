//
//  FuriganaResultSet.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/26.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import Foundation
import XMLMapper

class FuriganaResultSet: XMLMappable {
    var nodeName: String!

    var result: FuriganaResult!

    required init?(map: XMLMap) {}

    func mapping(map: XMLMap) {
        result <- map["Result"]
    }

}
