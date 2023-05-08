//
//  AppFont.swift
//  MyTravel
//
//  Created by Xuser on 08/05/23.
//

import Foundation
import SwiftUI


enum AppFont {
	static func getFont(forStyle style: UIFont.TextStyle, forWeight weight: Font.Weight = .regular) -> Font? {
		return Font.custom(R.font.montserratThin, size: UIFont.preferredFont(forTextStyle: style).pointSize).weight(weight)
	}
}
