//
//  SimpleCollectionViewController.swift
//  SeSACWeek1617
//
//  Created by 나지운 on 2022/10/18.
//

import UIKit

class SimpleCollectionViewController: UICollectionViewController {

    var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메 치킨"]
    
    //https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration
    // cellForItemAt 전에 생성되어야 한다. => register 코드와 유사한 역할
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            // 셀 내부 변경
//            var content = cell.defaultContentConfiguration()
            var content = UIListContentConfiguration.valueCell()
            
            content.text = itemIdentifier
            content.textProperties.color = .red
            
            content.secondaryText = "안녕하세용"
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 20
            
            content.image = UIImage(systemName: "person.fill")
            content.imageProperties.tintColor = .yellow
            print("setup")
            cell.contentConfiguration = content
            
            // 셀의 백그라운드를 변경하기
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .clear
            backgroundConfig.strokeColor = .systemPink
            backgroundConfig.strokeWidth = 2
            backgroundConfig.cornerRadius = 10
            cell.backgroundConfiguration = backgroundConfig
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = list[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)

        return cell
    }
}

extension SimpleCollectionViewController {
    
    // layout 자체는 UICollectionViewCompositionalLayout이지만, 반환 자체는 UICollectionViewLayout를 진행한다. (collectionView.collectionViewLayout의 type이 후자이기 때문이다.)
    private func createLayout() -> UICollectionViewLayout {
        // 14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능 (list configuration)
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        // 셀 외부 변경
        configuration.showsSeparators = false
        configuration.backgroundColor = .brown
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
