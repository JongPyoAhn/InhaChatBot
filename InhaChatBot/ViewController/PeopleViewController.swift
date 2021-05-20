//
//  PeopleViewController.swift
//  InhaChatBot
//
//  Created by 안종표 on 2021/05/08.
//

import UIKit
import Firebase

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
  
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var chatbotBtn: UIButton!
    
    
    //친구목록 어레이
    var array : [UserModel] = []
    //다음화면 페이지 Flag값
    let QuestionChatSeuge = "QuestionChatSeuge"
    //채팅방 UID
    var chatRoomUid : String?
    //나의 UID
    var myUid : String?
    //상대방 UID
    var destinationUid : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myUid = Auth.auth().currentUser?.uid
        loadPeopleList()
        chatbotBtn.addTarget(self, action: #selector(moveChatbot), for: .touchUpInside)
    }
    //MARK: -Protocol(tableView)
    //테이블뷰 갯수 (Datasource)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    //테이블뷰 셀 지정(Datasource)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
            let item = self.array[indexPath.row]
            cell.name.text = item.StudentID
            return cell
    }
    
    //테이블뷰 선택 이벤트(Delegate)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //내가 소속된 방 검색
            destinationUid = self.array[indexPath.row].uid
            Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/"+myUid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value,with: {
                (datasnapshot) in
            //방이 없을때
                if(datasnapshot.children.allObjects.count == 0){
                    self.createRoom(uid: self.myUid!, destinationUid: self.destinationUid!)
                }else{
                //방이 있을때
                    self.chatRoomUid = nil
                    for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                        let chatRoomdic = item.value as! [String:AnyObject]
                        let chatModel = ChatModel(JSON: chatRoomdic)
                        if(chatModel?.users[self.destinationUid!] == true){
                        ////내가 선택한 사람의 방이 존재할때
                            self.chatRoomUid = item.key
                            self.performSegue(withIdentifier: "QuestionChatSegue", sender: nil)
                            break
                        }
                }
                if(self.chatRoomUid == nil)
                {
                    //다시 생성
                    self.createRoom(uid: self.myUid!, destinationUid: self.destinationUid!)
                }
            }
            })
    }
    //MARK: - 친구목록생성 Function
    func loadPeopleList(){
        Database.database().reference().child("users").observe(DataEventType.value, with: { (snapshot) in
            self.array.removeAll()
            for child in snapshot.children{ //snapshot.children = 등록된 사용자 목록(user바로아래 값들)
                let fchild = child as! DataSnapshot
                let dic = fchild.value as! [String : Any]
                let userModel = UserModel(JSON: dic)
                if(userModel?.StudentID == "관리자"){
                    self.array.append(userModel!)
                    print(self.array.count)
                }
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        })
    }
   
    
    // 방 생성 코드
    func createRoom(uid : String, destinationUid : String){
        let createRoomInfo : Dictionary<String,Any> = [ "users" : [
            uid: true,
            destinationUid :true
            ]
        ]
        
        Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo, withCompletionBlock: { (err, ref) in
            self.chatRoomUid = ref.key
            self.performSegue(withIdentifier: "QuestionChatSegue", sender: nil)
        })
    }
    //MARK: -Segue
    // 챗봇페이지로 이동
    @objc func moveChatbot(){
        performSegue(withIdentifier: "chatbotSegue", sender: nil)
    }
 //QuestionView로 이동시 값 전달
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == "QuestionChatSegue"){
        let vc = segue.destination as? QuestionViewController
        vc?.chatRoomUid = chatRoomUid
        vc?.myUid = myUid
        vc?.destinationUid = destinationUid
    }
 }
}

//customCell
class PersonCell :UITableViewCell{
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var name: UILabel!
}

