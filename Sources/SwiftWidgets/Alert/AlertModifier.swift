import SwiftUI

private struct AlertModifier: ViewModifier {
    @State private var alert = AlertState()
    
    func body(content: Content) -> some View {
        @Bindable var alert = alert
        content
            .environment(\.alert, alert)
            .alertError()
            .alert(
                alert.general?.title ?? "",
                isPresented: Binding(get: {
                    alert.general != nil
                }, set: { isPresented in
                    if !isPresented {
                        alert.general = nil
                    }
                }),
                actions: {
                    
                },
                message: {
                    if let message = alert.general?.message {
                        Text(message)
                    }
                }
            )
        //            .alert(
        //                alert.general?.title ?? "",
        //                item: $alert.general) { _ in
        //                    Button("Confirm", role: .confirm) {
        //                        alert.general = nil
        //                    }
        //                } message: { general in
        //                    if let message = general.message {
        //                        Text(message)
        //                    }
        //                }
            .confirmationDialog(
                alert.confirm?.title ?? "",
                isPresented: Binding(get: {
                    alert.confirm != nil
                }, set: { isPresented in
                    if isPresented {
                        alert.confirm = nil
                    }
                }),
                actions: {
                    Button(role: .cancel) {
                        alert.confirm = nil
                    } label: {
                        Text("Cancel", bundle: .module)
                    }
                    if let onConfirm = alert.confirm?.onConfirm {
                        if #available(anyAppleOS 26.0, *) {
                            AsyncButton(role: .confirm, action: onConfirm) {
                                Text("Confirm", bundle: .module)
                            }
                        } else {
                            AsyncButton(action: onConfirm) {
                                Text("Confirm", bundle: .module)
                            }
                        }
                    }
                }, message: {
                    if let message = alert.confirm?.message {
                        Text(message)
                    }
                })
        //                .confirmationDialog(alert.confirm?.title ?? "", item: $alert.confirm) { confirm in
        //                    Button("Cancel", role: .cancel) {
        //                        alert.confirm = nil
        //                    }
        //                    AsyncButton(role: .confirm, action: confirm.onConfirm) {
        //                        Text("Confirm")
        //                    }
        //                } message: { confirm in
        //                    if let message = confirm.message {
        //                        Text(message)
        //                    }
        //                }
    }
}

public extension View {
    /// Attaches the ``AlertState`` environment modifier to the view hierarchy, listening for global popups and confirmations.
    ///
    /// Applying `.alert()` injects an ``AlertState`` instance into the environment, automatically responding
    /// when error popups, informational alerts, or confirmation dialogs are requested via `@Environment(\.alert)`.
    ///
    /// - Returns: A view wrapped with alert handling capabilities.
    func alert() -> some View {
        modifier(AlertModifier())
    }
}

#Preview("Loading") {
    VStack(spacing: 12) {
        Text("Demo Content")
        Button("Action") {}
    }
    .padding()
    .alert()
}

#Preview("Idle") {
    VStack(spacing: 12) {
        Text("Demo Content")
        Button("Action") {}
    }
    .padding()
    .alert()
}

