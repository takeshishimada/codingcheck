//
//  NoteReducer.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/25.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import Foundation
import ReSwift
import RealmSwift

struct NoteReducer {
    static func reduce(_ action: Action, state: NoteState?) -> NoteState {
        var state = state ?? NoteState()
        guard let action = action as? NoteAction else { return state }
        switch action {
        case .reload: break
        case .delete(let note):
            NoteRepository.delete(note: note)
        }
        let diaries =  NoteRepository.findAll()
        state.sectionModel = [NoteSectionModel(header: "header", items: diaries.map({ $0 }))]
        return state
    }
}

struct NoteDetailReducer {
    static func reduce(_ action: Action, state: NoteDetailState?) -> NoteDetailState {
        var state = state ?? NoteDetailState()
        guard let action = action as? NoteDetailAction else { return state }
        switch action {
        case .create:
            state.note.text = """
            # VR-Studies

            VR Studiesは、株式会社ゆめみにて作成した、VRプログラミングの基礎を学ぶためのサンプルプログラム集です。
            これらのプログラムを通して、Unityを使用したVRアプリ開発の基本を学ぶことができます。

            この教材は、Unityの使い方を理解しているエンジニアであれば1週間、Unityに慣れていないエンジニアでも2〜3週間程度で基本部分を終えられるようになっています。（Unity自体の使い方については、この教材には含まれておりません。）


            > 講義の詳細はWikiページを参照してください
            > [VRStudies-Wiki](https://github.com/yumemi-inc/vr-studies/wiki) / [VRStudies-LP](https://www.yumemi.co.jp/vrstudies/)

            <img src="https://www.yumemi.co.jp/vrstudies/img/logo.png" width="100%">

            """
            NoteRepository.add(note: state.note)
        case .set(let note):
            state.note = note
        case .update(let text):
            NoteRepository.update(text: text, note: state.note)
        }
        return state
    }
}
