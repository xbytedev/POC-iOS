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

	init(withProvider provider: CheckInProvider) {
		self.provider = provider
	}

	@MainActor
	func getCheckInTravellers() async {
		state = .loading
		do {
			checkInTravellers = try await provider.getCheckInTravellerList().get()
			state = .loaded
		} catch {
			state = .failed(error)
		}
	}
}
