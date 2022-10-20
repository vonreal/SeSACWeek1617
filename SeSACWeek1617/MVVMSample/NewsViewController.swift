//
//  NewsViewController.swift
//  SeSACWeek1617
//
//  Created by 나지운 on 2022/10/20.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = NewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        numberTextField.text = "3000"
        
        // 'NewViewModel.swift'에서 생성한 뷰모델의 값을 'NewsViewController.swift'에 보여줘서 최종적으로 값을 반영하여 'View'를 보여주게 됨. viewmodel -> viewcon -> view
        viewModel.pageNumber.bind { value in
            self.numberTextField.text = value
        }
        
        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
    }
    
    @objc func numberTextFieldChanged() {
        
        // 변경되는 값을 viewModel에 보내줘서 구분자를 찍고 viewCon에 전달 (viewCon -> viewModel -> viewCon)
        guard let text = numberTextField.text else { return }
        viewModel.changePageNumberFormat(text: text)
    }
}

extension NewsViewController {
    
}
