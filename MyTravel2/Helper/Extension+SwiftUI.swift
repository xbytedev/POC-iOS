//
//  Extension+SwiftUI.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 18/05/23.
//

import SwiftUI

// https://stackoverflow.com/a/75656644/3110026
extension EnvironmentValues {
	// this can be used as: @Environment(\.mtDismissable) var myDismiss
	// in any swiftui view and it will not complain about ios versions
	var mtDismissable: () -> Void {
		return dismissAction
	}

	// this function abstracts the availability check so you can
	// avoid the conflicting return types and any other headache
	private func dismissAction() {
		if #available(iOS 15, *) {
			dismiss()
		} else {
			presentationMode.wrappedValue.dismiss()
		}
	}
}
