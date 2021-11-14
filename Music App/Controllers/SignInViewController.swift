//
//  SignInViewController.swift
//  Music App
//
//  Created by MAC on 16/10/2021.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var hostpitalImage:UIImageView!
    @IBOutlet weak var email:UITextField!
    @IBOutlet weak var password:UITextField!
    @IBOutlet weak var selectLogin:UITextField!
    @IBOutlet weak var passdShow: UIButton!
    var picker = UIPickerView()
    var personLogin = ["Patient","Doctor"]

    var passwordIcon = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hostpitalImage.image = UIImage(named: "mens")
        hostpitalImage.layer.cornerRadius = hostpitalImage.frame.size.height / 2
        hostpitalImage.clipsToBounds = true
        picker.delegate = self
        picker.dataSource = self
        selectLogin.inputView = picker
        password.isSecureTextEntry = true
    }
    

    func checkTextField(_ textField:[UITextField]) -> Bool{
        for textData in textField{
            textData.isemptyField() // already return the true
        }
        return false
    }
    
    func showPassword(_ textFeild:UITextField){
        if passwordIcon{
            textFeild.isSecureTextEntry = false
        }
        else{
            textFeild.isSecureTextEntry = true
        }
        passwordIcon = !passwordIcon
    }
    
    @IBAction func passwordIcon(_ sender: UIButton) {
        showPassword(password)
//        if passwordIcon{
//            password.isSecureTextEntry = false
//        }
//        else{
//            password.isSecureTextEntry = true
//        }
//        passwordIcon = !passwordIcon
    }
    
    func showAlert(title:String = "Error",_ message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func loggin(_ sender:UIButton){
        
        if checkTextField([email,password,selectLogin]){
            showAlert("Some field is missing")
        }
        else{
            guard let email = email.text,let pass = password.text else {return}
            // MARK: Default method of signin Firebase
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pass) { (data, error) in
                if error == nil{ // means data coming no error
                    
                    if self.selectLogin.text == "Patient"{
                        guard let patientController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: PatientViewController.self)) as? PatientViewController else {return}
                        self.navigationController?.pushViewController(patientController, animated: true)
                    }
                    else{
                        guard let doctorViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: DoctorViewController.self)) as? DoctorViewController else {return}
                        self.navigationController?.pushViewController(doctorViewController, animated: true)
                    }
                }
                else{
                    self.showAlert("You're not login successfully check email or password")
                }

            }
          
            
        }
        
       
    }

    @IBAction func goToSignup(_ sender:UIButton){
        switch sender.tag{
            case 0:
                guard let patientSignup = self.storyboard?.instantiateViewController(withIdentifier: String(describing: SignupController.self)) as? SignupController else {return}
                self.navigationController?.pushViewController(patientSignup, animated: true)
            default:
                guard let doctorSignup = self.storyboard?.instantiateViewController(withIdentifier: String(describing: DoctorSignupViewController.self)) as? DoctorSignupViewController else {return}
                self.navigationController?.pushViewController(doctorSignup, animated: true)
            
        }
    }
}

extension SignInViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return personLogin.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.personLogin[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectLogin.text = self.personLogin[row]
        
    }
}


