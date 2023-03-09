//
//  ActorRepository.swift
//  Common
//
//  Created by 유지호 on 2023/03/05.
//

import Foundation
import RxSwift

public protocol ActorRepositoryProtocol {
    func getActorList() -> Single<Actor>
    func getActorInfo() -> Single<Actor>
}

open class ActorRepository {

}
