//
//  Doctor.swift
//  Music App
//
//  Created by MAC on 09/11/2021.
//

import Foundation


struct Doctor{
    var name:String
    var password:String
    var email:String
    var speciality:String
    var bio:String
    var chooseDate:String
    var gender:String
    var profileImageUrl:String
    
    static var shared :Doctor!
    
    var doctorIdentifier:String{
        let docId = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        return docId
    }
    
    var profileId:String{
        return "\(doctorIdentifier)_profile_image.jpg"
    }
    
    func getSafeEmail(_ email:String) -> String{
        let getEmail = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        return getEmail
    }
    
    var getDoctDict:[String:String]{
        return [
            "name":name,
            "password":password,
            "email":getSafeEmail(email),
            "speciality":speciality,
            "docInfo":bio,
            "sDate":chooseDate,
            "gender":gender,
            "profileImage":profileImageUrl
        ]
    }
    
}
