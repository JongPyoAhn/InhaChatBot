#  FireBase를 이용한 로그인
## 인증(Authorization)라이브러리 사용

1. 이메일 로그인 로직을 만들기 위해서는 Auth Dependencies에 signIn Function을 사용하면 된다.
- [Firebase Document](https://firebase.google.com/docs/auth/ios/start)
```  
Auth.auth().signIn(withEmail: emailText.text!, password: pwText.text!) {  (user, err) in }
```

2. err처리
```
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

```

3. 화면 터치시 키보드 내리기
- touchesBegan() => view에 터치가 발생했음을 알려주는 콜백메소드
- resignFirstResponder() => 선택항목을 포기(?)할 수 있게 해주는 메소드 (키보드가 내려가는 메소드)
```
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailText.resignFirstResponder()
        self.pwText.resignFirstResponder()
    }
```
