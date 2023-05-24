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

	var user: WebUser?

	init(provider: GroupProvider) {
		self.provider = provider
		user = MTUserDefaults.currentUser
	}

	func doCreateGroup(groupName name: String) async throws -> MTGroup {
		guard let user else { throw CustomError.message(R.string.localizable.internalUserDataNotFound()) }
		return try await provider.doCreateGroup(user: user, groupName: name).get()
	}

	@MainActor
	func getGroupList() async throws {
		guard let user else { throw CustomError.message(R.string.localizable.internalUserDataNotFound()) }
		self.state = .loading
		do {
			groupList = try await provider.getGroupList(user: user).get()
			self.state = .loaded
		} catch {
			self.state = .failed(error)
		}
	}
}
