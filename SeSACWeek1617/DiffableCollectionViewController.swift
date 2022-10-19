//
//  DiffableCollectionViewController.swift
//  SeSACWeek1617
//
//  Created by 나지운 on 2022/10/19.
//

import UIKit

class DiffableCollectionViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var list = ["아이폰", "아이패드", "에어팟", "맥북", "애플 워치"]
    
//    private var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, String>!
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        
        collectionView.delegate = self
        searchBar.delegate = self
    }
}

extension DiffableCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let alert = UIAlertController(title: item, message: "클릭 ~", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}


extension DiffableCollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([searchBar.text!])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension DiffableCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String>(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier
            content.secondaryText = "\(itemIdentifier.count)"
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.strokeWidth = 2
            background.strokeColor = .brown
            cell.backgroundConfiguration = background
        })
        
        // numberOfItemsInSection, CellForItemAt
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        // Initial
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)
    }
}
