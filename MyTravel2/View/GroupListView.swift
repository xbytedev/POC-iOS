//
//  GroupListView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 15/05/23.
//

import SwiftUI

struct GroupListView: MTAsyncView {

	@Binding var isPopupPresented: Bool
	@StateObject private var viewModel: GroupViewModel = .init(provider: GroupAPIProvider())
	@Binding var shouldGroupSuccess: Bool
	@Binding var createdGroup: MTGroup?
	@State private var navigationHash: [Int: Bool]

	init(
		isPopupPresented: Binding<Bool>, shouldGroupSuccess: Binding<Bool>,
		createdGroup: Binding<MTGroup?> = .constant(nil)) {
			_isPopupPresented = isPopupPresented
			_shouldGroupSuccess = shouldGroupSuccess
			_createdGroup = createdGroup
			self.navigationHash = .init()
		}

	var state: MTLoadingState {
		viewModel.state
	}

	func load() {
		Task {
			try await viewModel.getGroupList()
			viewModel.groupList.forEach { navigationHash[$0.id] = false }
		}
	}

	var loadedView: some View {
		dataView
			.myOverlay {
				Group {
					if viewModel.groupList.isEmpty {
						emptyView
					}
				}
			}
			.fullScreenCover(isPresented: $shouldGroupSuccess) {
				if let group = createdGroup {
					CreateGroupSuccessView(group: group, shouldPresent: .constant(true))
				}
			}
			.onChange(of: shouldGroupSuccess) { newValue in
				guard !newValue else { return }
				load()
			}
	}

	var dataView: some View {
		List {
			ForEach(viewModel.groupList) { item in
				ZStack {
					NavigationLink {
						GroupDetailView(viewModel: .init(group: item, groupDetailProvider: GroupDetailAPIProvider(), groupUpdateDelegate: viewModel))
							.navigationTitle(R.string.localizable.groups())
							.setThemeBackButton()
					} label: {
						EmptyView()
					}
					.opacity(0)
					GroupListRow(groupName: item.name ?? "")
				}
				.mtListBackgroundStyle()
			}
		}
		.listStyle(.plain)
		/*.swipeActions(edge: .trailing, allowsFullSwipe: true) {
			Button {
				print("Delete")
			} label: {
				Label("Delete", systemImage: "trash")
			}
		}*/
	}

	var emptyView: some View {
		GeometryReader { geometryProxy in
			VStack {
				Spacer()
				Image(R.image.img_setupGroup)
					.resizable()
					.scaledToFit()
					.offset(y: 8)
				groupData
					.background(AppColor.theme)
					.cornerRadius(32)
					.shadow(radius: 8, y: -4)
					.frame(height: geometryProxy.size.height * 0.66)
			}
			.ignoresSafeArea(edges: .bottom)
		}
	}

	var groupData: some View {
		VStack(spacing: 36) {
			Text("Groups")
				.font(AppFont.getFont(forStyle: .largeTitle, forWeight: .semibold))
				.foregroundColor(AppColor.Text.tertiary)
				.padding(.top, 48)
			Text("Setup a Group to save time and check-in several travelers at the same time.")
				.multilineTextAlignment(.center)
				.font(AppFont.getFont(forStyle: .title3, forWeight: .medium))
				.foregroundColor(AppColor.Text.tertiary)
			MTButton(isLoading: .constant(false), title: "Setup Group", loadingTitle: "") {
				action()
			}
			.inverted()
			Spacer()
		}
		.padding(.horizontal, 36)
	}

	func action() {
		isPopupPresented = true
	}
}

struct GroupList_Previews: PreviewProvider {
    static var previews: some View {
		GroupListView(
			isPopupPresented: .constant(false), /*viewModel: .init(provider: GroupAPIProvider()),*/
			shouldGroupSuccess: .constant(true), createdGroup: .constant(nil))
    }
}
/*
public struct Popup<PopupContent>: ViewModifier where PopupContent: View {
	init(
		isPresented: Binding<Bool>,
		view: @escaping () -> PopupContent) {
			self._isPresented = isPresented
			self.view = view
		}

	/// Controls if the sheet should be presented or not
	@Binding var isPresented: Bool

	/// The content to present
	var view: () -> PopupContent

	// MARK: - Private Properties
	/// The rect of the hosting controller
	@State private var presenterContentRect: CGRect = .zero

	/// The rect of popup content
	@State private var sheetContentRect: CGRect = .zero

	/// The offset when the popup is displayed
	private var displayedOffset: CGFloat {
		-presenterContentRect.midY + screenHeight/2
	}

	/// The offset when the popup is hidden
	private var hiddenOffset: CGFloat {
		if presenterContentRect.isEmpty {
			return 1000
		}
		return screenHeight - presenterContentRect.midY + sheetContentRect.height/2 + 5
	}

	/// The current offset, based on the "presented" property
	private var currentOffset: CGFloat {
		return isPresented ? displayedOffset : hiddenOffset
	}
	private var screenWidth: CGFloat {
		UIScreen.main.bounds.size.width
	}

	private var screenHeight: CGFloat {
		UIScreen.main.bounds.size.height
	}

	// MARK: - Content Builders
	public func body(content: Content) -> some View {
		ZStack {
			content
				.frameGetter($presenterContentRect)
		}
		.overlay(sheet())
	}

	func sheet() -> some View {
		ZStack {
			self.view()
				.simultaneousGesture(
					TapGesture().onEnded {
						dismiss()
					})
				.frameGetter($sheetContentRect)
				.frame(width: screenWidth)
				.offset(x: 0, y: currentOffset)
				.animation(Animation.easeOut(duration: 0.3), value: currentOffset)
		}
	}

	private func dismiss() {
		isPresented = false
	}
}

extension View {
	public func popup<PopupContent: View>(
		isPresented: Binding<Bool>,
		view: @escaping () -> PopupContent) -> some View {
			self.modifier(
				Popup(
					isPresented: isPresented,
					view: view)
			)
		}
}

extension View {
	func frameGetter(_ frame: Binding<CGRect>) -> some View {
		modifier(FrameGetter(frame: frame))
	}
}

struct FrameGetter: ViewModifier {

	@Binding var frame: CGRect

	func body(content: Content) -> some View {
		content
			.background(
				GeometryReader { proxy -> AnyView in
					let rect = proxy.frame(in: .global)
					// This avoids an infinite layout loop
					if rect.integral != self.frame.integral {
						DispatchQueue.main.async {
							self.frame = rect
						}
					}
					return AnyView(EmptyView())
				})
	}
}*/
