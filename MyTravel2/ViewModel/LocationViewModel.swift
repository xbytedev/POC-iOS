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
	@Published @MainActor private(set) var displayPlaces: [MTPlace] = .init()

	init(provider: LocationProvider) {
		self.provider = provider
	}
	@MainActor
	func getPlaceList() async {
		state = .loaded
		let result = await provider.getPlaceList()
		switch result {
		case .success(let places):
			self.places = places
			self.displayPlaces = places
			state = .loaded
		case .failure(let error):
			state = .failed(error)
		}
	}

	@MainActor
	func searchPlace(with searchStr: String) {
		if searchStr.isEmpty {
			displayPlaces = places
		} else {
			displayPlaces = places.filter({$0.name?.contains(searchStr) ?? false})
		}
	}
}
