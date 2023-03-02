//
//  Util_UITableView.swift
//  switchwon
//
//  Created by PNX on 2022/08/05.
//

import UIKit

extension UITableView {
    
    /// identifier를 통한 간편 등록
    func register(identifier:String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier:identifier)
    }
    
    /// identifier,indexPath를 통한 간편 테이블 CELL 생성
    func dequeueReusableCell<T:UITableViewCell>(identifier:String, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("테이블 뷰 cell 옵셔널 오류 for indexPath, cell: \(identifier)")
        }
        return cell
    }
    
    /// identifier를 통한 간편 테이블 CELL 생성
    func dequeueReusableCell<T:UITableViewCell>(identifier:String) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? T else {
            fatalError("테이블 뷰 cell 옵셔널 오류, cell: \(identifier)")
        }
        return cell
    }
}

