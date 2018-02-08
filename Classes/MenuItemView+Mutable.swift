//
//  MenuItemView+Mutable.swift
//  PageMenu
//
//  Created by Jesse Hao on 2018/2/8.
//  Copyright © 2018年 Center for Advanced Public Safety. All rights reserved.
//

import Foundation

extension MenuItemView {
	func reconfigure(for pageMenu: CAPSPageMenu, controller: UIViewController, index: CGFloat) {
		self.titleLabel?.removeFromSuperview()
		self.menuItemSeparator?.removeFromSuperview()
		self.configure(for: pageMenu, controller: controller, index: index)
	}
}
