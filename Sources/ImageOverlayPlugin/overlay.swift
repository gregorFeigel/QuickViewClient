//
//  SwiftUIView.swift
//  
//
//  Created by Gregor Feigel on 21.06.23.
//

import SwiftUI
import PluginInterface



@available(macOS 10.15.0, *)
struct SwiftUIView: View, ImageOverlayPlugin {
    
    var preview: AnyView { AnyView(body) }
    
    var body: some View {
        VStack {
            Text("Fuck Yeah.")
        }
    }
}

@available(macOS 10.15.0, *)
public final class Builder: PluginBuilder {

    public override func build() -> ImageOverlayPlugin {
        SwiftUIView()
    }
}

@available(macOS 10.15.0, *)
@_cdecl("createPlugin")
public func createPlugin() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(Builder()).toOpaque()
}
