//
//  NoteAction.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/25.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import ReSwift

enum NoteAction: Action {
    case reload
    case delete(note: Note)
}

enum NoteDetailAction: Action {
    case create
    case set(note: Note)
    case update(text: String)
}
