//
//  CustomCell1.swift
//  Prime Finder
//
//  Created by inan on 29.03.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class CustomCell1: UITableViewCell {

  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
    
        self.backgroundColor = .clear
        self.layoutMargins = .zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
