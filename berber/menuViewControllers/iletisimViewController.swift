//
//  iletisimViewController.swift
//  berber
//
//  Created by Cem Sezeroglu on 23.10.2020.
//

import UIKit
import MessageUI

class iletisimViewController: UIViewController,MFMailComposeViewControllerDelegate {
    fileprivate let application = UIApplication.shared
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerViewConfigure()
    }
    
    func containerViewConfigure(){
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        
    }

    @IBAction func phoneCall(_ sender: UIButton) {
    

         if let url = URL(string: "tel://+905366839793"),
           UIApplication.shared.canOpenURL(url) {
              if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
               } else {
                   UIApplication.shared.openURL(url)
               }
           } else {
                    print("Tel error")
           }
        
        
    }
    @IBAction func onethorButtonAction(_ sender: Any) {
       

         if let url = URL(string: "tel://+905353554883"),
           UIApplication.shared.canOpenURL(url) {
              if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
               } else {
                   UIApplication.shared.openURL(url)
               }
           } else {
                print("Tel error")
           }
        
    }
    
    @IBAction func urlAction(_ sender: UIButton) {
        
        
        if let url = URL(string: "https://www.besiktasbymakas.com") {
            UIApplication.shared.open(url)
        }
        
    }
    @IBAction func mailClicked(_ sender: UIButton) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["kuafor@besiktasbymakas.com"])
            mail.setMessageBody("<p>Merhaba!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            print("Mail error")
            
        }
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
