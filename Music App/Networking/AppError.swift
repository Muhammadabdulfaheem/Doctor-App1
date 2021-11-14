//
//  AppError.swift
//  Music App
//
//  Created by MAC on 17/10/2021.
//

import Foundation
enum AppError: Error{
    
    case failedToUpload
    case failedtoDownloadUrl
    
    var errorDescription:String?{
        switch self{
            
        case .failedToUpload:
            return "failed to upload the data to firebase for pciture"
        
        case .failedtoDownloadUrl:
            return "failed to download url"
        
    }
}
}
