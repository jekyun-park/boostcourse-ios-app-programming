//
//  BasicInfomationViewController.swift
//  SignUp
//
//  Created by 박제균 on 2022/01/07.
//

import Foundation
import UIKit

// MARK: - TODO


class BasicInformationViewController : UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    // MARK: - @IBOutlet

    @IBOutlet weak var personalImageView: UIImageView! { // 프로필 사진 image view
        didSet {
            personalImageView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var idTextField: UITextField! // id 버튼
    @IBOutlet weak var passwordTextField: UITextField! // 비밀번호 버튼
    @IBOutlet weak var passwordCheckTextField: UITextField! // 비밀번호 확인 버튼
    
    @IBOutlet weak var cancelButton: UIButton! // 취소버튼
    @IBOutlet weak var confirmButton: UIButton! // 다음버튼
    
    @IBOutlet weak var introduceTextView: UITextView! // 자기소개 textView
    
    // imagePicker
    lazy var personalImagePicker : UIImagePickerController = {
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        return picker
    }()
    
    // MARK: - @IBActions
    
    // 취소 버튼 누를시 action
    @IBAction func dissmissBasicInformationModal() {
        UserInformation.shared.delete()
        self.dismiss(animated: true, completion: nil)
    }
    
    // 프로필 사진 imageview 누를시 imagePicker를 실행하는 action
    @IBAction func touchUpPersonalImageView(_ sender: UITapGestureRecognizer){
        self.present(self.personalImagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // personalImageView를 터치하면 touchUpPersonalImageView를 실행하도록 Gesture Recognizer 설정
        let tapPersonalImageView : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchUpPersonalImageView(_:)))
        
        // 프로필 사진 imageViewd에 Gesture recognizer추가
        personalImageView.addGestureRecognizer(tapPersonalImageView)
        
        // delegate
        idTextField.delegate = self
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
        introduceTextView.delegate = self
    
    }
    
    
    // MARK: - Methods
    
    // 터치시 edit 종료 처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // imagePicker cancel 버튼 종료처리
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // imagePicker 에서 edit한 정보 싱글톤 객체에 저장 및 닫기
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage : UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.personalImageView.image = editedImage
            UserInformation.shared.personalImage = editedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // Edit이 끝나면 싱글톤 객체 값 업데이트 및 다음 버튼 활성화를 위한 정보 체크
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UserInformation.shared.id = self.idTextField.text
        UserInformation.shared.password = self.passwordTextField.text
        UserInformation.shared.passwordCheck = self.passwordCheckTextField.text
        
        checkInformation()

    }
    
    // textView도 Edit 이후 싱글톤 객체 값 업데이트 및 체크
    func textViewDidEndEditing(_ textView: UITextView) {
        UserInformation.shared.selfIntroduce = self.introduceTextView.text
        checkInformation()
    }
    
    // 정보 체크 후 버튼 활성화
    func checkInformation() {
        
        guard let userId = UserInformation.shared.id else {
            return
        }
        
        guard let pw = UserInformation.shared.password else {
            return
        }
        
        guard let pwCheck = UserInformation.shared.passwordCheck else {
            return
        }
        
        guard let introduce = UserInformation.shared.selfIntroduce else {
            return
        }
        
        guard let pimg = UserInformation.shared.personalImage else {
            return
        }
        
        
        if ((userId != "") && (pw != "") && (pwCheck != "") && (introduce != "") && (type(of: pimg) == UIImage.self)) && (pw == pwCheck) {
            confirmButton.isUserInteractionEnabled = true
            confirmButton.isEnabled = true
        } else {
            confirmButton.isUserInteractionEnabled = false
            confirmButton.isEnabled = false
        }
    }
    
    
}
