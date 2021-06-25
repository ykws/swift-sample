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
        let smallSquareWidth: CGFloat = (viewWidth - itemSpacing * 2) / 3
        let smallSquareHeight: CGFloat = smallSquareWidth * squareRaito
        let mediumSquareWidth: CGFloat = smallSquareWidth * 2 + itemSpacing
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
            smallSquareGroup.interItemSpacing = .fixed(1)

            let nestedGroupTypeA: NSCollectionLayoutGroup = {
                let mediumSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(smallSquareWidth),
                                                       heightDimension: .fractionalHeight(1.0)))

                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(mediumSquareHeight)),
                    subitems: [smallSquareGroup, smallSquareGroup, mediumSquareItem])
                nestedGroup.interItemSpacing = .fixed(1)

                return nestedGroup
            }()
            
            let nestedGroupTypeB: NSCollectionLayoutGroup = {
                let mediumSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(mediumSquareWidth),
                                                       heightDimension: .fractionalHeight(1.0)))

                let nestedGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(mediumSquareHeight)),
                    subitems: [mediumSquareItem, smallSquareGroup])
                nestedGroup.interItemSpacing = .fixed(1)

                return nestedGroup
            }()
            
            let nestedGroupTypeC: NSCollectionLayoutGroup = {
                let smallSquareItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(smallSquareWidth),
                                                       heightDimension: .fractionalHeight(1.0)))

                let smallSquareGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(smallSquareHeight)),
                    subitem: smallSquareItem,
                    count: 3)
                smallSquareGroup.interItemSpacing = .fixed(1)
                
                return smallSquareGroup
            }()
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(mediumSquareHeight * 2 + smallSquareHeight * 4 + itemSpacing * 5)),
                subitems: [nestedGroupTypeA, nestedGroupTypeC, nestedGroupTypeC, nestedGroupTypeB, nestedGroupTypeC, nestedGroupTypeC])
            group.interItemSpacing = .fixed(1)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 1
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
