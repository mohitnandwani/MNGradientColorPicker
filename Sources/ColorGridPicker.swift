//
//  MNGradientColorPicker
//
//  Copyright (c) 2022-Present Mohit Nandwani - https://github.com/mohitnandwani/MNGradientColorPicker
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

protocol ColorGridPickerDelegate: AnyObject {
    func selectColor(with color: UIColor)
}

class ColorGridPicker: UIView, UICollectionViewDelegate {
    
    weak var delegate: ColorGridPickerDelegate?
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, MNHexColor>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, MNHexColor>
    
    var hexColors = MNHexColor.colors
    
    lazy var gridCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFlowLayout())
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.isDirectionalLockEnabled = true
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ColorPickerGridCell.self, forCellWithReuseIdentifier: ColorPickerGridCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    fileprivate lazy var dataSource = makeDataSource()
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer!
    
    fileprivate func createFlowLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/12), heightDimension: .fractionalWidth(1/12)))
            item.edgeSpacing = .init(leading: .fixed(0), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(0))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0)), subitems: [item])
            group.interItemSpacing = .fixed(0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.leading = 0
            section.contentInsets.trailing = 0
            section.contentInsets.bottom = 0
            return section
        }, configuration: .init())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        applySnapshot()
        
        setupColor(with: nil)
    }
    
    fileprivate var selectedIndexPath: IndexPath?
    
    func setupColor(with color: UIColor?) {
        guard let color = color else { return }
        DispatchQueue.main.async { [weak self] in
            if let index = self?.hexColors.firstIndex(where: { $0.hex.lowercased() == color.hexString.lowercased() }) {
                self?.selectedIndexPath = IndexPath(item: index, section: 0)
                self?.gridCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .init())
            } else {
                if let selectedIndexPath = self?.selectedIndexPath {
                    self?.gridCollectionView.deselectItem(at: selectedIndexPath, animated: true)
                }
            }
        }
    }
    
    fileprivate func setupCollectionView() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        gridCollectionView.addGestureRecognizer(panGestureRecognizer)
        
        addSubview(gridCollectionView)
        NSLayoutConstraint.activate([
            gridCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gridCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridCollectionView.topAnchor.constraint(equalTo: topAnchor),
            gridCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc
    fileprivate func handleTap(_ gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.location(in: gridCollectionView)
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed || gestureRecognizer.state == .ended {
            if let indexPath = gridCollectionView.indexPathForItem(at: location) {
                selectedIndexPath = indexPath
                let colorHex = "#"+hexColors[indexPath.item].hex
                guard let color = UIColor(hex: colorHex) else { return }
                delegate?.selectColor(with: color)
            }
        }
    }
    
    fileprivate func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: gridCollectionView) { (collectionView, indexPath, hexColor) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorPickerGridCell.reuseIdentifier, for: indexPath) as? ColorPickerGridCell
            cell?.backgroundColor = UIColor(hex: "#"+hexColor.hex)
            return cell
        }
        return dataSource
    }
    
    fileprivate func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(hexColors)
        dataSource.apply(snapshot)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hexColor = UIColor(hex: "#"+hexColors[indexPath.item].hex)
        else { return }
        delegate?.selectColor(with: hexColor)
        selectedIndexPath = indexPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        panGestureRecognizer = nil
        hexColors = []
        selectedIndexPath = nil
    }
    
}
