//
//  NewsViewController.swift
//  SeSACWeek1617
//
//  Created by 나지운 on 2022/10/20.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    
    var viewModel = NewViewModel()
    let disposeBag = DisposeBag()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierachy()
        configureDataSource()
        bindData()
//        configureViews()     z
    }
    
    func bindData() {
        // 'NewViewModel.swift'에서 생성한 뷰모델의 값을 'NewsViewController.swift'에 보여줘서 최종적으로 값을 반영하여 'View'를 보여주게 됨. viewmodel -> viewcon -> view
//        viewModel.pageNumber.bind { value in
//            self.numberTextField.text = value
//        }
        
        viewModel.sample
            .bind { item in
            var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
            snapshot.appendSections([0])
            snapshot.appendItems(item)
            self.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
        
    }
    
//    func configureViews() {
//        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
//        loadButton.addTarget(self, action: #selector(loadButtonClicked), for: .touchUpInside)
//        resetButton.addTarget(self, action: #selector(resetButtonClicked), for: .touchUpInside)
//
//    }
    
    @objc func numberTextFieldChanged() {
        
        // 변경되는 값을 viewModel에 보내줘서 구분자를 찍고 viewCon에 전달 (viewCon -> viewModel -> viewCon)
        guard let text = numberTextField.text else { return }
        viewModel.changePageNumberFormat(text: text)
    }
    
    @objc func loadButtonClicked() {
        viewModel.loadSample()
    }
    
    @objc func resetButtonClicked() {
        viewModel.resetSample()
    }
}

extension NewsViewController {
    
    func configureHierachy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
    }
    
    func configureDataSource() {
        let cellRegistrtaion = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistrtaion, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(News.items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
