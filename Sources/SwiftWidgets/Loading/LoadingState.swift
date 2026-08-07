//
//  Loading.swift
//  FluxTV
//
//  Created by 纪洪波 on 7/12/26.
//

import SwiftUI
import Observation

/// An observable object representing the active loading state of a view or hierarchy.
@Observable
public final class LoadingState {
    public enum State: Equatable {
        case start
        case stop
    }
    
    public var state: State = .stop
    
    fileprivate static let preview = LoadingState()
    
    /// Starts the loading state with an optional message.
    ///
    /// - Parameter message: An optional string message describing the current operation.
    public func start() {
        state = .start
    }
    
    /// Stops the loading state.
    public func stop() {
        state = .stop
    }
}

public extension EnvironmentValues {
    /// Provides access to the ``LoadingState`` instance in the SwiftUI environment.
    @Entry var loading: LoadingState = .preview
}
