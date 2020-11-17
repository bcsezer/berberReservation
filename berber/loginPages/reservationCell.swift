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
    fileprivate let application = UIApplication.shared
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func phoneButtonClicked(_ sender: UIButton) {
        
        if let phoneUrl = URL(string: sender.titleLabel?.text ?? "nil"){
                  if application.canOpenURL(phoneUrl){
                      application.open(phoneUrl, options: [:], completionHandler: nil)
                      
                  }else{
                      print("Telefon Error")
                      
                  }
              }
    }
    
}
