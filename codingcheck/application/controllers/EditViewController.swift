//
//  DocumentEditViewController.swift
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
import SnapKit
import Alamofire
import MarkdownView

class EditViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var webContainerView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private weak var markdownView: MarkdownView!

    var note: Note?
    
    private let store = NoteStore(store: Store<NoteDetailState>(reducer: NoteDetailReducer.reduce, state: nil))
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textView.inputAccessoryView = self.toolbar

        if let note = note {
            store.dispatch(NoteDetailAction.set(note: note))
        } else {
            store.dispatch(NoteDetailAction.create)
        }
        self.textView.text = store.state.note.text

        let markdownView = MarkdownView()
        self.webContainerView.addSubview(markdownView)
        markdownView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.webContainerView)
        }
        self.markdownView = markdownView
        self.markdownView.load(markdown: self.textView.text, enableImage: true)

        self.textView.rx.text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMap { [unowned self] _ -> Observable<String> in .just(self.textView.text ?? "") }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [unowned self] text in
                self.store.dispatch(NoteDetailAction.update(text: text))
                self.markdownView.load(markdown: text, enableImage: true)
        })
        .disposed(by: disposeBag)

        self.scrollView.rx.didScroll
            .withLatestFrom(scrollView.rx.contentOffset)
            .flatMap({ [unowned self] (i) -> Observable<Int> in
                if(self.scrollView.isTracking || self.scrollView.isDragging || self.scrollView.isDecelerating) {
                    return Observable.just(Int(round(i.x / UIScreen.main.bounds.width)))
                } else {
                    return Observable.empty()
                }
            })
            .bind(to: self.segmentedControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)

        self.segmentedControl.rx.selectedSegmentIndex
            .subscribe({ [unowned self] (e) in
                guard let i = e.element else { return }
                let point = CGPoint(x: CGFloat(i) * UIScreen.main.bounds.width, y: 0)
                self.scrollView.setContentOffset(point, animated: true)
            })
            .disposed(by: disposeBag)

    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}

extension EditViewController {

    func furigana() {

        guard let text = self.textView.text else { return }

        FuriganaAPI.translate(text: text).subscribe(onNext: { (text) in
            print(text)
        }, onError: { (error) in
            print("onError")
        }).disposed(by: disposeBag)

    }
    
}


extension EditViewController {
    
    @IBAction func tapBold(_ sender: Any) {
        textView.insertEnclosureString("**")
    }
    
    @IBAction func tapItalic(_ sender: Any) {
        textView.insertEnclosureString("***")
    }
    
    @IBAction func tapStrikethrough(_ sender: Any) {
        textView.insertEnclosureString("~~")
    }
    
    @IBAction func tapRuby(_ sender: Any) {
        var selectedText = self.textView.selectedText
        FuriganaService.translate(text: selectedText).subscribe({ [unowned self] (event) in
            guard let result = event.element else { return }
            result.reversed().forEach { (furigana) in
                let startIndex = selectedText.index(selectedText.startIndex, offsetBy: furigana.pos)
                let endIndex = selectedText.index(selectedText.index(selectedText.startIndex, offsetBy: furigana.pos), offsetBy: furigana.surface.count - 1)
                let range: ClosedRange = startIndex...endIndex
                let replaceText = "<ruby>\(furigana.surface)<rt>\(furigana.furigana)</rt></ruby>"
                debugPrint(range.description)
                selectedText.replaceSubrange(range, with: replaceText)
            }
            self.textView.insertText(selectedText)
        }).disposed(by: self.disposeBag)
    }

    @IBAction func tapTable(_ sender: Any) {

    }
    
    @IBAction func tapDone(_ sender: Any) {
        self.textView.endEditing(true)
    }

}


