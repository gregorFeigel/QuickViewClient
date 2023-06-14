//
//  File.swift
//  
//
//  Created by Gregor Feigel on 14.06.23.
//

import Foundation
import SwiftUI

public extension CGImage {
  
    func pngData() -> Data? {
    let cfdata: CFMutableData = CFDataCreateMutable(nil, 0)
    if let destination = CGImageDestinationCreateWithData(cfdata, kUTTypePNG as CFString, 1, nil) {
      CGImageDestinationAddImage(destination, self, nil)
      if CGImageDestinationFinalize(destination) {
        return cfdata as Data
      }
    }
    
    return nil
  }
}
