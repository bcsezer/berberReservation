//
//  detailViewController.swift
//  berber
//
//  Created by Cem Sezeroglu on 22.10.2020.
//

import UIKit

class detailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var berberName: UILabel!
    
    var name = ""
    var date = ""
    var berber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = name
        dateLabel.text = date
        berberName.text = berber
    }
    
  
    

}
