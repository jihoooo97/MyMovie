//
//  Actor.swift
//  Common
//
//  Created by 유지호 on 2023/03/05.
//

import Foundation

public protocol People: Codable {
    var peopleNm: String { get }
    var peopleNmEn: String { get }
}

public struct Actor: People {
    public var peopleNm: String
    public var peopleNmEn: String
    var cast: String?
    var castEn: String?
}

public struct Director: People {
    public var peopleNm: String
    public var peopleNmEn: String
}

public struct Staff: People {
    public var peopleNm: String
    public var peopleNmEn: String
    var staffRoleNm: String
}
