//
//  sideInformationViewController.swift
//  SignUp
//
//  Created by 박제균 on 2022/01/12.
//

import UIKit

// MARK: - TODO



class SideInformationViewController : UIViewController, UITextFieldDelegate {
    // MARK: - @IBOutlet
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel! // datePicker 값 변경시 생년월일 label text 변경
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    
    
    // MARK: - @IBAction
    
    // 취소 버튼 누를시 처음 화면으로 이동 -> 싱글톤 객체 값 삭제
    @IBAction func dismissSideInformationModal() {
        
        UserInformation.shared.delete()
        // 모달 2개를 한번에 dismiss 하는 방법을 검색, https://velog.io/@hyesuuou/SwiftiOS-modal-2%EA%B0%9C-%ED%95%9C%EB%B2%88%EC%97%90-dismiss%ED%95%98%EA%B8%B0
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        // present로 모달을 띄워줄때, presentingViewController라는 property가 생기는 것으로

        
    }
    
    // 이전 버튼 누를시
    @IBAction func toPrevModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // datePicker 값 변화되면 string으로 변환후 label text에 나타냄
    @IBAction func didDatePickerChanged(_ sender: UIDatePicker) {
        let date: Date = self.datePicker.date
        let dateString: String = self.dateFormatter.string(from: date)
        self.birthDateLabel.text = dateString
        UserInformation.shared.birthDate = dateString
        checkDateAndPhoneNumber()
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // datePicker : target-action
        self.datePicker.addTarget(self, action: #selector(self.didDatePickerChanged(_:)), for: UIControl.Event.valueChanged)
        
        // delegate
        phoneNumberTextField.delegate = self
        
        // 이전에 저장했던 값을 보여줌
        birthDateLabel.text = UserInformation.shared.birthDate
        phoneNumberTextField.text = UserInformation.shared.phoneNumber
        
        // 버튼 활성화 체크
        checkDateAndPhoneNumber()
        
    }
    
    
    
    
    // MARK: - Methods
    
    // 터치시 edit 종료 처리
    // https://zeddios.tistory.com/132 -> 강의에서 배운 gesture recognizer로 화면터치시 키보드 내리는 방법 외에도 다른 방법이 있다는 것을 알게되었음.
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // edit 종료시 싱글톤 객체의 전화번호 값 업데이트 및 가입 버튼 활성화를 위한 체크
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserInformation.shared.phoneNumber = self.phoneNumberTextField.text
        checkDateAndPhoneNumber()
    }
    
    // 전화번호와 생년월일 체크, 체크되면 버튼활성화
    func checkDateAndPhoneNumber() {
        guard let phoneNumber = UserInformation.shared.phoneNumber else {
            return
        }
        
        guard let birthDate = UserInformation.shared.birthDate else {
            return
        }
        
        if (phoneNumber != "") && (birthDate != "") {
            signUpButton.isUserInteractionEnabled = true
            signUpButton.isEnabled = true
        } else {
            signUpButton.isUserInteractionEnabled = false
            signUpButton.isEnabled = false
        }
        
    }
    
}
