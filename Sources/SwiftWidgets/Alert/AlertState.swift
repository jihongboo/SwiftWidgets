//
//  AppAlertService.swift
//  ReadOne
//
//  Created by Antigravity on 07/09/26.
//

import SwiftUI
import Observation

@Observable
public final class AlertState {
    var error: Error?
    var general: (title: String, message: String?)?
    var confirm: (title: String, message: String?, onConfirm: (() async throws -> Void))?
        
    public func error(_ error: Error) {
        self.error = error
    }
    
    public func general(_ title: String, _ message: String? = nil) {
        self.general = (title, message)
    }
    
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
    @Entry var alert = AlertState.preview
}
