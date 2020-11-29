//
//  userClass.swift
//  berber
//
//  Created by Cem Sezeroglu on 12.11.2020.
//

import Foundation

class UserModal {
    
    var name :String?
    var dateAndTime :String?
    var choosenBerber:String?
    var phoneNumber:String?
    var tamRandevu:String?
    
    init(name:String,dateAndTime:String,choosenBerber:String,phoneNumber:String,tamRandevu:String) {
        self.name = name
        self.choosenBerber = choosenBerber
        self.dateAndTime = dateAndTime
        self.phoneNumber = phoneNumber
        self.tamRandevu = tamRandevu
    }
}

