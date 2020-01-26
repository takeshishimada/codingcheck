//
//  FuriganaService.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/26.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import Foundation
import RxSwift

class FuriganaService {
    
    static func translate(text: String) -> Observable<String> {
        return FuriganaAPI.translate(text: text).map({ (list) -> String in
            let words = list.words.flatMap { (words) -> [Furigana] in
                var pos = 0
                let r = words.flatMap { (word) -> [Furigana] in
                    var r: [Furigana]
                    if let words = word.sub?.words {
                        r = words.map { (word) -> Furigana in
                            let c = (word.surface ?? "").count
                            let r = Furigana(pos: pos, surface: word.surface ?? "", furigana: word.furigana ?? "")
                            pos = pos + c
                            return r
                        }
                    } else {
                        let c = (word.surface ?? "").count
                        r = [Furigana(pos: pos, surface: word.surface ?? "", furigana: word.furigana ?? "")]
                        pos = pos + c
                    }
                    return r
                }
                return r
            }
            if let words = words {
                var selectedText = text
                words.filter { (word) -> Bool in return word.surface.isKanji }
                    .reversed()
                    .forEach { (furigana) in
                    let startIndex = selectedText.index(selectedText.startIndex, offsetBy: furigana.pos)
                    let endIndex = selectedText.index(selectedText.index(selectedText.startIndex, offsetBy: furigana.pos), offsetBy: furigana.surface.count - 1)
                    let range: ClosedRange = startIndex...endIndex
                    let replaceText = "<ruby>\(furigana.surface)<rt>\(furigana.furigana)</rt></ruby>"
                    selectedText.replaceSubrange(range, with: replaceText)
                }
                return selectedText
            } else {
                return text
            }
        })
    }
}
