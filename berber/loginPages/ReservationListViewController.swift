//
//  ReservationListViewController.swift
//  berber
//
//  Created by Cem Sezeroglu on 12.11.2020.
//

import UIKit
import Firebase

class ReservationListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var currentBerberName: UILabel!
    @IBOutlet weak var header: NSLayoutConstraint!
    
    var reservationList = [UserModal]()
    let currentUser = Auth.auth().currentUser
    private let database = Database.database().reference()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DetectCurrentUser(user: (currentUser?.email)!)
        loadposts()
        configureActivity()
    }
    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        
        do { try Auth.auth().signOut()
            
            print("sign out")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let VC = sb.instantiateViewController(withIdentifier: "homePageVC") as! HomePageViewController
            let navRootView = UINavigationController(rootViewController: VC)
            navRootView.modalPresentationStyle = .fullScreen
            self.present(navRootView, animated: true, completion: nil)
            
        } catch { print("already logged out") }
          
        
       
    }
    
    
    private func DetectCurrentUser(user:String){
        
        if currentUser?.email == "cemsezeroglu@gmail.com" {
            currentBerberName.text = "Hoş geldin : Cem Sezeroglu"
        }else{
            print(currentUser?.email)
        }
        
        
        
        
    }
    
    private func loadposts() {
        activityIndicator.startAnimating()
        reservationList = []
        Database.database().reference().child("byMakas").observe(.value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    print("Error")
                    return
                }
                let name = dict["name"] as! String
                let tarih = dict["tarih"] as? String ?? "nil"
                let berber = dict["berberAd"] as? String ?? "nil"
                
                let reservations = UserModal(name: name, dateAndTime: tarih, choosenBerber: berber  , phoneNumber: "nil")
                self.reservationList.append(reservations)
                print(self.reservationList)
                
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    func configureActivity(){
          activityIndicator.center = self.view.center
          activityIndicator.hidesWhenStopped = true
          activityIndicator.style = UIActivityIndicatorView.Style.large
          activityIndicator.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
          activityIndicator.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
          activityIndicator.autoresizingMask = [
              .flexibleLeftMargin,
              .flexibleRightMargin,
              .flexibleTopMargin,
              .flexibleBottomMargin
          ]
          self.view.addSubview(activityIndicator)
          
      }

}
extension ReservationListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationCell", for: indexPath) as! reservationCell
        cell.berberNameLabel.text = reservationList[indexPath.row].choosenBerber
        cell.nameLabel.text = reservationList[indexPath.row].name
        cell.dateAndTimeLabel.text = reservationList[indexPath.row].dateAndTime
        cell.phoneButton.titleLabel?.text = "nil"
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")
        self.reservationList.remove(at: indexPath.row)
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
