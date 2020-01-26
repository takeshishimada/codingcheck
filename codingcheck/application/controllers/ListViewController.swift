//
//  DocumentListViewController.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/21.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import RxDataSources
import RealmSwift

class ListViewController: UIViewController {

    @IBOutlet private weak var diaryListView: UITableView!
    @IBOutlet private weak var addDiaryButton: UIBarButtonItem!

    private let store = NoteStore(store: Store<NoteState>(reducer: NoteReducer.reduce, state: nil))
    
    private let disposeBag = DisposeBag()
    
    private let dataSource = RxTableViewSectionedReloadDataSource<NoteSectionModel<Note>>(configureCell: { (_, tableView, indexPath, result) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        cell.configure(result)
        return cell
    }, canEditRowAtIndexPath: { _, _ in
        return true
    })

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store.dispatch(NoteAction.reload)
    }

    private func bind() {

        store.sectionModel
            .bind(to: diaryListView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        diaryListView.rx.itemDeleted
            .subscribe({ [unowned self] event in
                guard let indexPath = event.element else { return }
                self.store.dispatch(NoteAction.delete(note: self.dataSource.sectionModels[indexPath.section].items[indexPath.item]))
            })
            .disposed(by: disposeBag)

        diaryListView.rx.itemSelected
            .subscribe({ [unowned self] event in
                guard let indexPath = event.element else { return }
                self.performSegue(withIdentifier: "UpdateNoteSegue", sender: self.dataSource.sectionModels[indexPath.section].items[indexPath.item])
            })
            .disposed(by: disposeBag)

        diaryListView.rx.setDelegate(self).disposed(by: disposeBag)

        addDiaryButton.rx.tap
            .subscribe({ [unowned self] _ in
                self.performSegue(withIdentifier: "CreateNoteSegue", sender: nil)
            })
            .disposed(by: disposeBag)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? EditViewController else { return }
        if segue.identifier == "CreateNoteSegue" {
            vc.note = nil
        } else if segue.identifier == "UpdateNoteSegue" {
            guard let note = sender as? Note else { return }
            vc.note = note
        }
    }


}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
}
