//
//  reservationCell.swift
//  berber
//
//  Created by Cem Sezeroglu on 12.11.2020.
//

import UIKit

class reservationCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var berberNameLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    
}
