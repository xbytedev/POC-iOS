//
//  VerificationView.swift
//  MyTravel
//
//  Created by Mrugesh Tank on 10/05/23.
//

import SwiftUI

struct VerificationView: View {
	@State private var isLoading = false
	@State private var otpValue = ""
	var viewModel: AuthViewModel
	@State private var shouldHideResendOTPBtn = false
	@State private var countDownStr = ""
	@State private var isVerified: Bool = false
	@State private var configuration: UIConfiguration = UIConfiguration()
	@Binding var rootIsActive: Bool

    var body: some View {
		ScrollView {
			VStack(spacing: 36) {
				VStack(spacing: 8) {
					Image(R.image.img_verification)
						.resizable()
						.scaledToFit()
						.padding(.horizontal)
					Text(R.string.localizable.verificationCode)
						.font(AppFont.getFont(forStyle: .title1, forWeight: .bold))
						.foregroundColor(AppColor.theme)
					Text(R.string.localizable.weHaveSentVerificationCode)
						.font(AppFont.getFont(forStyle: .headline, forWeight: .medium))
						.foregroundColor(AppColor.theme)
				}
				OTPView(otpDigitCount: 4, otpString: $otpValue)
				resendOTPView

				NavigationLink(isActive: $isVerified) {
					WelcomeView(rootIsActive: $rootIsActive)
				} label: {
					MTButton(isLoading: $isLoading, title: R.string.localizable.verify(),
							 loadingTitle: R.string.localizable.verifying()) {
						handleRequestVerifyOTPAction()
					}.showAlert(isPresented: $configuration.alertPresent) {
						Text(configuration.errorMeessage)
					}
				}
			}
			.padding()
		}
		.onAppear {
			setValuesForResendOTP()
			setTimer()
		}
		.setThemeBackButton()
    }

	var resendOTPView: some View {
		HStack {
			if shouldHideResendOTPBtn {
				Text(R.string.localizable.resendInTime)
					.foregroundColor(AppColor.Text.secondary)
				Text(countDownStr)
					.foregroundColor(AppColor.theme)
			} else {
				Text(R.string.localizable.didNotReceiveCode)
					.foregroundColor(AppColor.Text.secondary)
				Button(R.string.localizable.resendOTP()) {
					handleResendOTPAction()
				}
				.foregroundColor(AppColor.theme)
			}
		}
		.font(AppFont.getFont(forStyle: .headline, forWeight: .medium))
	}

	func setTimer() {
		viewModel.cancellable = Timer.publish(every: 1, on: .main, in: .common)
			.autoconnect()
			.sink { _ in
				setValuesForResendOTP()
			}
	}

	fileprivate func setValuesForResendOTP() {
		guard let date = MTUserDefaults.lastOTPSendDate else {
			shouldHideResendOTPBtn = true
			return
		}
		let interval = Date().timeIntervalSince(date)
		if interval > 30 {
			shouldHideResendOTPBtn = false
			viewModel.cancellable?.cancel()
		} else {
			countDownStr = R.string.localizable.time(30 - (Int(interval)%60))
			shouldHideResendOTPBtn = true
		}
	}

	func handleResendOTPAction() {
		configuration.alertPresent = false
		Task {
			do {
				let isSuccess = try await viewModel.resendLoginOTP()
				if isSuccess {
					self.setValuesForResendOTP()
					self.setTimer()
				} else {
					self.configuration.errorMeessage = R.string.localizable.somethingWentWrong()
					self.configuration.alertPresent = true
				}
			} catch {
				self.configuration.errorMeessage = error.localizedDescription
				self.configuration.alertPresent = true
			}
		}
	}

	func handleRequestVerifyOTPAction() {
		if otpValue.isEmpty {
			configuration.errorMeessage = R.string.localizable.requiredFieldsAreMissing()
			configuration.alertPresent = true
		} else if !otpValue.isValid(allowChars: ["0-9"], minLength: 4, maxLength: 4) {
			configuration.errorMeessage = R.string.localizable.pleaseEnterValidOTP()
			configuration.alertPresent = true
		} else {
			configuration.alertPresent = false
			configuration.isLoading = true
			Task {
				do {
					try await viewModel.otpVerification(otp: otpValue)
					self.configuration.isLoading = false
					viewModel.cancellable?.cancel()
					isVerified = true

				}
				/*catch DecodingError.keyNotFound(let key, let context) {
				 print("could not find key \(key) in JSON: \(context.debugDescription)")
				 } catch DecodingError.valueNotFound(let type, let context) {
				 print("could not find type \(type) in JSON: \(context.debugDescription)")
				 } catch DecodingError.typeMismatch(let type, let context) {
				 print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
				 } catch DecodingError.dataCorrupted(let context) {
				 print("data found to be corrupted in JSON: \(context.debugDescription)")
				 } catch let error as NSError {
				 print("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
				 }*/
				catch {
					viewModel.cancellable?.cancel()
					self.configuration.errorMeessage = error.localizedDescription
					self.configuration.alertPresent = true
					self.configuration.isLoading = false
				}
			}
		}
	}
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
		let viewModel = AuthViewModel(provider: AuthAPIProvider())
		VerificationView(viewModel: viewModel, rootIsActive: .constant(false))
    }
}
