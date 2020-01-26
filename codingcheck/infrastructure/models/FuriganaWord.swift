//
//  FuriganaWord.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/26.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import Foundation
import XMLMapper

class FuriganaWord: XMLMappable {
    var nodeName: String!
    
    var surface: String!
    var furigana: String!
    var roman: String!
    
    var sub: FuriganaSubWordList?

    required init?(map: XMLMap) {}

    func mapping(map: XMLMap) {
        surface <- (map["Surface"], CDATATransformType())
        furigana <- map["Furigana"]
        roman <- map["Roman"]
        sub <- map["SubWordList"]
    }
}

class CDATATransformType: XMLTransformType {
    public typealias Object = String
    public typealias XML = String
    
    public init() {}
    
    open func transformFromXML(_ value: Any?) -> String? {
        // for CDATA
        if let _ = value as? Dictionary<String, Any> {
            return " "
        }
        guard let string = value as? String else {
            return nil
        }
        return string
    }
    
    open func transformToXML(_ value: String?) -> String? {
        guard let data = value else {
            return nil
        }
        return "<![CDATA[ \(data) ]]>"
    }
}
