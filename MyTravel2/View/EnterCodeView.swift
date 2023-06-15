//
//  EnterCodeView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 15/06/23.
//

import SwiftUI

struct EnterCodeView: View {
	@State private var code: String = ""
	@Binding var isPresenting: Bool
	@State var configuration = UIConfiguration()
	var addedToGroupSuccessfull: (_ code: String) -> Void

    var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
				.opacity(isPresenting ? 0.4 : 0)
				.animation(.easeInOut, value: isPresenting)
			popupView
				.scaleEffect(isPresenting ? 1 : 0)
				.animation(.spring(), value: isPresenting)
		}
		.showAlert(isPresented: $configuration.alertPresent) {
			Text(configuration.errorMeessage)
		}
    }

	var headerView: some View {
		HStack {
			Text(R.string.localizable.enterCodeManually())
				.font(AppFont.getFont(forStyle: .title1, forWeight: .bold))
				.foregroundColor(AppColor.theme)
			Spacer()
			Button {
				dismiss()
			} label: {
				Image(systemName: "xmark")
					.font(.title)
					.aspectRatio(1, contentMode: .fit)
					.padding(8)
					.background(Color.gray)
					.clipShape(Circle())
			}
		}
	}

	var popupView: some View {
		VStack {
			headerView
			MTTextField(label: R.string.localizable.enterCode(), valueStr: $code)
				.padding(.bottom, 24)
		}
		.modifier(FormModifier())
		.myOverlay(alignment: .bottom) {
			MTButton(
				isLoading: .constant(false), title: R.string.localizable.done(),
				loadingTitle: R.string.localizable.addingToGroup()) {
					handleAddToGroupAction()
				}
			.padding(.horizontal, 64)
			.offset(x: 0, y: 20)
		}
	}

	func handleAddToGroupAction() {
		if code.isEmpty {
			configuration.alertPresent = true
			configuration.errorMeessage = R.string.localizable.pleaseEnterYourGroupName()
		} else {
			addedToGroupSuccessfull(code)
			dismiss()
			/*Task {
				do {
					configuration.isLoading = true
					configuration.alertPresent = false
					let group = try await viewModel.doCreateGroup(groupName: groupName)
					self.configuration.isLoading = false
					isPresenting = false
					addedToGroupSuccessfull(group)
					code = ""
				} catch {
					self.configuration.errorMeessage = error.localizedDescription
					self.configuration.alertPresent = true
					self.configuration.isLoading = false
				}
			}*/
		}
	}

	private func dismiss() {
		isPresenting = false
	}
}

struct EnterCodeView_Previews: PreviewProvider {
    static var previews: some View {
		EnterCodeView(isPresenting: .constant(true), addedToGroupSuccessfull: { _ in })
    }
}
