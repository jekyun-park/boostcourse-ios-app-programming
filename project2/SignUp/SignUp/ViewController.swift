//
//  ViewController.swift
//  SignUp
//
//  Created by 박제균 on 2022/01/07.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUPButton: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        idTextField.text = UserInformation.shared.id
    }
    
    override func viewWillAppear(_ animated: Bool) {
        idTextField.text = UserInformation.shared.id
    }
    
    // MARK: - Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // [x] 플레이스홀더
    // [x] 로그인/회원가입 버튼
    // [x] 로그인버튼 기능 X , 회원가입 버튼 -> 화면2로 전환

    

}

