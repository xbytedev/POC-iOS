//
//  Extension+SDWebImageSwiftUI.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 24/07/23.
//

import SDWebImageSwiftUI

extension WebImage {
	init(from urlStr: String?) {
		self.init(url: URL(string: urlStr?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlStr ?? ""))
	}
}
