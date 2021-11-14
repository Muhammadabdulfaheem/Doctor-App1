//
//  Users.swift
//  Music App
//
//  Created by MAC on 16/10/2021.
//

import Foundation

struct Users{
    var name:String
    var password:String
    var email:String
    var choseDate:String
    var gender:String
    var profileImageUrl:String
    
    static var shared:Users!
   
    var userIdentifier : String{
        let id = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        return "\(id)"
    }
    
    var profileImageUrlId:String{
        return "\(userIdentifier)_profile_image.jpg"
    }
    
    func getSafeEmail(_ email:String) -> String{
        let getEmail = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        return getEmail
    }
    
    var usersgetDict: [String:String]{
        return [
            "name":name,
            "password":password,
            "email":getSafeEmail(email),
            "chooseDate":choseDate,
            "gender":gender,
            "profileImage":profileImageUrl
        ]
    }
}
