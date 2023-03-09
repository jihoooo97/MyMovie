//
//  Actor.swift
//  Common
//
//  Created by 유지호 on 2023/03/05.
//

import Foundation

public class People: Decodable {
    var peopleNm: String?
    var peopleNmEn: String?
}

public class Actor: People {
    var cast: String?
    var castEn: String?
}

public class Director: People { }

public class Staff: People {
    var staffRoleNm: String?
}
