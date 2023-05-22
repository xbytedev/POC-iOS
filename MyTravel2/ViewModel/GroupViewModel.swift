//
//  GroupViewModel.swift
//  MyTravel
//
//  Created by Xuser on 19/05/23.
//

import Foundation

class GroupViewModel: ObservableObject {
	private let provider: GroupProvider
	@Published @MainActor private(set) var groupList: [MTGroup] = .init()
	@Published @MainActor private(set) var state: MTLoadingState = .idle

	init(provider: GroupProvider) {
		self.provider = provider
	}

	func doCreateGroup(groupName name: String) async throws -> MTGroup {
		try await provider.doCreateGroup(user: MTUserDefaults.currentUser, groupName: name).get()
	}

	@MainActor
	func getGroupList() async {
		self.state = .loading
		do {
			groupList = try await provider.getGroupList(user: MTUserDefaults.currentUser).get()
			self.state = .loaded
			groupList.removeAll()
		} catch {
			self.state = .failed(error)
		}
	}
}
