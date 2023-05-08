//
//  AppFont.swift
//  MyTravel
//
//  Created by Xuser on 08/05/23.
//

import Foundation
import SwiftUI


enum AppFont {
	static func getRegular(forStyle style: UIFont.TextStyle) -> Font? {
		return Font.system(size: UIFont.preferredFont(forTextStyle: style).pointSize, weight: .regular)
	}

	static func getMedium(forStyle style: UIFont.TextStyle) -> Font? {
		return Font.system(size: UIFont.preferredFont(forTextStyle: style).pointSize, weight: .medium)
	}

	static func getBold(forStyle style: UIFont.TextStyle) -> Font? {
		return Font.system(size: UIFont.preferredFont(forTextStyle: style).pointSize, weight: .bold)
	}

	static func getSemiBold(forStyle style: UIFont.TextStyle) -> Font? {
		return Font.system(size: UIFont.preferredFont(forTextStyle: style).pointSize, weight: .semibold)
	}

}
