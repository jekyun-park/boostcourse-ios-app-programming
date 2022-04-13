//
//  ViewController.swift
//  ViewArchitecture
//
//  Created by 박제균 on 2021/12/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewRectangle = CGRect(x: 100, y: 100, width: 200, height: 200)
        let subView = UIView(frame: viewRectangle)
        
        subView.backgroundColor = UIColor.green
        
        print("서브뷰의 프레임의 CGRect : \(subView.frame)")
        // superview의 좌표계를 기준으로 해당 뷰의 center 의 좌표
        print("center : \(subView.center)")
        
        print("서브뷰의 바운드의 CGRect : \(subView.bounds)")
        
        print("서브뷰의 프레임 Origin : \(subView.frame.origin)")
        print("서브뷰의 바운드 Origin : \(subView.bounds.origin)")
        
        self.view.addSubview(subView)
        
    }


}

