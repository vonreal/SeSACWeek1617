//
//  SubjectViewController.swift
//  SeSACWeek1617
//
//  Created by 나지운 on 2022/10/25.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectViewController: UIViewController {

    @IBOutlet weak var newButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let publish = PublishSubject<Int>() // 초기값이 없는 빈 상태
    let behavior = BehaviorSubject(value: 100) // 초기값 필수
    let replay = ReplaySubject<Int>.create(bufferSize: 2) // buffersize 작성된 이벤트 갯수만큼 메모리에서 이벤트를 가지고 있다가, subscribe 직후 한 번에 이벤트를 전달
    let async = AsyncSubject<Int>()
    
    let disposeBag = DisposeBag()
    let viewModel = SubjectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        viewModel.list
            .bind(to: tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.resetData()
            }
            .disposed(by: disposeBag)
        
        newButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.newData()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
//            .distinctUntilChanged() // 같은 값을 받지 않음
            .withUnretained(self)
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) //wait: 사용자의 입력값이 끝나고 1초 후
            .subscribe { (vc, value) in
                print("====\(value)")
                vc.viewModel.filterData(query: value)
            }
            .disposed(by: disposeBag)
    }
}
