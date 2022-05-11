//
//  UserInformation.swift
//  BoxOffice
//
//  Created by 박제균 on 2022/05/11.
//

import Foundation

class UserInformation {
    static let shared: UserInformation = UserInformation()

    var nickName: String?
    var orderType: Int? = 0
}
