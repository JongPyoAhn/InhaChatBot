//
//  AccountViewController.swift
//  InhaChatBot
//
//  Created by 안종표 on 2021/05/07.
//

import UIKit
import Firebase

class AccountViewController: UIViewController{

    var uid: String?
    var email: String?
    var password: String?
    var studentID: String?
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var StudentIDText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        bringEmail()
        bringstudentID()
        logoutBtn.addTarget(self, action: #selector(logoutEvent), for: .touchUpInside)
//        confirmBtn.addTarget(self, action: #selector(changePassword(email:currentPassword:newPassword:completion:)), for: .touchUpInside)
    }
    
    //현재 접속한 사용자의 email정보 가져오기
    func bringEmail(){
        let user = Auth.auth().currentUser
        if let user = user {
            email = user.email
            uid = user.uid
            
            emailText.text = email
        }
    }
    
    @IBAction func confirmEvent(_ sender: UIButton) {
    }
    //현재 접속한 사용자의 학번 가져오기
    func bringstudentID(){
        let refStudentID = Database.database().reference().child("users")
        refStudentID.observeSingleEvent(of: DataEventType.value, with: {
            (snapshot) in
            for child in snapshot.children{
                let fchild = child as! DataSnapshot
                let dic = fchild.value as! [String : Any]
                let userModel = UserModel(JSON: dic)
                // snapshot을 이용해서 파베에 저장된 모든 유저 데이터(snapshot)중 현재 사용자 uid랑 같은 studentID 구하기
                if(userModel?.uid == self.uid){
                    self.studentID = userModel?.StudentID
                    self.StudentIDText.text = self.studentID
                }
            }
        })
    }
    //비밀번호 변경
    func changePassword(email: String, currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                if let error = error {
                    completion(error)
                }
                else {
                    Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                        completion(error)
                    })
                }
            })
        }
    
    @objc func confirm(){
        changePassword(email: email!, currentPassword: password!, newPassword: passwordText.text!, completion: {
            (error) in
            if(error == nil){
            print("error")
            }
        })
    }
    
    @objc func logoutEvent(){
        self.dismiss(animated: true, completion: nil)
    }
        
}



// 다음할일 확인버튼에 이벤트넣기
