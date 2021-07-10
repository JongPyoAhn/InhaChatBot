//
//  LoginViewController.swift
//  InhaChatBot
//
//  Created by 안종표 on 2021/05/06.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
   
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var pwText: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LoginViewController{
    //회원가입 버튼 클릭
    @IBAction func joinButttonTabbed(_ sender: Any) {
        self.performSegue(withIdentifier: "signSegue", sender: nil)
    }
    //로그인 버튼 클릭
    @IBAction func loginButtonTabbed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailText.text!, password: pwText.text!) {
            (user, err) in
            if(err != nil){
                let alert = UIAlertController(title: "로그인 실패", message: "다시 입력해주세요!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }else{
                self.performSegue(withIdentifier: "MainSegue", sender: nil )
            }
        }
    }
    
    //키보드 내리기
    @IBAction func TabBG(_ sender: Any){
        emailText.resignFirstResponder()
        pwText.resignFirstResponder()
    }
}

