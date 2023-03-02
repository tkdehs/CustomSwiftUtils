//
//  Util_UITableViewCell.swift
//  CodeAble
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
	override open func awakeFromNib() {
		super.awakeFromNib()
		/// 셀렉션 제거
		selectionStyle = .none
        localization(self.contentView)
	}
    
    func localization(_ parentView: UIView) {
        for view in parentView.subviews {
            if view is UILabel {
                localizationWithLable(view as! UILabel)
            } else if view is UIButton {
                localizationWithButton(view as! UIButton)
            } else if view is UITextField {
                localizationWithTextField(view as! UITextField)
            } else if view.subviews.count != 0 {
                localization(view)
            }
        }
    }
    
    private func localizationWithLable(_ label: UILabel) {
        let localization = label.text

        if localization == nil {
            return
        }

        label.text = NSLocalizedString(localization!, comment: "")
    }
    
    private func localizationWithButton(_ button: UIButton) {
        let localization = button.titleLabel?.text

        if localization == nil {
            return
        }

        let title = NSLocalizedString(localization!, comment: "")
        button.setTitle(title, for: .normal)
    }
    
    private func localizationWithTextField(_ textField: UITextField) {
        let localization = textField.placeholder
        if localization == nil {
            return
        }
        let placeholder = NSLocalizedString(localization!, comment: "")
        textField.placeholder = placeholder
    }
}

