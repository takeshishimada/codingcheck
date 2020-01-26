//
//  NoteRepository.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/25.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import Foundation
import RealmSwift

class NoteRepository {
    
    static let realm = try! Realm()
    
    static func findAll() -> Results<Note> {
        let diaries = realm.objects(Note.self).sorted(byKeyPath: "updatedAt", ascending: false)
        return diaries
    }

    static func add(note: Note) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(note)
        try! realm.commitWrite()
    }

    static func update(text: String, note: Note) {
        let realm = try! Realm()
        realm.beginWrite()
        note.text = text
        note.updatedAt = Date()
        try! realm.commitWrite()
    }
    
    static func delete(note: Note) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.delete(note)
        try! realm.commitWrite()
    }

}
