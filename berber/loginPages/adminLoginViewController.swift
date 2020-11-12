//
//  adminLoginViewController.swift
//  berber
//
//  Created by Cem Sezeroglu on 12.11.2020.
//

import UIKit
import Firebase

class adminLoginViewController: UIViewController {
    
    @IBOutlet weak var adminEmail: UITextField!
    @IBOutlet weak var adminPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        if adminEmail.text != "" && adminPassword.text != "" {
            Auth.auth().signIn(withEmail: adminEmail.text!, password: adminPassword.text!) { (success, error) in
                if error != nil {
                    self.makeAllert(titleInput: "Uyarı", messageInput: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "toAdminDetailsPage", sender: self)
                }
            }
            
        }else{
            makeAllert(titleInput: "Uyarı", messageInput: "Eksik bilgi girildi")
        }
    }
    func makeAllert(titleInput :String,messageInput:String){
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }

}
