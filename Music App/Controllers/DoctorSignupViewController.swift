//
//  DoctorSignupViewController.swift
//  Music App
//
//  Created by MAC on 08/11/2021.
//

import UIKit
import FirebaseAuth

class DoctorSignupViewController: UIViewController {

    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var doctorName:UITextField!
    @IBOutlet weak var dPassword:UITextField!
    @IBOutlet weak var cdPassowrd:UITextField!
    @IBOutlet weak var email:UITextField!
    @IBOutlet weak var speciality:UITextField!
    @IBOutlet weak var doctorIno:UITextField!
    @IBOutlet weak var chooseDate:UITextField!
    @IBOutlet weak var gender:UITextField!
    
    var genders = ["Male","Female"]
    var docSpeciality = ["Stomach","Heart","Cancer","Liver","Gardialogy"]
    
    let gendersPickerView = UIPickerView()
    let specialityPicerkView = UIPickerView()
    let datePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    var passwordIcon = true
    var doctorData: Doctor!
    override func viewDidLoad() {
        super.viewDidLoad()
        //profileImage.clipsToBounds = true
        speciality.inputView = specialityPicerkView
        gender.inputView = gendersPickerView
        speciality.placeholder = "Select speciality"
        gender.placeholder = "Select Gender"
        specialityPicerkView.delegate = self
        specialityPicerkView.dataSource = self
        gendersPickerView.delegate = self
        gendersPickerView.dataSource = self
        specialityPicerkView.tag = 1
        gendersPickerView.tag = 2
        
        dPassword.isSecureTextEntry = true
        cdPassowrd.isSecureTextEntry = true
        showDate()
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.gray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectUserProfile))
        profileImage.addGestureRecognizer(gesture)
//        speciality.inputView = picker
//        speciality.text = docSpeciality[0]
//        gender.inputView = picker
//        gender.text = genders[0]
        // Do any additional setup after loading the view.
    }
    
    @objc func selectUserProfile(){
        getProfileImage()
    }
    // MARK:- DATE PIKCER
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
    
    @IBAction func showPassword(_ sender:UIButton){
        switch sender.tag{
            case 0:
                showHidePassword(dPassword)
            default:
               showHidePassword(cdPassowrd)
        }
    }
    
    func checkTextField(_ textField:[UITextField]) -> Bool{
        for getTextField in textField{
           return getTextField.isemptyField()
        }
        return false
    }
    
    func inserUser(_ doctors:Doctor){
        NetworkingService.shared.insertDoctors(doctors) { (result) in
            switch result{
                case .success(let data):
                    Doctor.shared = data
                    print("working")
                    guard let siginController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: SignInViewController.self)) as? SignInViewController else {return}
                    self.navigationController?.pushViewController(siginController, animated: true)
                    print("working")
                case .failure(let error):
                    print("issue in insert doctor func",error.localizedDescription)
            }
        }
        
    }
    
    func createUser(_ createUser:Doctor){
        FirebaseAuth.Auth.auth().createUser(withEmail: createUser.email, password: createUser.password) { (response, error) in
            
            guard let getData = response else {
                print("getting an erro in createUSer",error?.localizedDescription)
                return
            }
            self.inserUser(createUser)
        }
    }
    
    
    
    func uploadImage(_ imageData:Data){
        //get the image because we don't directy uplaod first convert to data
        StoreManager.shared.uploadProfilePic(imageData, doctorData.doctorIdentifier) { (result) in
            switch result{
                case .success(let url):
                    self.doctorData.profileImageUrl = url // setting url in mode because it's remaining
                    self.createUser(self.doctorData) // adding the model
                case .failure(let error):
                    print("error in uploadImage",error.localizedDescription)
            }
        }
    }
    
    func showAlert(title:String = "Error",_ message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func doctorSignup(_ sender:UIButton){
        
        if checkTextField([doctorName,dPassword,cdPassowrd,email,speciality,doctorIno,chooseDate,gender]){
            showAlert("Some field is missing")
        }
        
        else{
        
            guard let docName = doctorName.text,let docPassword = dPassword.text,let conPassword = cdPassowrd.text,let docEmail = email.text,let docSpeciality = speciality.text,let docInfo = doctorIno.text,let docDate = chooseDate.text,let docGender = gender.text else {return}
            
            NetworkingService.shared.checkEmailExist(docEmail) { (response) in
                if response{
                    self.showAlert("User Already Exiist")
                    return
                }
            }
            
            self.doctorData = Doctor(name: docName, password: docPassword, email: docEmail, speciality: docSpeciality, bio: docInfo, chooseDate: docDate, gender: docGender, profileImageUrl: "")
            
            // MARK:Image uploading
            if let userImage = profileImage.image?.jpegData(compressionQuality: 0.2){
                uploadImage(userImage)
            }
            else{
                print("getting an error while uploading the image")
            }
            
        }
       
    }
    
    
    
}

extension DoctorSignupViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        switch pickerView.tag{
            case 1:
                return docSpeciality.count
            default:
                return genders.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag{
            case 1:
                return docSpeciality[row]
            default:
                return genders[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag{
            case 1:
                self.speciality.text = docSpeciality[row]
            default:
                self.gender.text = genders[row]
        }
       
    }
}

// MARK:- Image Picker no delegate and no date source define in viewdidload

extension DoctorSignupViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    func getProfileImage(){
        let actionSheet = UIAlertController(title: "choose Image", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "choose Photo", style: .default, handler: { [weak self] _ in
            self?.profilePicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera(){
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func profilePicker(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
