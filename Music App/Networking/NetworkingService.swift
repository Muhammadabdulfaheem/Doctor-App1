//
//  NetworkingService.swift
//  Music App
//
//  Created by MAC on 16/10/2021.
//

import Foundation
import Firebase
import FirebaseDatabase

struct NetworkingService{
    
    static let shared = NetworkingService()
    private init(){
        
    }
    
    let datbase1 = Database.database(url: "https://music-app-68654-default-rtdb.firebaseio.com/").reference()
    let storgeRefrence = Storage.storage().reference()
    
    
    func getUserEmail(_ userEmail:String) -> String{
        var safeEmail = userEmail.replacingOccurrences(of: ".", with: "_")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        return safeEmail
    }
    
    // MARK: For checking the userEmail
    func checkEmailExist(_ email:String,completion:@escaping(Bool) -> Void){
        let safeEmail = getUserEmail(email)
        datbase1.child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            guard let userExists = snapshot.value as? [String:Any] else{
                print("not finding the user email")
                completion(false) // not finding user email
                return
            }
        }
        completion(true)
    }
    
    func checkUserExits(_ email:String,completion:@escaping(Bool) -> Void){
        let safeEamil = getUserEmail(email)
        datbase1.child(safeEamil).observeSingleEvent(of: .value) { (snapshot) in
            guard let userExists = snapshot.value as? [String:String] else {
                completion(false)// user not exist
                return
            }
        }
        completion(true)
        
    }
    
   
    
    func setUsersEmailDic(_ usersId:String,userDic:[String:Any],completion:@escaping(Bool) -> Void){
        datbase1.child(usersId).setValue(userDic) { (error, ref) in
            if error == nil{
                completion(true)
            }
            else {
                print("\(error?.localizedDescription)")
                completion(false)
            }
        }
    }
  
    func setUserDic(_ userDic:[String:Any],completion:@escaping(Bool) -> Void){
        datbase1.child("users").setValue(userDic) { (error, ref) in
            if error == nil{
                completion(true)
            }
            else{
                print("\(error?.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func checkUsersDict(completion:@escaping([String:Any]?) -> Void){
        datbase1.child("users").observeSingleEvent(of: .value) { (snapshot) in
            if var userDic = snapshot.value as? [String:Any]{
                completion(userDic)
            }
            else {
                print("users dic not present")
            }
        }
    }
    
    func checkDoctorDictExist(completion:@escaping([String:Any]?) -> Void){
        datbase1.child("doctors").observeSingleEvent(of: .value) { (snapshot) in
            if var doctorDic = snapshot.value as? [String:Any]{
                completion(doctorDic)
            }
            else{
                print("doctor dic not present")
                completion(nil)
            }
        }
    }
    
    func setDoctorDic(_ doctors:[String:Any],completion:@escaping(Bool) -> Void){
        datbase1.child("doctors").setValue(doctors) { (error, ref) in
            if error != nil{
                completion(true)
            }
            else{
                completion(false)
            }
        }
    }
    
    /*
    func insertDoctors(_ doctors:Doctor,completion:@escaping(Result<Doctor,Error>) -> Void){
        self.checkDoctorDictExist { (response) in
            guard var doctorNode = response else{
                print("invalid doctro node \(String(describing: response))")
                return
            }
    
            if var doctorData = doctorNode["doctors"] as? [[String:Any]]{
                doctorData.append(doctors.getDoctDict)
                doctorNode["doctors"] = doctorData
                setUserDic(doctorNode) { (result) in
                    if result{
                        completion(.success(doctors))
                    }
                    else{
                        print("get and while setting the doctors")
                    }
                }
            }
        }
    }*/
    
    func setOutsideId(_ emailId:String,_ dic:[String:Any],completion:@escaping(Bool) -> Void){
        datbase1.child(emailId).setValue(dic) { (error, ref) in
            if error != nil{
                completion(true)
            }
            else{
                print("\(error?.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func findDic(completion:@escaping([String:Any]?) -> Void){
        datbase1.child("doctors").observeSingleEvent(of: .value) { (snapshot) in
            if let getData = snapshot.value as? [String:Any]{
                completion(getData)
            }
            else{
                print("docotrs are not presendt")
                completion(nil)
            }
        }
    }
    
    func setDic(_ dic:[String:Any],completion:@escaping(Bool) -> Void){
        datbase1.child("doctors").setValue(dic) { (error, ref) in
            if error != nil{
                completion(true)
            }
            else{
                print("error in setDic",error?.localizedDescription)
                completion(false)
            }
        }
    }
    
    /*
    func insertDoctors2(_ doctors:Doctor,completion:@escaping(Result<Doctor,Error>) -> Void){
        
        setOutsideId(doctors.doctorIdentifier, doctors.getDoctDict) { (result) in
            if result{
                findDic { (result) in
                    guard var docNode = result else {print("not getting any node in docnode"); return
                    }
                    
                    if var doctordic = docNode["doctors"] as? [[String:Any]]{
                        doctordic.append(doctors.getDoctDict)
                        docNode["doctors"] = doctordic
                        setDic(docNode) { (result) in
                            if result{
                                completion(.success(doctors))
                            }
                            else{
                                print("not getting any doctors")
                            }
                        }
                    }
                    else{
                        docNode["doctors"] = [doctors.getDoctDict]
                        setDic(docNode) { (result) in
                            if result{
                                completion(.success(doctors))
                            }
                            else{
                                print("not getting any doctors in else block")
                            }
                        }
                    }
                }
            }
            else{
                print("not getting the result through setOutise method")
            }
        }
        
    }
    */
    
    // MARK: - INSERT USersask osama how to write in separte function
    func insertDoctors(_ doctors:Doctor,completion:@escaping(Result<Doctor,Error>) -> Void){
        
        datbase1.child(doctors.doctorIdentifier).setValue(doctors.getDoctDict) {
            //it will set the email outside the users array
            (error, ref) in
            if error != nil{
                completion(.failure(error!))
            }
            else{
                // if users array present then append othersiwse go to else block and create
                datbase1.child("doctors").observeSingleEvent(of: .value) { (snapshot) in
                    
                    if var userCollection = snapshot.value as? [[String:String]]{
                        userCollection.append(doctors.getDoctDict)
                        datbase1.child("doctors").setValue(userCollection) { (error, ref) in
                            guard error != nil else {return}
                            completion(.success(doctors))
                        }
                    }
                    
                    else{
                        let userCollection : [[String:String]] = [doctors.getDoctDict]
                        datbase1.child("doctors").setValue(userCollection) { (error, ref) in
                            
                            guard error != nil else {return}
                            completion(.success(doctors))
                        }
                        
                    }
                }
                completion(.success(doctors))
            }
        }
        
    }
    


    // MARK: - INSERT USersask osama how to write in separte function
    func insertUsers(userm:Users,completion:@escaping(Result<Users,Error>) -> Void){
        
        /*
        setUsersEmailDic(userm.userIdentifier, userDic: userm.usersgetDict) { (result) in
            
            if result{
                checkUsersDict { (user) in
                    guard var userDictNode = user else {
                        print("Invalid user node :\(String(describing: user))")
                        return
                    }
                    
                    if var userData = userDictNode["users"] as? [[String:Any]]{
                        userData.append(userm.usersgetDict)
                        userDictNode["users"] = userData
                        setUserDic(userDictNode) { (result) in
                            if result{
                                completion(.success(userm))
                            }
                            else{
                                //completion(false)
                                print("not settin guser")
                            }
                        }
                        
                    }
                    //users array not presend create one
                    else {
                        userDictNode["users"] = [userm.usersgetDict]
                        setUserDic(userDictNode) { (result) in
                            if result{
                                completion(.success(userm))
                            }
                            else{
                                print("not setting the users")
                            }
                        }
                    }
                }
            }
            else{
                print("not getting the result")
            }
        }
        */
        
       
        
        datbase1.child(userm.userIdentifier).setValue(userm.usersgetDict) {
            //it will set the email outside the users array
            (error, ref) in
            if error != nil{
                completion(.failure(error!))
            }
            else{
                // if users array present then append othersiwse go to else block and create 
                datbase1.child("users").observeSingleEvent(of: .value) { (snapshot) in
                    
                    if var userCollection = snapshot.value as? [[String:String]]{
                        userCollection.append(userm.usersgetDict)
                        datbase1.child("users").setValue(userCollection) { (error, ref) in
                            guard error != nil else {return}
                            completion(.success(userm))
                        }
                    }
                    
                    else{
                        let userCollection : [[String:String]] = [userm.usersgetDict]
                        datbase1.child("users").setValue(userCollection) { (error, ref) in
                            
                            guard error != nil else {return}
                            completion(.success(userm))
                        }
                        
                    }
                }
                completion(.success(userm))
            }
        }
        
    }
    
    // MARK:- For getting all doctors list and set into doctor model
    func getDoctorsList(completion:@escaping(Result<[Doctor],Error>) -> Void){
       datbase1.child("doctors").observeSingleEvent(of: .value) { (snapshot) in
            guard let conData = snapshot.value as? [[String:Any]] else {
                completion(.failure(AppError.failedToUpload))
                return
            }
        
            let conversatioon : [Doctor] = conData.compactMap({dic in
               guard let name = dic["name"] as? String,
                     let docInfo = dic["docInfo"] as? String,
                     let speciality = dic["speciality"] as? String,
                     let password = dic["password"] as? String,
                     let gender = dic["gender"] as? String,
                     let profielImage = dic["profileImage"] as? String,
                     let email = dic["email"] as? String,
                     let cDate = dic["sDate"] as? String
                     else {print("not getting the doctors");
                return nil}
                return Doctor(name: name, password: password, email: email, speciality: speciality, bio: docInfo, chooseDate: cDate, gender: gender, profileImageUrl: profielImage)
                
            })
            // MARK:- return the doctorl model in success
            completion(.success(conversatioon))
        }
        
    }
    
   
    
}

/*
class NetworkingService{
    
    let datbase1 = Database.database(url: "https://music-app-68654-default-rtdb.firebaseio.com/").reference()
    let storgeRefrence = Storage.storage().reference()
    
    class func getUserEmail(_ userEmail:String) -> String{
        let userEmail = userEmail.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        return userEmail
    }
    
    class func checkUserExists(_ email:String,completion:@escaping(Bool) -> Void){
        let safeEmail = getUserEmail(email)
        database1
       
    }
    
}
*/
