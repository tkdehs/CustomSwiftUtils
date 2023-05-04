//
//  Util_UITableView.swift
//  switchwon
//
//  Created by PNX on 2022/08/05.
//

import UIKit

extension UITableView {
    
    /// UITableViewCell Type 을 통한 간편 등록
    func register(_ cell:UITableViewCell.Type) {
        self.register(UINib(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier:cell.identifier)
    }
    
    /// UITableViewCell Type Array 을 통한 간편 등록
    func register(_ cellArray:[UITableViewCell.Type]) {
        cellArray.forEach { cellType in
            self.register(cellType)
        }
    }
    
    /// UITableViewHeaderFooterView Type 을 통한 간편 등록
    func register(_ view:UITableViewHeaderFooterView.Type) {
        self.register(view.self, forHeaderFooterViewReuseIdentifier: view.identifier)
    }
    
    func registerNib(_ view:UITableViewHeaderFooterView.Type) {
        self.register(UINib(nibName: view.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: view.identifier)
    }
    
    /// identifier,indexPath를 통한 간편 테이블 CELL 생성
    func dequeueReusableCell<T:UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("테이블 뷰 cell 옵셔널 오류 for indexPath, cell: \(T.identifier)")
        }
        return cell
    }
    
    /// identifier를 통한 간편 테이블 CELL 생성
    func dequeueReusableCell<T:UITableViewCell>() -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier) as? T else {
            fatalError("테이블 뷰 cell 옵셔널 오류, cell: \(T.identifier)")
        }
        return cell
    }
    
    /// identifier를 통한 간편 Header Footer view 생성
    func dequeueReusableHeaderFooterView<T:UITableViewHeaderFooterView>() -> T {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T else {
            fatalError("테이블 뷰 UITableViewHeaderFooterView 옵셔널 오류, UITableViewHeaderFooterView: \(T.identifier)")
        }
        return view
    }
    
}

