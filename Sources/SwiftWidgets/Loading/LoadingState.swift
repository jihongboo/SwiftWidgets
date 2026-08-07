//
//  Loading.swift
//  FluxTV
//
//  Created by 纪洪波 on 7/12/26.
//

import SwiftUI
import Observation

@Observable
final class LoadingState {
    enum State: Equatable {
        case start(String?)
        case stop
    }
    
    var state: State = .stop
    
    fileprivate static let preview = LoadingState()
    
    func start(message: String? = nil) {
        state = .start(message)
    }
    
    func stop() {
        state = .stop
    }
}

extension EnvironmentValues {
    @Entry var loading: LoadingState = .preview
}
