//
//  ViewController.swift
//  AlertExample
//
//  Created by 박제균 on 2022/04/12.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBActions
    
    @IBAction func touchUpShowAlertButton(_ sender:UIButton) {
        self.showAlertController(UIAlertController.Style.alert)
    }
    
    @IBAction func touchUpShowActionSheetButton(_ sender:UIButton) {
        self.showAlertController(UIAlertController.Style.actionSheet)
    }
    
    func showAlertController(_ style: UIAlertController.Style) {
        let alertController: UIAlertController
        alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: style)
        
        let okAction: UIAlertAction
        okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { UIAlertAction in
            print("Ok Pressed")
        })
        
        let cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {
            print("Alert Controller shown")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}

