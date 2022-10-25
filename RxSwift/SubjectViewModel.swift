//
//  SubjectViewModel.swift
//  SeSACWeek1617
//
//  Created by 나지운 on 2022/10/25.
//

import Foundation
import RxSwift

struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel {
    
    var contactData = [
        Contact(name: "Jack", age: 21, number: "01012341234"),
        Contact(name: "Hue", age: 23, number: "01011112222"),
        Contact(name: "Real Jack", age: 25, number: "01033334444")
    ]
    
    var list = PublishSubject<[Contact]>()
    
    func fetchData() {
        list.onNext(contactData)
    }
    
    func resetData() {
        list.onNext([])
    }
    
    func newData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...50), number: "")
//        list.onNext([new]) // 덮어쓰기가 되어버림.
        contactData.append(new)
        list.onNext(contactData)
    }
    
    func filterData(query: String) {
        let result = query != "" ? contactData.filter { $0.name.contains(query) } : contactData
        list.onNext(result)
    }
}
