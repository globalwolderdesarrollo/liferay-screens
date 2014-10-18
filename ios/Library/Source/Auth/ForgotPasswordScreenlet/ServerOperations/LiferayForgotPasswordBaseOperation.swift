/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/
import UIKit


public class LiferayForgotPasswordBaseOperation: ServerOperation {

	public var resultPasswordSent: Bool?

	internal override var hudLoadingMessage: HUDMessage? {
		return (NSLocalizedString("forgotpassword-screenlet", "loading-message"),
		details: NSLocalizedString("forgotpassword-screenlet", "loading-details"))
	}
	internal override var hudFailureMessage: HUDMessage? {
		return (NSLocalizedString("forgotpassword-screenlet", "loading-error"), details: nil)
	}
	internal override var hudSuccessMessage: HUDMessage? {
		return (NSLocalizedString("forgotpassword-screenlet", successMessageKey),
				details: NSLocalizedString("forgotpassword-screenlet", "loaded-details"))
	}

	internal var forgotPasswordData: ForgotPasswordData {
		return screenlet.screenletView as ForgotPasswordData
	}

	private var successMessageKey = ""


	//MARK ServerOperation

	override func validateData() -> Bool {
		if forgotPasswordData.userName == nil {
			showValidationHUD(message: "Please, enter the user name")

			return false
		}

		return true
	}

	override func postRun() {
		if lastError != nil {
			successMessageKey = resultPasswordSent! ? "password-sent" : "reset-sent"
		}
	}

	override func doRun(#session: LRSession) {
		var outError: NSError?

		let result = sendForgotPasswordRequest(
				service: LRMobilewidgetsuserService_v62(session: session),
				error: &outError)

		if outError != nil {
			lastError = outError!
			resultPasswordSent = nil
		}
		else if result != nil {
			lastError = nil
			resultPasswordSent = result
		}
		else {
			lastError = createError(cause: .InvalidServerResponse, userInfo: nil)
			resultPasswordSent = nil
		}
	}


	//MARK: Template Methods
	
	internal func sendForgotPasswordRequest(
			#service: LRMobilewidgetsuserService_v62,
			error: NSErrorPointer)
			-> Bool? {

		assertionFailure("sendForgotPasswordRequest must be overriden")

		return nil
	}

}
