//
//  SwiftUIView.swift
//  
//
//  Created by Gregor Feigel on 21.06.23.
//

import SwiftUI
import PluginInterface

@available(macOS 10.15.0, *)
struct SwiftUIView: View {
    
    var body: some View {
        VStack {
            Text("Hell Yeah.")
        }
    }
}

@available(macOS 12.0, *)
struct ImageOverlay: View {
    var img: Data?

    var body: some View {
        ZStack {
            if let img_d = img, let i = NSImage(data: img_d) {
                Image(nsImage: i)
                    .resizable()
                    .scaledToFit()
            }
            
            Text("Hell Yeah.")
                .padding(.vertical, 30)
                .padding(.horizontal, 100)
                .background(.thinMaterial)
                .cornerRadius(15)
                .padding(.bottom)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}
 

@available(macOS 13.0, *)
struct Provider: ImageOverlayPlugin {
    
    var sidebar: AnyView? {  AnyView(Sidebar()) }
    
    func render(_ data: Data?) -> AnyView {
         AnyView(SwiftUIVieew(img: data))
    }
    
    var preview: AnyView { AnyView(SwiftUIView()) }
}


@available(macOS 13.0, *)
public final class Builder: PluginBuilder {

    public override func build() -> ImageOverlayPlugin {
        Provider()
    }
}

@available(macOS 13.0, *)
@_cdecl("createPlugin")
public func createPlugin() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(Builder()).toOpaque()
}
