//
//  ViewController.swift
//  TapGesture
//
//  Created by 박제균 on 2022/01/07.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
// 1. storyboard (IB)
// 2.
//        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
//        self.view.addGestureRecognizer(tapGesture)
// 3. delegate
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        self.view.endEditing(true)
        return true
    }

}

