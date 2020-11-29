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
    fileprivate let application = UIApplication.shared
    @IBOutlet weak var currentBerberName: UILabel!
    @IBOutlet weak var header: NSLayoutConstraint!
    var isWorking:Bool?
    var reservationList = [UserModal]()
    let currentUser = Auth.auth().currentUser
     let database = Database.database().reference()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureActivity()
        
        loadposts()
        tableView.delegate = self
        tableView.dataSource = self
      

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        DetectCurrentUser(user: (currentUser?.email)!)
        isWorking = false
        
       
    }
    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        if NetworkMonitor.shared.isConnected{
        do { try Auth.auth().signOut()
            
            print("sign out")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let VC = sb.instantiateViewController(withIdentifier: "homePageVC") as! HomePageViewController
            let navRootView = UINavigationController(rootViewController: VC)
            navRootView.modalPresentationStyle = .fullScreen
            self.present(navRootView, animated: true, completion: nil)
            
        } catch { print("already logged out") }
          
        }else{
            makeAllert(titleInput: "Uyarı", messageInput: "Lütfen internet bağlantınızı kontrol edin ve uygulamayı yeniden başladın.")
        }
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "toAddReservationVC", sender: self)
    }
    
    private func DetectCurrentUser(user:String){
        
        if currentUser?.email == "cemsezeroglu@gmail.com" {
            currentBerberName.text = "Hoş geldin : Cem Sezeroglu"
        }else{
            print(currentUser?.email! as Any)
        }
        
    }
    
     func loadposts() {
        if NetworkMonitor.shared.isConnected {
        database.child("byMakas").observe(.value) { snapshot in
            self.activityIndicator.startAnimating()
            self.reservationList.removeAll(keepingCapacity: false)
            
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    print("Error")
                   
                    return
                }
                let name = dict["name"] as! String
                let tarih = dict["tarih"] as? String ?? "nil"
                let berber = dict["berberAd"] as? String ?? "nil"
                let tamRandevu = dict["tamRandevu"] as? String ?? "nil"
                let phoneNumber = dict["phoneNumber"] as? String ?? "nil"
                
                let reservations = UserModal(name: name, dateAndTime: tarih, choosenBerber: berber  , phoneNumber: phoneNumber, tamRandevu: tamRandevu)
                self.reservationList.append(reservations)
                print(self.reservationList)
                
                
                self.activityIndicator.stopAnimating()
                
            }
            self.tableView.reloadData()
        }
            self.activityIndicator.stopAnimating()
        }else{
            makeAllert(titleInput: "Uyarı", messageInput: "Lütfen internet bağlantınızı kontrol edin ve uygulamayı yeniden başladın.")
        }
    }
    func makeAllert(titleInput :String,messageInput:String){
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        cell.phoneButton.setTitle(reservationList[indexPath.row].phoneNumber, for: .normal)
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if NetworkMonitor.shared.isConnected{
                activityIndicator.startAnimating()
                let ref = Database.database().reference().child("byMakas")
                
                // ^^ this only works if the value is set to the firebase uid, otherwise you need to pull that data from somewhere else.
                
                let tamRandevu = reservationList[indexPath.row].tamRandevu ?? "nil"
                
                
                if tamRandevu != "nil" {
                    
                    
                    ref.child(tamRandevu).removeValue()
                    
                    reservationList.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    
                    activityIndicator.stopAnimating()
                    
                    
                }else{
                    
                    activityIndicator.stopAnimating()
                    print("Rezervasyon bulunamadı.")
                }
                
            }
        }else{
            makeAllert(titleInput: "Uyarı", messageInput: "Lütfen internet bağlantınızı kontrol edin ve uygulamayı yeniden başladın.")
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
            
        if let phoneUrl = URL(string: reservationList[indexPath.row].phoneNumber ?? "nil"){
                      if application.canOpenURL(phoneUrl){
                          application.open(phoneUrl, options: [:], completionHandler: nil)
                          
                      }else{
                          print("Telefon Error")
                          
                      }
                  
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
