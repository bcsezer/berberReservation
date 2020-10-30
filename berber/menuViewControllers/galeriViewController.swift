//
//  galeriViewController.swift
//  berber
//
//  Created by Cem Sezeroglu on 23.10.2020.
//

import UIKit
import SwiftPhotoGallery


class galeriViewController: UIViewController  {
    fileprivate let button: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("kapat", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(kapat), for: .touchUpInside)
        
        
        return button
    }()
    
    let imageNames = ["resim1", "resim2", "resim3","resim4","resim5"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    func configureGalleryMedia(){
        
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)

        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.white
        gallery.hidePageControl = false
        
        
        
        
    }

}
// MARK: SwiftPhotoGalleryDataSource Methods
extension galeriViewController:SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate{
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        imageNames.count
    }
    
    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        return UIImage(named: imageNames[forIndex])
    }
    
    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true, completion: nil)
    }
    @objc func kapat(){
        dismiss(animated: true, completion: nil)
    }
    
}
