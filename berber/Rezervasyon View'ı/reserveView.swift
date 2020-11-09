//
//  reserveView.swift
//  berber
//
//  Created by Cem Sezeroglu on 9.11.2020.
//

import Foundation
import UIKit
import Firebase

class reserveView: UIView {
    
    fileprivate let button: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Rezervasyonu iptal et", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
//        button.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        
        
        return button
    }()
    
    fileprivate let fakeView: UIView = {
           let view = UIView()
            view.frame = UIScreen.main.bounds
            view.backgroundColor = #colorLiteral(red: 0.9340696383, green: 0.9340696383, blue: 0.9340696383, alpha: 1)
            
            return view
        }()
        
        fileprivate let girisTitle : UILabel = {
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = NSLocalizedString("Rezervasyon yapıldı", comment: "")
            label.font = UIFont(name: "arial", size: 28)
            label.textColor = #colorLiteral(red: 0.1302546003, green: 0.1302546003, blue: 0.1302546003, alpha: 1)
            label.numberOfLines = 1
            label.textAlignment = .center
            
           return label
            
        }()
    
   
       
    override init(frame: CGRect) {
        super.init(frame: frame)
       
      
        
   
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
