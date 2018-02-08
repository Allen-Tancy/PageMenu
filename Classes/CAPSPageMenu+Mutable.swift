//
//  CAPSPageMenu+Mutable.swift
//  PageMenu
//
//  Created by Jesse Hao on 2018/2/8.
//  Copyright © 2018年 Center for Advanced Public Safety. All rights reserved.
//

import UIKit

extension CAPSPageMenu {
	
	public func append(viewController: UIViewController) {
		self.controllerArray.append(viewController)
		
		controllerScrollView.contentSize.width += self.view.frame.width
		
		let index:CGFloat = CGFloat(self.controllerArray.count - 1)
		var menuItemFrame : CGRect = CGRect()
		
		if configuration.useMenuLikeSegmentedControl {
			//**************************拡張*************************************
			if menuItemMargin > 0 {
				let marginSum = menuItemMargin * CGFloat(controllerArray.count + 1)
				let menuItemWidth = (self.view.frame.width - marginSum) / CGFloat(controllerArray.count)
				menuItemFrame = CGRect(x: CGFloat(menuItemMargin * (index + 1)) + menuItemWidth * CGFloat(index), y: 0.0, width: CGFloat(self.view.frame.width) / CGFloat(controllerArray.count), height: configuration.menuHeight)
			} else {
				menuItemFrame = CGRect(x: self.view.frame.width / CGFloat(controllerArray.count) * CGFloat(index), y: 0.0, width: CGFloat(self.view.frame.width) / CGFloat(controllerArray.count), height: configuration.menuHeight)
			}
			//**************************拡張ここまで*************************************
		} else if configuration.menuItemWidthBasedOnTitleTextWidth {
			let controllerTitle : String? = viewController.title
			
			let titleText : String = controllerTitle != nil ? controllerTitle! : "Menu \(Int(index) + 1)"
			let itemWidthRect : CGRect = (titleText as NSString).boundingRect(with: CGSize(width: 1000, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:configuration.menuItemFont], context: nil)
			configuration.menuItemWidth = itemWidthRect.width
			
			menuItemFrame = CGRect(x: totalMenuItemWidthIfDifferentWidths + configuration.menuMargin + (configuration.menuMargin * index), y: 0.0, width: configuration.menuItemWidth, height: configuration.menuHeight)
			
			totalMenuItemWidthIfDifferentWidths += itemWidthRect.width
			menuItemWidths.append(itemWidthRect.width)
		} else {
			if configuration.centerMenuItems && index == 0.0  {
				startingMenuMargin = ((self.view.frame.width - ((CGFloat(controllerArray.count) * configuration.menuItemWidth) + (CGFloat(controllerArray.count - 1) * configuration.menuMargin))) / 2.0) -  configuration.menuMargin
				
				if startingMenuMargin < 0.0 {
					startingMenuMargin = 0.0
				}
				
				menuItemFrame = CGRect(x: startingMenuMargin + configuration.menuMargin, y: 0.0, width: configuration.menuItemWidth, height: configuration.menuHeight)
			} else {
				menuItemFrame = CGRect(x: configuration.menuItemWidth * index + configuration.menuMargin * (index + 1) + startingMenuMargin, y: 0.0, width: configuration.menuItemWidth, height: configuration.menuHeight)
			}
		}
		
		let menuItemView : MenuItemView = MenuItemView(frame: menuItemFrame)
		menuItemView.configure(for: self, controller: viewController, index: index)
		
		// Add menu item view to menu scroll view
		menuScrollView.addSubview(menuItemView)
		menuItems.append(menuItemView)
		
		self.reloadMenuScrollViewContentSize()
	}
	
	public func removeLastViewController(_ n: Int = 1) {
		for _ in 1...n {
			self.menuItems.removeLast().removeFromSuperview()
			totalMenuItemWidthIfDifferentWidths -= self.menuItemWidths.removeLast()
			self.controllerArray.removeLast()
			self.reloadMenuScrollViewContentSize()
			self.isLastPageRemoved = self.lastPageIndex >= self.controllerArray.count
			controllerScrollView.contentSize.width -= self.view.frame.width
		}
	}
	
	public func reloadLastViewControllerTitle() {
		guard let lastVC = self.controllerArray.last else { return }
		let lastIndex = self.controllerArray.count - 1
		let controllerTitle = lastVC.title
		let titleText : String = controllerTitle != nil ? controllerTitle! : "Menu \(Int(lastIndex))"
		totalMenuItemWidthIfDifferentWidths -= self.menuItemWidths.removeLast()
		let itemWidthRect : CGRect = (titleText as NSString).boundingRect(with: CGSize(width: 1000, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:configuration.menuItemFont], context: nil)
		configuration.menuItemWidth = itemWidthRect.width
		let menuItemFrame = CGRect(x: totalMenuItemWidthIfDifferentWidths + configuration.menuMargin + (configuration.menuMargin * CGFloat(lastIndex)), y: 0.0, width: configuration.menuItemWidth, height: configuration.menuHeight)
		totalMenuItemWidthIfDifferentWidths += itemWidthRect.width
		menuItemWidths.append(itemWidthRect.width)
		let lastMenuItem = menuItems.last
		lastMenuItem?.frame = menuItemFrame
		lastMenuItem?.reconfigure(for: self, controller: lastVC, index: CGFloat(lastIndex))
		lastMenuItem?.titleLabel!.textColor = self.configuration.selectedMenuItemLabelColor
		self.moveSelectionIndicator(lastIndex)
		self.reloadMenuScrollViewContentSize()
	}
	
	private func reloadMenuScrollViewContentSize() {
		if configuration.menuItemWidthBasedOnTitleTextWidth {
			menuScrollView.contentSize = CGSize(width: (totalMenuItemWidthIfDifferentWidths + configuration.menuMargin) + CGFloat(controllerArray.count) * configuration.menuMargin, height: configuration.menuHeight)
		}
	}
}
