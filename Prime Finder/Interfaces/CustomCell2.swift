//
//  CustomCell2.swift
//  Prime Finder
//
//  Created by inan on 29.03.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit

class CustomCell2: UITableViewCell {

  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var orderLabel: UILabel!
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
