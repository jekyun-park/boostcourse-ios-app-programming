//
//  SecondViewController.swift
//  ViewTransition
//
//  Created by 박제균 on 2021/12/22.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = UserInfomation.shared.name
        self.ageLabel.text = UserInfomation.shared.age
        
        // Do any additional setup after loading the view.
        
        print("SecondViewController가 메모리에 로드되었습니다.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        
        print("SecondViewController의 view가 화면에 나타날 예정입니다.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        
        print("SecondViewController의 view가 화면에 나타났습니다.")
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        // Do any additional setup after loading the view.
        
        print("SecondViewController의 view가 화면에서 사라질 예정입니다.")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Do any additional setup after loading the view.
        
        print("SecondViewController의 view가 화면에서 사라졌습니다.")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        print("SecondViewController의 view가 subView를 레이아웃할 예정입니다.")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("SecondViewController의 view가 subView를 레이아웃 하였습니다.")
    }
    
    @IBAction func popToPrev() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dissmissModal() {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
