//
//  SubscribeViewController.swift
//  SeSACWeek1617
//
//  Created by 나지운 on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa

class SubscribeViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 탭 > 레이블: "안녕 반가워"
        
        // [case 0] my code
        button.rx.tap
            .map { return "안녕 반가워"}
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        // [case 1]
        button.rx.tap
            .subscribe { [weak self] _ in
                self?.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)

        // [case 2]
        button.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
     
        // [case 3] - 메인 쓰레드 (네트워크 통신이나 파일 다운로드 등 백그라운드에서 작업
        // .observe(on: MainScheduler.instance) 다른 쓰레드로 동작하게 변경
        button.rx.tap
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
    
        
        // [case 4] bind: subscribe, mainSchedular, error x
        button.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // [case 5] - operator로 데이터의 stream 조작
        button.rx.tap
            .map { "안녕 반가워" }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        // [case 6] - driver traits: bind + stream 공유
        button.rx.tap
            .map { "안녕 반가워" }
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        

    }
}
