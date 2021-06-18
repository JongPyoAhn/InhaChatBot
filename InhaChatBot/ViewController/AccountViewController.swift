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
    var currentPassowrd: String?
    
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
        confirmBtn.addTarget(self, action: #selector(changePW), for: .touchUpInside)
        
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
    @objc func changePW(){
        Auth.auth().currentUser?.updatePassword(to: passwordText.text!) {
            (error) in
            if let error = error {
                print(error)
            }else{
                let alert = UIAlertController(title: "비밀번호변경", message: "비밀번호 변경이 완료되었습니다!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func logoutEvent(){
        self.dismiss(animated: true, completion: nil)
    }
        
    // 화면 터치 시 키보드 내리기 ( 뷰 컨트롤러에 터치가 시작되는 시점에 동작 )
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.passwordText.resignFirstResponder()
    }
}



// 다음할일 확인버튼에 이벤트넣기
