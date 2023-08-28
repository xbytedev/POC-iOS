//
//  MTFormatter.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 25/08/23.
//

import Foundation

enum MTFormatter {
	enum Date {
		static let serverDateFormatter: DateFormatter = {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
			return dateFormatter
		}()
	}
}
