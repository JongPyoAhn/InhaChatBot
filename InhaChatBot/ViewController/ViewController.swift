//
//  ViewController.swift
//  InhaChatBot
//
//  Created by 안종표 on 2021/05/06.
//

import UIKit
import SnapKit
class ViewController: UIViewController {

    var Logo = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(Logo)
        Logo.snp.makeConstraints{
            (make) in make.center.equalTo(self.view)
        }
        Logo.image = #imageLiteral(resourceName: "InhaLogo")
//        로그인화면 띄우기전 1초간 딜레이
        perform(#selector(loginDisplay), with: nil, afterDelay: 1)
    }
//    Login화면으로 전환
    @objc func loginDisplay(){
        let loginVC = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.present(loginVC, animated: false, completion: nil)
    }

}

