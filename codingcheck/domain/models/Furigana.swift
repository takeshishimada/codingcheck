//
//  Furigana.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/26.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import Foundation

class Furigana {
    var pos: Int
    var surface: String
    var furigana: String
    
    init(pos: Int, surface: String, furigana: String) {
        self.pos = pos
        self.surface = surface
        self.furigana = furigana
    }
}
