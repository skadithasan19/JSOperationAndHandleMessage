//
//  StatusViewCell.swift
//  JumboProject
//
//  Created by Hasan, MdAdit on 2/20/20.
//  Copyright © 2020 Hasan, MdAdit. All rights reserved.
//

import UIKit

/* This is the cell which display progress of all operations**/
class StatusViewCell: UITableViewCell {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var progressSlider: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let transform = CGAffineTransform(scaleX: 1.0, y: 4.0) // Transforming progressBar Height
        progressSlider.transform = transform
    }
}
