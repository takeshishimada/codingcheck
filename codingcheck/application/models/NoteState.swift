//
//  NoteState.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/25.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import RealmSwift
import ReSwift
import RxDataSources

struct NoteState: StateType {
    var sectionModel: [NoteSectionModel<Note>] = []
}

struct NoteDetailState: StateType {
    var note = Note()
}
