//
//  CheckInFilterView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 29/08/23.
//

import SwiftUI

struct CheckInFilterView: View {
	private let minimumDate = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
	@State private var startDate: Date = Date()
	@State private var isDateFilterApplied = false
	@State private var isPartnerFilterApplied = false
	private let maximumDate = Date()
	@State private var endDate: Date = Date()
	@State private var selectedPartner = ""
	@Binding var isPresenting: Bool
	var completionBlock: ((Date, Date)?, _ selectedPartner: String?) -> Void

	var body: some View {
		ZStack {
			Color.black
				.ignoresSafeArea()
				.opacity(isPresenting ? 0.4 : 0)
				.animation(.easeInOut, value: isPresenting)
			popupView
				.scaleEffect(isPresenting ? 1 : 0)
				.animation(.spring(), value: isPresenting)
				.opacity(isPresenting ? 1 : 0)
		}
		/*.showAlert(isPresented: $configuration.alertPresent) {
			Text(configuration.errorMeessage)
		}*/
	}

    var popupView: some View {
		VStack(spacing: 40) {
			HStack {
				Text(R.string.localizable.filter)
					.font(AppFont.getFont(forStyle: .title1, forWeight: .semibold))
					.foregroundColor(AppColor.theme)
				Spacer()
				Button {
					isPresenting = false
				} label: {
					Image(systemName: "xmark")
						.font(.title)
						.aspectRatio(1, contentMode: .fit)
						.padding(8)
						.background(Color.gray)
						.clipShape(Circle())
				}
			}
			VStack(spacing: 32) {
				HStack(spacing: 16) {
					Button(action: dateFilterToggle) {
						isDateFilterApplied ? Image(systemName: "checkmark.circle") : Image(systemName: "circle")
					}
					VStack {
						DatePicker(
							"Start Date", selection: $startDate, in: minimumDate...min(endDate, maximumDate), displayedComponents: [.date])
						DatePicker(
							"End Date", selection: $endDate, in: max(minimumDate, startDate)...maximumDate, displayedComponents: [.date])
					}
				}
				HStack(spacing: 16) {
					Button(action: partnerFilterToggle) {
						isPartnerFilterApplied ? Image(systemName: "checkmark.circle") : Image(systemName: "circle")
					}
					updatedPicker
				}
			}
		}
		.padding(.bottom, 24)
		.modifier(FormModifier())
		.myOverlay(alignment: .bottom) {
			MTButton(
				isLoading: .constant(false), title: R.string.localizable.done(),
				loadingTitle: R.string.localizable.creatingGroup()) {
					completionBlock(isDateFilterApplied ? (startDate, endDate) : nil, isPartnerFilterApplied ? selectedPartner : nil)
					isPresenting = false
				}
				.padding(.horizontal, 64)
				.offset(x: 0, y: 20)
		}
		.onChange(of: startDate) { _ in
			isDateFilterApplied = true
		}
		.onChange(of: endDate) { _ in
			isDateFilterApplied = true
		}
		.onChange(of: selectedPartner) { _ in
			isPartnerFilterApplied = true
		}
    }

	@ViewBuilder
	private var updatedPicker: some View {
		if #available(iOS 16.0, *) {
			picker.pickerStyle(.navigationLink)
		} else {
			picker
		}
	}

	private var picker: some View {
		Picker(selection: $selectedPartner) {
			Text("Chocolate").tag("Chocolate")
			Text("Vanilla").tag("Vanilla")
			Text("Strawberry").tag("Strawberry")
		} label: {
			Text("Partner")
				.font(AppFont.getFont(forStyle: .headline, forWeight: .semibold))
				.foregroundColor(AppColor.Text.primary)
		}
	}

	private func dateFilterToggle() {
		isDateFilterApplied.toggle()
	}

	private func partnerFilterToggle() {
		isPartnerFilterApplied.toggle()
	}
}

struct CheckInFilterView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			CheckInFilterView(isPresenting: .constant(true), completionBlock: { (_, _) in })
		}
    }
}
