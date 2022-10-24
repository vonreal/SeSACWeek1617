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
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setPickerView()
        setSwitch()
        setSign()
    }
    
    func setTableView() {
        
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
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
        .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)

    }
    
    func setPickerView() {
        let items = Observable.just([
                "Movie",
                "Anime",
                "Drama"
            ])
     
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
/*
            .subscribe(onNext: { value in
                print(value)
            })
            와
 
            .bind(to: simpleLabel.rx.text)는 비슷?
 
 */
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setSwitch() {
//        Observable.just(false)
//            .bind(to: simpleSwitch.rx.isOn)
//            .disposed(by: disposeBag)
        
        Observable.of(false)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
    }
    
    func setSign() {
        //ex. signTF(Observable), emailTF(Observable)를 Label에 보여줌(Observer, bind)
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1)이고, 이메일은 \(value2)입니다."
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
    }
}
