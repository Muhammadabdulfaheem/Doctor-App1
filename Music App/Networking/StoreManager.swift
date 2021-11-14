//
//  StoreManager.swift
//  Music App
//
//  Created by MAC on 17/10/2021.
//

import Foundation
import FirebaseStorage

struct StoreManager{
    static let shared = StoreManager()
    private let storageRefrence = Storage.storage().reference()
    private init(){
        
    }
    
    
    // MARK:- here we ussed data becuase image first convert into data then upload
    
    /*func uploadProfilePic(data: Data, fileName: String, completion: @escaping(Result<String,Error>) -> Void){
        storageRefrence.child("images/\(fileName)").putData(data,metadata: nil) { (metaData, error) in
            guard error == nil else {
                completion(.failure(AppError.failedToUpload))
                print("faheem ye he error \(error?.localizedDescription)")
                return
            }
            self.storageRefrence.child("images/\(fileName)").downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(AppError.failedtoDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("download url is\(urlString)")
                completion(.success(urlString))
            }
        }
        
    }
 */
    func uploadProfilePic(_ data:Data,_ imageName:String,completion:@escaping(Result<String,Error>) -> Void){
        
        storageRefrence.child("images/\(imageName)").putData(data, metadata: nil) { (metData, error) in
            
            guard error == nil else {
                completion(.failure(AppError.failedToUpload))
                print("faheem ye he error \(error?.localizedDescription)")
                return
            }
            storageRefrence.child("images/\(imageName)").downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(AppError.failedtoDownloadUrl))
                    print("faheem ye he error \(error?.localizedDescription)")
                    return
                }
                let urlString = url.absoluteString
                print("download url is\(urlString)")
                completion(.success(urlString))
            }
            
        }
    }
}
