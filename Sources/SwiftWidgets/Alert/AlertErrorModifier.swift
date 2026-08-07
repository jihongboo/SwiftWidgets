//
//  AlertModifier 2.swift
//  FluxTV
//
//  Created by 纪洪波 on 7/12/26.
//
import SwiftUI

private struct AlertErrorModifier: ViewModifier {
    @Environment(\.alert) private var alert
    
    func body(content: Content) -> some View {
        @Bindable var alert = alert
        //        if #available(anyAppleOS 27.0, *) {
        //            content
        //                .alert(error: $alert.error) {
        //                    Button("Confirm", role: .confirm) {
        //                        alert.error = nil
        //                    }
        //                }
        //        } else {
        content
            .alert(
                Text("Error", bundle: .module),
                isPresented: Binding(get: {
                    alert.error != nil
                }, set: { isPresented in
                    if !isPresented {
                        alert.error = nil
                    }
                }),
                actions: {
                    if #available(anyAppleOS 26.0, *) {
                        Button(role: .confirm) {
                            alert.error = nil
                        } label: {
                            Text("Confirm", bundle: .module)
                        }
                    } else {
                        Button {
                            alert.error = nil
                        } label: {
                            Text("Confirm", bundle: .module)
                        }
                    }
                },
                message: {
                    if let message = alert.error?.localizedDescription {
                        Text(message)
                    }
                }
            )
        //                .alert(
        //                    "Error",
        //                    item: $alert.error,
        //                    actions: { _ in
        //                        Button("Confirm", role: .confirm) {
        //                            alert.error = nil
        //                        }
        //                    },
        //                    message: { error in
        //                        Text(error.localizedDescription)
        //                    }
        //                )
        //        }
    }
}

extension View {
    func alertError() -> some View {
        modifier(AlertErrorModifier())
    }
}
