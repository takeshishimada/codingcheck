//
//  FuriganaWordList.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/26.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import Foundation
import XMLMapper

class FuriganaWordList: XMLMappable {
    var nodeName: String!
    
    var words: [FuriganaWord]!

    required init?(map: XMLMap) {}

    func mapping(map: XMLMap) {
        words <- map["Word"]
    }
}

