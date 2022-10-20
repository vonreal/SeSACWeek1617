//
//  NewViewModel.swift
//  SeSACWeek1617
//
//  Created by 나지운 on 2022/10/20.
//

import Foundation

class NewViewModel {
    
    var pageNumber: CObservable<String> = CObservable("3000")
    
    func changePageNumberFormat(text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let target = Int(text) else { print("🛑 NewViewModel, changePageNumberFormat(), NOT CONVERT INTEGER FROM STRING"); return }
        guard let result = numberFormatter.string(from: target as NSNumber) else { print("🛑 NewViewModel, changePageNumberFormat(), DON'T CONVERT NUMBERFORMAT"); return }
        pageNumber.value = result
    }
}
