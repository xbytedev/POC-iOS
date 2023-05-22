//
//  MTAsyncView.swift
//  MyTravel
//
//  Created by Xuser on 22/05/23.
//

import SwiftUI

protocol MTAsyncView: View {
	associatedtype MTIdleView: View
	associatedtype MTLoadedView: View
	associatedtype ATMTLoadingView: View
	associatedtype ATMTErrorView: View
	var state: MTLoadingState { get }
	var loadingMessage: String? { get }

	@ViewBuilder @MainActor var idleView: Self.MTIdleView { get }
	@ViewBuilder @MainActor var loadingView: Self.ATMTLoadingView { get }
	@ViewBuilder @MainActor var loadedView: Self.MTLoadedView { get }
	func load()
	@ViewBuilder @MainActor func getErrorView(with errorString: String) -> ATMTErrorView
}

extension MTAsyncView {
	var idleView: some View {
		Color.clear.onAppear {
			load()
		}
	}

	var loadingMessage: String? {
		nil
	}

	var loadingView: some View {
		MTLoadingView(loadingMessage: loadingMessage)
	}

	func getErrorView(with errorString: String) -> some View {
		SMErrorView(message: errorString) {
			load()
		}
	}

	@MainActor
	var body: some View {
		Group {
			switch state {
			case .idle:
				idleView
			case .loading:
				loadingView
			case .failed(let error):
				getErrorView(with: error.localizedDescription)
			case .loaded:
				loadedView
			}
		}
	}
}

struct MTLoadingView: View {
	var loadingMessage: String?

	var body: some View {
		VStack {
			ProgressView()
			if let loadingMessage {
				Text(loadingMessage)
					.font(AppFont.getFont(forStyle: .callout))
			}
		}
		.foregroundColor(AppColor.Text.secondary)
		.frame(maxHeight: .infinity)
	}
}

struct SMLoadingView_Previews: PreviewProvider {
	static var previews: some View {
		MTLoadingView(loadingMessage: "Loading your data")
	}
}

struct SMErrorView: View {
	var title: String?
	var message: String?
	var retryAction: (() -> Void)?

	var body: some View {
		VStack(spacing: 16) {
			if let title {
				Text(title)
					.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
			}
			if let message {
				Text(message)
					.font(AppFont.getFont(forStyle: .body))
			}
			if let retryAction {
				MTButton(isLoading: .constant(false), title: "Retry", loadingTitle: "") {
					retryAction()
				}
			}
		}
		.foregroundColor(AppColor.theme)
		.frame(maxHeight: .infinity)
	}
}

struct SMErrorView_Previews: PreviewProvider {
	static var previews: some View {
		SMErrorView(title: "Error Title", message: "Error Message") {
		}
	}
}
