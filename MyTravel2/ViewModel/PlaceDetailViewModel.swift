//
//  PlaceDetailViewModel.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 26/07/23.
//

import Foundation

class PlaceDetailViewModel: ObservableObject {
	let provider: PlaceDetailProvider
	let place: MTPlace
	@Published @MainActor private(set) var state: MTLoadingState = .idle
	@Published @MainActor private(set) var placeDetail: MTPlaceDetail!

	init(with place: MTPlace, and provider: PlaceDetailProvider) {
		self.place = place
		self.provider = provider
	}

	@MainActor
	func getPlaceDetail(of place: MTPlace) async {
		state = .loading
		do {
			placeDetail = try await provider.getPlaceDetail(place: place).get()
			state = .loaded
		} catch {
			state = .failed(error)
		}
	}
	
}
