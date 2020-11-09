//
//  popUp.swift
//  EggTimer
//
//  Created by Cem Sezeroglu on 13.10.2020.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation
import UIKit

class popUp: UIView {
    fileprivate let button: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tamam", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        
        
        return button
    }()
    fileprivate let container: UIView = {
       let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = #colorLiteral(red: 0.927704632, green: 0.927704632, blue: 0.927704632, alpha: 1)
        containerView.layer.cornerRadius = 20
        
        
        return containerView
    }()
    
    fileprivate let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Randevu Özetin"
        label.textAlignment = .center
        
        return label
    }()
    
    fileprivate let subTitle: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Ananın amına koyayim Fenerbahçe"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    fileprivate lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,subTitle,button])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        
        
        return stack
    }()
    @objc fileprivate func animateOut(){
        UIView.animate(withDuration: 0.3) {
            self.container.transform = CGAffineTransform(translationX: 0, y: +self.frame.height)
            self.alpha = 0
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
          
        }) { (complete) in
        
            if complete {
                self.removeFromSuperview()
            }
    }
    }
    
    @objc fileprivate func animateIn(){
        self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.container.transform = .identity
            self.alpha = 1
            
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
          
        })
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        self.frame = UIScreen.main.bounds
        
        self.addSubview(container)
        
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.50).isActive = true
        
        container.addSubview(stack)
        
//        stack.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
//        stack.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        stack.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.5).isActive = true
        
            animateIn()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
