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
        
        // cancel 액션은 하나만 사용할 수 있다.
        let cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        let handler: (UIAlertAction) -> Void
        handler = { (action:UIAlertAction) in
            print("action pressed \(action.title ?? "")")
        }
        
        let someAction: UIAlertAction
        someAction = UIAlertAction(title: "Some", style: UIAlertAction.Style.destructive, handler: handler)
        
        let anotherAction: UIAlertAction
        anotherAction = UIAlertAction(title: "Another", style: UIAlertAction.Style.default, handler: handler)
        
        alertController.addAction(someAction)
        alertController.addAction(anotherAction)
        
        // textField는 얼럿에만 사용, 액션시트에는 사용되지 않음
        if alertController.preferredStyle == .alert {
            alertController.addTextField { (field:UITextField) in
                field.placeholder = "placeholder"
                field.textColor = UIColor.blue
            }
        }
        
        self.present(alertController, animated: true) {
            print("Alert Controller shown")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}

