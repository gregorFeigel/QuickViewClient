//
//  File.swift
//  
//
//  Created by Gregor Feigel on 21.06.23.
//

import Foundation
import SwiftUI


@available(macOS 10.15.0, *)
public protocol ImageOverlayPlugin {
    var preview: AnyView { get }
    var sidebar: AnyView? { get }
    func render(_: Data?) -> AnyView 
}

@available(macOS 10.15.0, *)
open class ImageOverlayPluginBuilder {
    
    public init() {}
    
    open func build() -> ImageOverlayPlugin {
        fatalError("You have to override this method.")
    }
}
 
@available(macOS 10.15.0, *)
open class PluginBuilder {
    
    public init() {}

    open func build() -> ImageOverlayPlugin {
        fatalError("You have to override this method.")
    }
}

/*
 @available(macOS 10.15.0, *)
 public final class Builder: PluginBuilder {

     public override func build(_ f: ImageOverlayPlugin) -> ImageOverlayPlugin {
          f
     }
 }


 @available(macOS 10.15.0, *)
 @_cdecl("createPlugin")
 public func createPlugin() -> UnsafeMutableRawPointer {
     return Unmanaged.passRetained(Builder()).toOpaque()
 }
 */
