//
//  ViewController.swift
//  ViewTransition
//
//  Created by 박제균 on 2021/12/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    
    @IBAction func touchUpSetButton(_ sender: UIButton) {
        UserInfomation.shared.name = nameField.text
        UserInfomation.shared.age = ageField.text
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("ViewController가 메모리에 로드되었습니다.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        
        print("ViewController의 view가 화면에 나타날 예정입니다.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        
        print("ViewController의 view가 화면에 나타났습니다.")
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        // Do any additional setup after loading the view.
        
        print("ViewController의 view가 화면에서 사라질 예정입니다.")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Do any additional setup after loading the view.
        
        print("ViewController의 view가 화면에서 사라졌습니다.")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        print("ViewController의 view가 subView를 레이아웃할 예정입니다.")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("ViewController의 view가 subView를 레이아웃 하였습니다.")
    }

}

