//
//  SignupController.swift
//  Music App
//
//  Created by MAC on 16/10/2021.
//

import UIKit
import FirebaseAuth

class SignupController: UIViewController{

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var chooseDate: UITextField!
    @IBOutlet weak var selectGender: UITextField!
    var imagePricker = UIImagePickerController()
    var gender = ["Male","Female"]
    let picker = UIPickerView()
    let datePicker = UIDatePicker()
    var passwordIcon = false
    var userData: Users!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        showDate()
        password.isSecureTextEntry = true
        confirmPassword.isSecureTextEntry = true
        selectGender.inputView = picker
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.gray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectUserProfile))
        profileImage.addGestureRecognizer(gesture)
    }
    
    @objc func selectUserProfile(){
        //go to plsit file and add the two permission
        /*1st permission : Privacy - Camera Usage Description in plist
         2nd permisionn:** Privacy - Photo Library Usage Description*/
        print("profile pic changed")
        self.getPhoto()
    }
    
    // MARK: DATE func
    func showDate(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneBtn], animated: true)
        chooseDate.inputAccessoryView = toolBar
        chooseDate.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        chooseDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
  
    func showHidePassword(_ password1:UITextField){
        if passwordIcon {
            password1.isSecureTextEntry = false
        }
        else {
            password1.isSecureTextEntry = true
        }
       passwordIcon = !passwordIcon
    }
    
    
    // MARK:- For Show Password using osama logic
    @IBAction func showPassword(_ sender:UIButton){
        switch sender.tag{
            case 0:
                self.showHidePassword(password)
                
            default:
                self.showHidePassword(confirmPassword)
        }
    }
   
   
    
    // MARK: Insert users
    func insertUsers(_ insertUsers: Users){
        NetworkingService.shared.insertUsers(userm: insertUsers) { (result) in
            switch result{
                case .success(let data):
                    Users.shared = data
                    print("now we get the db from firebase and set in model\(Users.shared)")
                case .failure(let error):
                    print("getting an error while inserting the data; \(error.localizedDescription)")
            }
        }
    }
    // MARK: Adding recod on Autherntaciton data
    
    func createUser(_ createUser:Users){
        FirebaseAuth.Auth.auth().createUser(withEmail: createUser.email, password: createUser.password) { (response, error) in
            guard let getData = response else {
                print("not getting the response in createUser \(error?.localizedDescription)")
                return
            }
            
            self.insertUsers(createUser)
// here only need users not getData because it add the data into FirebaseAuth section
        }
        
    }
    
    // MARK: image uploading func
    func imageUplading(_ imageData:Data){
        StoreManager.shared.uploadProfilePic(imageData, userData.profileImageUrlId) { (result) in
            switch result{
                case .success(let url):
                    self.userData.profileImageUrl = url // setting url in mode because it's remaining
                    self.createUser(self.userData) // adding the url in user data
                    
                case .failure(let error):
                    print("eroor in uploading pic",error.localizedDescription)
            }
        }
    }
    
    //for textfiels
    func checkTextFieldsIsEmpty(_ textfields:[UITextField]) -> Bool{
        for textfield in textfields{
            return textfield.isemptyField() // if any fields is empty return true and call the if block
        }
        return false // call the else block
    }
   
 
    @IBAction func signupBtn2(_ sender: UIButton) {
        print("faheem press the btn")
    
        if checkTextFieldsIsEmpty([name,password,email,confirmPassword,email,chooseDate,selectGender]){
//            if password != confirmPassword{
//                showAlert("Password not match")
//            }
            showAlert("Some Field are empty")
        }
        
        else{
            guard let email1 = email.text,let password = password.text,let _ = confirmPassword.text,let name = name.text,let choosDate = chooseDate.text,
                  let selectGender = selectGender.text else {print("getting an error");return}
            /*
            NetworkingService.shared.checkUserExits(email1) { (userExists) in
                guard userExists == nil else {
                    self.showAlert("User aleready Exists")
                    return
                }
                */
                self.userData = Users(name: name, password: password, email: email1, choseDate: choosDate, gender: selectGender, profileImageUrl:"")
                
                // MARK: - For image uploading
                if let userImage = self.profileImage.image?.jpegData(compressionQuality: 0.2){
                    self.imageUplading(userImage)
                }
                else{
                    
                    print("Sorry Image is not compresseds")
                }//end of image uploading else
                
            
            
        }// end of else block
        
    }
  
    func checkFields(){
        if name.text?.isEmpty == true && password.text?.isEmpty == true &&
            confirmPassword.text?.isEmpty == true && chooseDate.text?.isEmpty == true && selectGender.text?.isEmpty == true{
            showAlert("All Fields are empty")
            return
        }
        else{
            guard let name = name.text, name.isEmpty == false else {
               showAlert("name is empty")
                return
            }
            guard let password = password.text, password.isEmpty == false else {
                showAlert("password is empty")
                return
            }
            guard let confrimPassword = confirmPassword.text,
                  confrimPassword.isEmpty == false else {
                 showAlert("Confirm Password empty")
                    return
            }
        
            guard password == confrimPassword else {
                showAlert("Password not matched")
                return
            }
            guard let chooseDate = chooseDate.text,chooseDate.isEmpty == false
            else {
                 showAlert("Choose date is empty")
                return
            }
            guard let selectGender = selectGender.text,selectGender.isEmpty == false  else{
                showAlert("Gender is empty")
                return
            }
        
        }
        
    }
    
    func showAlert(title:String = "Error",_ message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okBtn)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension SignupController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.gender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectGender.text = self.gender[row]
    }
}


extension SignupController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func getPhoto(){
        let actionSheet = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {
            [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
           
            self?.profilePhotoPicker()
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera(){ //not allowed in simualtor to capture photo
        imagePricker.sourceType = .camera
        imagePricker.delegate = self
        imagePricker.allowsEditing = true
        present(imagePricker, animated: true, completion: nil)
    }
    
    func profilePhotoPicker(){
        imagePricker.sourceType = .photoLibrary
        imagePricker.delegate = self
        imagePricker.allowsEditing = true
        present(imagePricker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { //called when select photo
        print(info)
        profileImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagePricker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
}



//extension UITextField{
//    func isEmptyField() -> Bool{
//        return self.text?.isEmpty == true
//    }
//}

