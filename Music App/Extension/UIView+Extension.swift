//
//  UIView+Extension.swift
//  Music App
//
//  Created by MAC on 07/11/2021.
//

import Foundation
import UIKit

extension UIView{
    @IBInspectable var cornerRadius:CGFloat{
        get{
            return self.cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}


extension UITextField{
    func isemptyField() -> Bool{
        return text?.isEmpty == true
    }
}

