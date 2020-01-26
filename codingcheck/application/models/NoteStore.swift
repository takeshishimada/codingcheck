//
//  NoteStore.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/25.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift
import RxCocoa

class NoteStore<AnyStateType>: StoreSubscriber where AnyStateType: StateType {

    private let store: Store<AnyStateType>
    private let stateRelay: BehaviorRelay<AnyStateType>

    var state: AnyStateType { return stateRelay.value }
    lazy var stateObservable: Observable<AnyStateType> = {
        return self.stateRelay.asObservable()
    }()

    init(store: Store<AnyStateType>) {
        self.store = store
        self.stateRelay = BehaviorRelay(value: store.state)
        self.store.subscribe(self)
    }

    deinit {
        self.store.unsubscribe(self)
    }

    func newState(state: AnyStateType) {
        stateRelay.accept(state)
    }

    func dispatch(_ action: Action) {
        store.dispatch(action)
    }

}

extension NoteStore where AnyStateType == NoteState {
    // stateのsectionModelをObservableに変更
    var sectionModel: Observable<[NoteSectionModel<Note>]> {
        return stateObservable.map({ $0.sectionModel })
    }
}
