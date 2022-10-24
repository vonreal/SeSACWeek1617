//
//  RxCocoaExampleViewController.swift
//  SeSACWeek1617
//
//  Created by 나지운 on 2022/10/24.
//

import UIKit

import RxCocoa
import RxSwift // Cannot find 'Observable' in scope.

class RxCocoaExampleViewController: UIViewController {

    @IBOutlet weak var simpleTableView: UITableView!
    @IBOutlet weak var simplePickerView: UIPickerView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setPickerView()
    }
    
    func setTableView() {
        
        simpleTableView.register(UITableView.self, forCellReuseIdentifier: "Cell")
        
        // RxSwift/UITableView+Rx의 Example!
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag) // 구독 취소
    }
    
    func setPickerView() {
        
    }
}
