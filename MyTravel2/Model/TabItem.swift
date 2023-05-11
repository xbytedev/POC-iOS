//
//  TabItem.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/05/23.
//

import SwiftUI

enum TabItem: CaseIterable {
	case groups, checkIn, settings

	var image: Image {
		switch self {
		case .groups: return Image(R.image.ic_tab_group)
		case .checkIn: return Image(R.image.ic_tab_checkIn)
		case .settings: return Image(R.image.ic_tab_settings)
		}
	}
}
