#  Firebase와 Swift연동(Auth, Database)
## Firebase 인증(Authorization) 라이브러리
대부분의 앱에서 사용자의 신원 정보를 필요로 합니다. 사용자의 신원을 알면 앱이 사용자 데이터를 클라우드에 안전하게 저장할 수 있고 사용자의 모든 기기에서 개인에게 맞춘 동일한 경험을 제공할 수 있기 때문입니다.

Firebase 인증은 앱에서 사용자 인증 시 필요한 백엔드 서비스와 사용하기 쉬운 SDK, 기성 UI 라이브러리를 제공합니다. 비밀번호, 전화번호, 인기 ID 제공업체(예: Google, Facebook, Twitter 등)를 통한 인증이 지원됩니다.

Android, IOS, Node.js, Java, Unity 다양한 플렛폼 지원

## 데이터베이스(Realtime Database) 사용
데이터베이스는 다른 데이터베이스와 다른데 일단 첫번째로 NOSQL 기반의 3세대 데이터베이스이다. 현재 많이 쓰이고 있는 데이터베이스는 Document형식의 빠르고 간편한 NOSQL 기반의 데이터베이스를 도입했다. 또한 다른 데이터베이스와 다르게 RTSP(Real Time Stream Protocol) 방식의 데이터베이스를 지원하고 있다. RTSP는 말 그대로 실시간으로 데이터들을 전송해주는 방식을 말한다. 실시간으로 데이터를 통신하는 데이터베이스라고 생각하시면 된다. 이 방식을 사용하면 소켓 기반 서버를 만들어서 통신하는 것보다 비약적으로 코드의 양이 줄어들게 되어 코드 몇 줄 로도 원하는 구성을 만들 수가 있다.



### 인증(Authorization), 데이터베이스(Realtime Database) 라이브러리 설치
## CocoaPods 란?
 Xcode Dependency(라이브러리) Manager이다 애플에서 정식으로 만든 프로그램은 아니며 Third Party(다른 사용자) 프로그램이다. 라이브러리를 관리할때 Xcode 사용자들이 가장 많이 쓰는 프로그램이기도 하다.
- Cocoapod 설치 Terminal을 켜서 Cocoapod를 설치하자.
`(Back quote) sudo gem install cocoapods

### 파이어베이스 연동 및 인증 라이브러리 설치
1. 터미널을 켜고 cd 명령어를 이용하여 자신의 프로젝트 폴더로 이동한 후
2. 아래와 같이 터미널에 입력한다.
'''bash pod init '''

3. 아래의 명령어를 사용하면 pod파일이 열린다.
'''open podfile '''

4. pod 파일에 아래와같이 pod을 추가해준다.
'''target 'HowlTalk' do
  use_frameworks!
  
#파이어베이스 인증, 데이터베이스 라이브러리 추가
  pod 'Firebase/Auth'
  pod 'FIrebase/Database'
  
  target 'HowlTalkTests' do
    inherit! :search_paths

  end

  target 'HowlTalkUITests' do
    # Pods for testing
  end

end'''

5. pod목록에 있는 라이브러리 설치(마찬가지로 터미널에 입력)
'''pod install'''

6. 프로젝트 폴더에 들어가보면 프로젝트명.xcworkspace가 있을것이다. 이 파일로 작업하면된다.


