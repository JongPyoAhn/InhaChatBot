# 파이어베이스를 이용한 친구목록 불러오기 (관리자 아이디 불러오기)
## 친구목록 불러오기(Function)
### 데이터 읽기
데이터를 읽어오는 방법은 2가지가 있습니다. 첫번째는 데이터를 한번만 읽어오는 방식이 있으며 두번째는 데이터베이스를 실시간으로 항상 지켜보는 방식이 있습니다.
- observeSingleEvent => 갱신이 필요하지 않은 데이터를 불러올때 많이 사용합니다.
- observe => 채팅이나 메세지 혹은 게임을 만들때 가장 많이 사용합니다.

```
 func loadPeopleList(){
        Database.database().reference().child("users").observe(DataEventType.value, with: { (snapshot) in
            self.array.removeAll() //친구목록 갱신을 위해 친구목록 배열을 지움
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
```
## 방 생성(Function)
```
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
```


## Protocol(tableView)
```
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
            Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/"+myUid!).queryEqual(toValue: true).observeSingleEvent(of:    DataEventType.value,with: {
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
    
```
## Segue
```
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
```



