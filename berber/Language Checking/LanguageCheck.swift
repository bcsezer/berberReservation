//
//  LanguageCheck.swift
//  berber
//
//  Created by Cem Sezeroglu on 30.11.2020.
//

import Foundation
import UIKit


class LanguageCheck {
    
    
    func preferredLanguage() -> String {
        
        let preferredLanguage = NSLocale.preferredLanguages[0]
        let language = preferredLanguage.split(separator: "-") //parse string it-US
        return String(language.first!)
    }
    
}
