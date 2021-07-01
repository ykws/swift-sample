import UIKit
import IBPCollectionViewCompositionalLayout

class NestedGroupCollectionViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case main
    }
    
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nested Groups"
        configureHierarchy()
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // collectionView.backgroundColor = .systemBackground
        collectionView.register(cellType: NestedGroupCollectionViewCell.self)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func createLayout() -> UICollectionViewLayout {
        // 画像の比率を可変に対応
        let squareRaito: CGFloat = 1 / 1
        let itemSpacing: CGFloat = 1
        let viewWidth: CGFloat = view.bounds.width
        // 小数の演算だとレイアウトが崩れるので小数点以下を切り上げて整数を扱う
        let smallSquareWidth: CGFloat = ceil((viewWidth - itemSpacing * 2) / 3)
        let smallSquareHeight: CGFloat = smallSquareWidth * squareRaito
        // 一番右端は少し小さめにする
        let moreSmallSquareWidth: CGFloat = viewWidth - (smallSquareWidth * 2 + itemSpacing * 2)
        let mediumSquareWidth: CGFloat = viewWidth - (moreSmallSquareWidth + itemSpacing)
        let mediumSquareHeight: CGFloat = smallSquareHeight * 2 + itemSpacing

        
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let smallSquareItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(smallSquareWidth),
                                                   heightDimension: .fractionalHeight(0.5)))
            let smallSquareGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(smallSquareWidth),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: smallSquareItem, count: 2)
            smallSquareGroup.interItemSpacing = .fixed(itemSpacing)
            
            let moreSmallSquareItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(moreSmallSquareWidth),
                                                   heightDimension: .fractionalHeight(0.5)))
            let moreSmallSquareGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(moreSmallSquareWidth),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: moreSmallSquareItem, count: 2)
            moreSmallSquareGroup.interItemSpacing = .fixed(itemSpacing)

            let nestedGroupTypeA: NSCollectionLayoutGroup = {
                let mediumSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(moreSmallSquareWidth),
                                                       heightDimension: .fractionalHeight(1.0)))

                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(mediumSquareHeight)),
                    subitems: [smallSquareGroup, smallSquareGroup, mediumSquareItem])
                nestedGroup.interItemSpacing = .fixed(itemSpacing)

                return nestedGroup
            }()
            
            let nestedGroupTypeB: NSCollectionLayoutGroup = {
                let mediumSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(mediumSquareWidth),
                                                       heightDimension: .fractionalHeight(1.0)))

                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(mediumSquareHeight)),
                    subitems: [mediumSquareItem, moreSmallSquareGroup])
                nestedGroup.interItemSpacing = .fixed(itemSpacing)

                return nestedGroup
            }()
            
            let nestedGroupTypeC: NSCollectionLayoutGroup = {
                let smallSquareGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(mediumSquareHeight)),
                    subitems: [smallSquareGroup, smallSquareGroup, moreSmallSquareGroup])
                smallSquareGroup.interItemSpacing = .fixed(itemSpacing)
                
                return smallSquareGroup
            }()
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(mediumSquareHeight * 4 + itemSpacing * 3)),
                subitems: [nestedGroupTypeA, nestedGroupTypeC, nestedGroupTypeB, nestedGroupTypeC])
            group.interItemSpacing = .fixed(itemSpacing)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = itemSpacing
            return section

        }
        return layout
    }
}

extension NestedGroupCollectionViewController: UICollectionViewDelegate {}

extension NestedGroupCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 27
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Invalid section") }
        switch section {
        case .main:
            let cell = collectionView.dequeueReusableCell(with: NestedGroupCollectionViewCell.self, for: indexPath)
            cell.update(text: "\(indexPath.section), \(indexPath.row)")
            return cell
        }
    }
}
