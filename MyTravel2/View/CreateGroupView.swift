//
//  CreateGroupView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 18/05/23.
//

import SwiftUI

struct CreateGroupView: View {
	@State private var groupName: String = ""
	@Binding var isPresenting: Bool
	private(set) var viewModel: GroupViewModel
	@State var configuration = UIConfiguration()
	var createGroupSuccessfull: () -> Void

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

	private var headerView: some View {
		HStack {
			Text("New Group")
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

	private var popupView: some View {
		VStack {
			headerView
			MTTextField(label: "Group Name", valueStr: $groupName)
				.padding(.bottom, 24)
		}
		.modifier(FormModifier())
		.myOverlay(alignment: .bottom) {
			MTButton(isLoading: .constant(false), title: "Done", loadingTitle: "Creating group") {
				handleCreateGroupAction()
			}
			.padding(.horizontal, 64)
			.offset(x: 0, y: 20)
		}
	}

	func handleCreateGroupAction() {
		if groupName.isEmpty {
			configuration.alertPresent = true
			configuration.errorMeessage = R.string.localizable.pleaseEnterYourGroupName()
		} else {
			Task {
				do {
					configuration.isLoading = true
					configuration.alertPresent = false
					_ = try await viewModel.doCreateGroup(groupName: groupName)
					self.configuration.isLoading = false
					isPresenting = false
					createGroupSuccessfull()
				} catch {
					self.configuration.errorMeessage = error.localizedDescription
					self.configuration.alertPresent = true
					self.configuration.isLoading = false
				}
			}
		}
	}

	private func dismiss() {
		isPresenting = false
	}
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
		CreateGroupView(isPresenting: .constant(true),
						viewModel: GroupViewModel.init(provider: GroupAPIProvider()), createGroupSuccessfull: { })
    }
}
