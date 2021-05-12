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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myUid = Auth.auth().currentUser?.uid
        loadPeopleList()
    }
//    굳이 따로 관리자를 유저목록에서 검색하는 이유는 보안때문
    func loadPeopleList(){
        Database.database().reference().child("users").observe(DataEventType.value, with: { (snapshot) in
            self.array.removeAll()
            for child in snapshot.children{ //snapshot.children = 등록된 사용자 목록(user바로아래 값들)
                let fchild = child as! DataSnapshot
                let dic = fchild.value as! [String : Any]
                let userModel = UserModel(JSON: dic)
                if(userModel?.StudentID == "관리자")
                {
                self.array.append(userModel!)
                }
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        })
    }
    
    //테이블뷰 선택 이벤트(Delegate)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //한마디로 users/myuid에서 true값인 것을 반환해준다는것.
            //observeSingleEvent는 그냥 데이터한번 읽는거임.
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




 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if(segue.identifier == "QuestionChatSegue"){
        let vc = segue.destination as? QuestionViewController
        vc?.chatRoomUid = chatRoomUid
        vc?.myUid = myUid
        vc?.destinationUid = destinationUid
    }
 }
}
    
class PersonCell :UITableViewCell{
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var name: UILabel!
}
// 채팅방은 만드는게 맞음. 채팅방생성을 해주는데. 그게 관리자랑의 채팅방만 생기면됨. 굳이 데이베이스로 딴사람데이터 읽어올 필요가 없음
//QuestionViewController로 이동하면 됨.
//상대가 관리자랑의 채팅방만 잇으면된다.
//애초에 내가 채팅방 uid를 지정해놓고 거기로들어가면된다.
//먼저 내가 소속된 방들을 검색
//queryordered는 users/myuid로 결과를 정렬
//queryEqual은 값 == tovalue의 값 인 결과를 반환해줌.

