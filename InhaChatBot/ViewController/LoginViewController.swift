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
        loginBtn.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
    }
    
    //회원가입 버튼 클릭
    @IBAction func joinButttonTabbed(_ sender: Any) {
        self.performSegue(withIdentifier: "signSegue", sender: nil)
    }
    
    //로그인 버튼 클릭
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

    // 화면 터치 시 키보드 내리기 ( 뷰 컨트롤러에 터치가 시작되는 시점에 동작 )
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailText.resignFirstResponder()
        self.pwText.resignFirstResponder()
    }
}
class LogManager {
    static let shared = LogManager()
    
    
    
}
class LogViewModel {
    
}
