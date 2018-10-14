//
//  Cell.swift
//  DropBall
//
//  Created by Vinitha Vijayan on 2/6/18.
//  Copyright © 2018 Vinitha Vijayan. All rights reserved.
//

import Foundation
import UIKit

class Cell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(data: Int, row: Int) {
        if data == 0 {
            self.backgroundColor = UIColor.clear
            label.text = ""
        } else {
            self.backgroundColor = UIColor.lightGray
            label.text = String(data)
        }
    }
}
