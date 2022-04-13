//
//  ViewController.swift
//  AutoLayoutExample
//
//  Created by 박제균 on 2021/12/08.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.translatesAutoresizingMaskIntoConstraints = false

        var constraintX: NSLayoutConstraint
        constraintX = button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)

        var constraintY: NSLayoutConstraint
        constraintY = button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)

        constraintX.isActive = true
        constraintY.isActive = true
        
        // 만든 constrain를 적용하려면 .isActive = true
        
        
        // 버튼 중앙 배치 --> 버튼의 수평 수직 중앙 앵커를 뷰컨트롤러의 뷰의 중앙에 기준으로 함
        
        label.translatesAutoresizingMaskIntoConstraints = false
        // 오토레이아웃 도입 이전에 뷰를 유연하게 표현하도록 사용하던 기술, 오토레이아웃을 사용하면 기존의 오토리사이징 마스크가 가지고 있던 제약조건이 자동으로 추가, 충돌할 수도 있기 때문에 false로 지정함. IB에서 오토레이아웃을 적용한 경우 자동으로 false가 됨
        
        var buttonConstraintX: NSLayoutConstraint
        buttonConstraintX = label.centerXAnchor.constraint(equalTo: button.centerXAnchor)
//
//
        var topConstraint: NSLayoutConstraint
        topConstraint = label.bottomAnchor.constraint(equalTo: button.topAnchor,constant: -10)
//         label의 bottom을 button의 top에서 -10 만큼 떨어지도록
        
        buttonConstraintX.isActive = true
        topConstraint.isActive = true
 
        

//        var widthConstraint: NSLayoutConstraint
//        widthConstraint = label.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 2.0)
        // label의 너비를 버튼의 너비의 2배로 설정
        
//        var heightConstraint: NSLayoutConstraint
//        heightConstraint = button.heightAnchor.constraint(equalTo: label.heightAnchor, multiplier: 2.0)
//        // button 의 높이를 label 높이의 2배로 설정
        
        
//        label.backgroundColor = UIColor.brown
//        button.backgroundColor = UIColor.blue
//
//        widthConstraint.isActive = true
//        heightConstraint.isActive = true
        
        
        
        
        
        
    }
    
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    
}

