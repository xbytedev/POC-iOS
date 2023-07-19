//
//  LocationViewModel.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 19/07/23.
//

import UIKit

class LocationViewModel: ObservableObject {
	let provider: LocationProvider
	@Published @MainActor private(set) var state: MTLoadingState = .idle
	@Published @MainActor private(set) var places: [MTPlace] = .init()

	init(provider: LocationProvider) {
		self.provider = provider
	}
	@MainActor
	func getPlaceList() async throws {
		state = .loaded
		let result = await provider.getPlaceList()
		switch result {
		case .success(let places):
			self.places = places
			state = .loaded
		case .failure(let error):
			state = .failed(error)
		}
	}
}
