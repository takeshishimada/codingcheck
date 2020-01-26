//
//  FuriganaResult.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/26.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import Foundation
import XMLMapper

class FuriganaResult: XMLMappable {
    var nodeName: String!

    var wordList: FuriganaWordList!

    required init?(map: XMLMap) {}

    func mapping(map: XMLMap) {
        wordList <- map["WordList"]
    }

}

