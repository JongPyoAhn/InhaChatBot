#  FireBase를 이용한 회원가입
## 인증(Authorization)라이브러리 사용

1. 이메일 회원가입 코드 회원가입 로직을 만들기 위해서는 Auth Dependencies에 createUser Function을 사용하면 된다. (아이디는 이메일, 비밀번호는 6자리 이상 필수)

```bash Auth.auth().createUser(withEmail: email, password: password) (user, err) in } ```

2. 데이터베이스 쓰기
쓰기 작업의 경우에는 setValue를 사용하여 지정된 참조에 데이터를 저장하고 기존 경로의 모든 데이터를 대체할 수 있습니다.
JSON 유형에 해당하는 Map(Dictionary)방식으로 전달 하였습니다.

``` 
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
 ```           
![스크린샷 2021-05-19 오전 12 33 45](https://user-images.githubusercontent.com/68585628/118682805-ba1d5d80-b83b-11eb-9ae5-9d155b426b8e.png)

