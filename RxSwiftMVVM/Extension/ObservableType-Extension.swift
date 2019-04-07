//
//  ObservableType-Extension.swift
//  RxSwiftMVVM
//
//  Created by soom on 07/04/2019.
//  Copyright © 2019 cashwalk. All rights reserved.
//

import RxCocoa
import RxSwift

extension ObservableType {
    
    func asDriverComplete() -> SharedSequence<DriverSharingStrategy, E> {
        return asDriver(onErrorRecover: { (error)  in
            return Driver.empty()
        })
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
