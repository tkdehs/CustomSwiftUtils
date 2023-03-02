//
//  Util_UICollectionView.swift
//  switchwon
//
//  Created by PNX on 2023/03/02.
//

import UIKit

extension UICollectionView {
    
    /// identifier를 통한 간편 등록
    func register(identifier:String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    /// identifier,indexPath를 통한 간편 테이블 CELL 생성
    func dequeueReusableCell<T:UICollectionViewCell>(identifier:String, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("컬랙션 뷰 cell 옵셔널 오류, cell: \(identifier)")
        }
        return cell
    }
}
