//
//  UserInfomation.swift
//  SignUp
//
//  Created by 박제균 on 2022/01/07.
//


import UIKit

class UserInformation {
    static let shared: UserInformation = UserInformation()
    
    var id: String?
    var password: String?
    var passwordCheck: String?
    var selfIntroduce: String? // 자기소개
    
    var phoneNumber: String? // 전화번호
    var birthDate: String? // 생년월일
    
    var personalImage: UIImage? // 프로필 이미지
    
    func delete() { // 취소 버튼을 눌렀을때 싱글톤 객체 정보 초기화를 위한 함수
        self.id = nil
        self.password = nil
        self.passwordCheck = nil
        self.selfIntroduce = nil
        
        self.phoneNumber = nil
        self.birthDate = nil
        
        self.personalImage = nil
    }
    
    private init() {}
    
    
}
