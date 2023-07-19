//
//  PreviewGroupProvider.swift
//  MyTravel
//
//  Created by Xuser on 24/05/23.
//

import Foundation

struct GroupSuccessProvider: GroupProvider {
	func doCreateGroup(user: WebUser, groupName name: String) async -> Result<MTGroup, Error> {
		.success(MTGroup.preview)
	}

	func getGroupList(user: WebUser) async -> Result<[MTGroup], Error> {
		.success([
			MTGroup.preview, MTGroup.preview, MTGroup.preview, MTGroup.preview, MTGroup.preview, MTGroup.preview,
			MTGroup.preview, MTGroup.preview, MTGroup.preview, MTGroup.preview, MTGroup.preview, MTGroup.preview,
			MTGroup.preview, MTGroup.preview, MTGroup.preview, MTGroup.preview, MTGroup.preview
		])
	}
}
