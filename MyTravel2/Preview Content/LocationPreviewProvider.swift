//
//  LocationProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 19/07/23.
//

import Foundation

struct PlaceSuccessProvider: PlaceProvider {
	func getPlaceList() async -> Result<[MTPlace], Error> {
		.success([MTPlace.preview])
	}
}

struct PlaceFailureProvider: PlaceProvider {
	func getPlaceList() async -> Result<[MTPlace], Error> {
		.failure(CustomError.message("Mock Failure"))
	}
}
