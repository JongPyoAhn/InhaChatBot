//
//  SignInViewController.swift
//  InhaChatBot
//
//  Created by 안종표 on 2021/05/06.
//

import UIKit
import Firebase
class SignInViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signBtn: UIButton!
    @IBOutlet weak var numofSchoolText: UITextField!
    @IBOutlet weak var turnOffJoinButton: UIButton!
    //MARK: -MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: -Method
    //회원가입 버튼 클릭
    @IBAction func joinButtonTabbed(_ sender: Any) {
        guard let email = self.emailText.text else{
        return
        }
        guard let password = self.passwordText.text else {
        return
        }
        Auth.auth().createUser(withEmail: email, password: password) {
            (user, err) in
            let uid = user?.user.uid

            //학번, UID값 맵으로 생성
            var userModel = UserModel()
            userModel.StudentID = self.numofSchoolText.text
            userModel.uid = Auth.auth().currentUser?.uid

            //데이터베이스에 유저정보 입력
            Database.database().reference().child("users").child(uid!).setValue(userModel.toJSON(), withCompletionBlock: { (err, ref) in
                if(err == nil){
                    let alert = UIAlertController(title: "회원가입 완료", message: "회원가입이 완료되었습니다!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    
    }
    //turnOffJoin버튼클릭
    @IBAction func turnOffJoinButtonTabbed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func TabBG(_ sender: Any){
        self.emailText.resignFirstResponder()
        self.passwordText.resignFirstResponder()
        self.numofSchoolText.resignFirstResponder()
    }
}
