//
//  AddTravellerPreviewProvider.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 15/06/23.
//

import Foundation

struct AddTravellerSuccessProvider: AddTravellerProvider {
	func addTraveler(to group: MTGroup, with code: Int) async -> Result<Bool, Error> {
		.success(true)
	}
}

struct AddTravellerFailureProvider: AddTravellerProvider {
	func addTraveler(to group: MTGroup, with code: Int) async -> Result<Bool, Error> {
		.failure(CustomError.message("Mock Failure"))
	}
}
