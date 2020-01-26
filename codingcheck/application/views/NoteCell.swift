//
//  NoteCell.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/23.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var updatedLabel: UILabel!

    func configure(_ diary: Note) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        updatedLabel.text = formatter.string(from: diary.updatedAt)
        contentLabel.text = diary.text
    }

}
