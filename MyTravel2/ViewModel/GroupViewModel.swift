//
//  GroupViewModel.swift
//  MyTravel
//
//  Created by Xuser on 19/05/23.
//

import Foundation

class GroupViewModel: ObservableObject {
	private let provider: GroupProvider

	init(provider: GroupProvider) {
		self.provider = provider
	}

	func doCreateGroup(groupName name: String) async throws -> Bool {
		try await provider.doCreateGroup(groupName: name).get()
	}
}
