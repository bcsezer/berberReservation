//
//  ReservationListViewController.swift
//  berber
//
//  Created by Cem Sezeroglu on 12.11.2020.
//

import UIKit

class ReservationListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var header: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    

}
extension ReservationListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationCell", for: indexPath) as! reservationCell
        cell.berberNameLabel.text = "Yavuz Kucur"
        cell.nameLabel.text = "Yavuz Kucur"
        cell.dateAndTimeLabel.text = "30 Mart 13:00 "
        cell.phoneButton.titleLabel?.text = "05362091049"
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")

        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
    
}
extension  ReservationListViewController: UIScrollViewDelegate {


    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y >= 50 {// the value when you want the headerview to hide
            view.layoutIfNeeded()

            header.constant = 28

            UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction], animations: {
                

                self.view.layoutIfNeeded()

            }, completion: nil)

        }else {
            // expand the header
            view.layoutIfNeeded()
           // Your initial height of header view
            UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction], animations: {
                self.header.constant = 0
                self.view.layoutIfNeeded()

            }, completion: nil)
         }

    }
}
