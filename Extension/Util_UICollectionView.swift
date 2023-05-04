//
//  Util_UICollectionView.swift
//  switchwon
//
//  Created by PNX on 2023/03/02.
//

import UIKit

extension UICollectionView {
    
    /// UICollectionViewCell Type 을 통한 간편 등록
    func register(_ cell:UICollectionViewCell.Type) {
        self.register(UINib(nibName: cell.identifier, bundle: nil), forCellWithReuseIdentifier:cell.identifier)
    }
    
    /// UICollectionViewCell Type Array 을 통한 간편 등록
    func register(_ cellArray:[UICollectionViewCell.Type]) {
        cellArray.forEach { cellType in
            self.register(cellType)
        }
    }
    
    /// identifier,indexPath를 통한 간편 테이블 CELL 생성
    func dequeueReusableCell<T:UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("컬랙션 뷰 cell 옵셔널 오류, cell: \(T.identifier)")
        }
        return cell
    }
}
