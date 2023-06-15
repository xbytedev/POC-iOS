//
//  GroupDetailViewModel.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 13/06/23.
//

import Foundation

class GroupDetailViewModel: ObservableObject {
	let group: MTGroup
	let groupDetailProvider: GroupDetailProvider
	@Published @MainActor private(set) var state = MTLoadingState.idle
	@Published @MainActor private(set) var travellers = [MTTraveller]()

	init(group: MTGroup, groupDetailProvider: GroupDetailProvider) {
		self.group = group
		self.groupDetailProvider = groupDetailProvider
 	}

	@MainActor
	func getPeopleList() async {
		state = .loading
		let result = await groupDetailProvider.getGroupPeopleList(from: group)
		switch result {
		case .success(let travellers):
			self.travellers = travellers
			state = .loaded
		case .failure(let error):
			state = .failed(error)
		}
	}
}
