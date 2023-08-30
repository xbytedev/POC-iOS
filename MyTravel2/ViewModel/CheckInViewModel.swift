//
//  CheckInViewModel.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 24/08/23.
//

import Foundation

class CheckInViewModel: ObservableObject {
	private let provider: CheckInProvider
	@MainActor @Published var state: MTLoadingState = .idle
	@MainActor @Published var checkInTravellers: [MTCheckInTraveller] = .init()
	@MainActor @Published var displayCheckInTravellers: [MTCheckInTraveller] = .init()

	init(withProvider provider: CheckInProvider) {
		self.provider = provider
	}

	@MainActor
	func getCheckInTravellers() async {
		state = .loading
		do {
			checkInTravellers = try await provider.getCheckInTravellerList().get()
			displayCheckInTravellers = checkInTravellers
			state = .loaded
		} catch {
			state = .failed(error)
		}
	}

	@MainActor
	func getCheckInTravellerDetail(from checkInTraveler: MTCheckInTraveller) async throws -> MTCheckInTravellerDetail {
		try await provider.getCheckInPeopleDetails(from: checkInTraveler).get()
	}

	@MainActor
	func searchAndFilterTravellers(
		withSearchText searchText: String, dateFilter: ClosedRange<Date>?, partnerFilter: String?) {
			var filteredValues = checkInTravellers
			if !searchText.isEmpty {
				filteredValues = filteredValues.filter({$0.peopleName.lowercased().contains(searchText.lowercased())})
			}
			if let dateFilter {
				filteredValues = filteredValues.filter({dateFilter.contains($0.date)})
			}
			if let partnerFilter {
				filteredValues = filteredValues.filter({$0.partnerName.contains(partnerFilter)})
			}
			displayCheckInTravellers = filteredValues
		}
}
