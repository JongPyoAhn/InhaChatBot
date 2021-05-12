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
        
        signinBtn.addTarget(self, action: #selector(signinDisplay), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
    }
    
        //SignIn화면으로 전환
        @objc func signinDisplay(){
            self.performSegue(withIdentifier: "signSegue", sender: nil)
        }
    
//    로그인 버튼 클릭시 발생
    @objc func loginEvent(){
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
}
