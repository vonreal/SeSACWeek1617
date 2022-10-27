//
//  ValidationViewController.swift
//  SeSACWeek1617
//
//  Created by 나지운 on 2022/10/27.
//

import UIKit
import RxSwift

class ValidationViewController: UIViewController {
    
    // 0) Connect outlets.
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    // 1) Create DisposeBag.
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    // 2) When tapped start validation.
    func bind() {
        
        let validation = nameTextField.rx.text  // [TYPE] String?
            .orEmpty                            // [TYPE] String
            .map { $0.count >= 8 }              // [TYPE] Bool
        
        validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        validation
            .bind { [weak self] value in
                let color: UIColor = value ? .white : .lightGray
                self?.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        // Stream == Sequence
        stepButton.rx.tap
            .subscribe { _ in
                print("next")
            } onError: { error in
                print("error")
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("dispose")
            }
            .disposed(by: disposeBag) // resource 제거, dispose 리소스 정리, deinit

    }

}
