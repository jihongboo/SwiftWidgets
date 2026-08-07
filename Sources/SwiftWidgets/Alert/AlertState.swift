//
//  AppAlertService.swift
//  ReadOne
//
//  Created by Antigravity on 07/09/26.
//

import SwiftUI
import Observation

/// An observable state object for managing global or localized alert popups.
///
/// `AlertState` allows views to trigger error dialogs, informative popups, or confirmation actions
/// via SwiftUI's `@Environment(\.alert)` property wrapper.
@Observable
public final class AlertState {
    var error: Error?
    var general: (title: String, message: String?)?
    var confirm: (title: String, message: String?, onConfirm: (() async throws -> Void))?
        
    /// Triggers an error alert with the localized description of the provided error.
    ///
    /// - Parameter error: The error to be presented to the user.
    public func error(_ error: Error) {
        self.error = error
    }
    
    /// Triggers a general informational alert popup with a title and optional message.
    ///
    /// - Parameters:
    ///   - title: The primary title string for the alert.
    ///   - message: An optional descriptive message giving more context.
    public func general(_ title: String, _ message: String? = nil) {
        self.general = (title, message)
    }
    
    /// Triggers a confirmation alert with an action closure.
    ///
    /// - Parameters:
    ///   - title: The title string for the confirmation prompt.
    ///   - message: An optional message describing the action being confirmed.
    ///   - onConfirm: A closure executed when the user confirms the action.
    public func confirm(
        _ title: String,
        _ message: String? = nil,
        onConfirm: @escaping (() -> Void)
    ) {
        self.confirm = (title, message, onConfirm)
    }
}

fileprivate extension AlertState {
    static let preview = AlertState()
}

public extension EnvironmentValues {
    /// Provides access to the ``AlertState`` instance in the SwiftUI environment.
    @Entry var alert = AlertState.preview
}

