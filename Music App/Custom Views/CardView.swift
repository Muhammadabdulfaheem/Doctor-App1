//
//  CardView.swift
//  Music App
//
//  Created by MAC on 13/11/2021.
//

import Foundation
import UIKit
// MARK:- For shadow effect

class CardView: UIView{
    
    override init(frame:CGRect){
        super.init(frame:frame)
        initalSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initalSetup()
    }
    
    private func initalSetup(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero// CGSize(width: 2, height: 2)
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.1
        cornerRadius = 10
    }
}
