//
//  ViewController.swift
//  berber
//
//  Created by Cem Sezeroglu on 16.10.2020.
//

import UIKit
import SwiftPhotoGallery
import Firebase

class HomePageViewController: UIViewController {

    @IBOutlet var buttonsCollection: [UIButton]!
    
    
    let imageNames = ["resim1", "resim2", "resim3","resim4","resim5"]
    
    @IBOutlet weak var rezerveEtButton: UIButton!
    @IBOutlet weak var galeriButton: UIButton!
    
    @IBOutlet weak var konumButton: UIButton!
    @IBOutlet weak var iletisimButton: UIButton!
    
    @IBOutlet weak var buttonContaierView: UIView!
    @IBOutlet weak var aboutButton: UIButton!
    
    
    @IBOutlet weak var makasLogo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      configureReserveButton()
        configureButtons(button: galeriButton)
        configureButtons(button: aboutButton)
        configureButtons(button: konumButton)
        configureButtons(button: iletisimButton)
        buttonContaierView.layer.cornerRadius = 25
        buttonContaierView.layer.masksToBounds = true
        
        makasLogo.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToLogin))
        tapGesture.numberOfTapsRequired = 3
        
        makasLogo.addGestureRecognizer(tapGesture)
     
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        
    }
    @objc func goToLogin(){
        performSegue(withIdentifier: "toAdminLogin", sender: self)
    }
    @IBAction func galeriButtonClicked(_ sender: UIButton) {
        
        
       configureGalleryMedia()
    }
    
    @IBAction func konumButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "konumVC", sender: self)
    }
    @IBAction func iletisimcClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "iletisimVC", sender: self)
    }
    @IBAction func detailVC(_ sender: Any) {
        performSegue(withIdentifier: "detailsPage", sender: self)
    }
    
    @IBAction func hakkimizdaButton(_ sender: UIButton) {
        performSegue(withIdentifier: "hakkimizdaVC", sender: self)
    }
    
    
    func configureGalleryMedia(){
        
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)

        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.white
        gallery.hidePageControl = false
        gallery.modalPresentationStyle = .custom
        
        
        navigationController?.pushViewController(gallery, animated: true)
        
        
    }


    
    
    func configureReserveButton(){
        rezerveEtButton.layer.cornerRadius = 30
        rezerveEtButton.layer.masksToBounds = true
        rezerveEtButton.layer.borderWidth = 1
        rezerveEtButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
    }
    
    func configureButtons(button:UIButton){
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
       
        
        
    }
    
 
                
}

// MARK: SwiftPhotoGalleryDataSource Methods
extension HomePageViewController:SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate{
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        imageNames.count
    }

    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        return UIImage(named: imageNames[forIndex])
    }

    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true, completion: nil)
    }


}

