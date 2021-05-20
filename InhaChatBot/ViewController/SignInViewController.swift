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
    @IBOutlet weak var turnOfLoginBtn: UIButton!
    //MARK: -MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signBtn.addTarget(self, action: #selector(signinEvent), for: .touchUpInside)
        turnOfLoginBtn.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
    }
    //MARK: -Method
        //회원가입 버튼 클릭시 이벤트
    @objc func signinEvent(){
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
                    self.cancelEvent()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    //창닫기
    @objc func cancelEvent(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Override
    // 화면 터치 시 키보드 내리기 ( 뷰 컨트롤러에 터치가 시작되는 시점에 동작 )
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailText.resignFirstResponder()
        self.passwordText.resignFirstResponder()
        self.numofSchoolText.resignFirstResponder()
    }
    
}
