//
//  SwiftUIView.swift
//  
//
//  Created by Gregor Feigel on 21.06.23.
//

import SwiftUI
@available(macOS 12.0, *)
struct SwiftUIVieew: View {
    var img: Data?
    
    var body: some View {
        ZStack {
            
            if let img_d = img, let i = NSImage(data: img_d) {
                Image(nsImage: i)
                    .resizable()
                    .scaledToFit()
            }
            
            // Copy right
            Text("(c) 2023 Gregor Feigel.")
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                .background(.thinMaterial)
                .cornerRadius(5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding()
            
            
            // Unit Bar
            VStack(alignment: .trailing) {
                
                HStack(spacing: 4) {
                    Text("Temp")
                        .fontWeight(.semibold)
                        .font(.system(size: 12))
                        .lineLimit(1)
                    
                    Image(systemName: "thermometer")
                        .font(.system(size: 12))
                        .accentColor(.primary)
                }
                
                // index body
                HStack {
                    VStack(alignment: .trailing) {
                        Text("45")
                            .fontWeight(.semibold)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("-30")
                            .fontWeight(.semibold)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    LinearGradient(colors:  [#colorLiteral(red: 0.1725490196, green: 0.04808554798, blue: 0.3024318814, alpha: 1), #colorLiteral(red: 0.1603391171, green: 0.4209778607, blue: 0.9343066812, alpha: 1), #colorLiteral(red: 0.3725490196, green: 0.7929377556, blue: 0.9450980392, alpha: 1), #colorLiteral(red: 0.8849725127, green: 0.8025459647, blue: 0.1648095548, alpha: 1), #colorLiteral(red: 1, green: 0.4636012316, blue: 0.08806506544, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8470588235)].asColors().reversed(),
                                   startPoint: .top,
                                   endPoint: .bottom)
                    .frame(width: 10, height: 90)
                    .cornerRadius(4)
                }
                
            }
            .fixedSize()
            .padding(8)
            .background(.thinMaterial)
            .cornerRadius(9)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding()
        }
        .fixedSize()
     }
}

@available(macOS 10.15, *)
public extension Array where Element == NSColor {
    func asColors() -> [Color] {
        return self.map { Color($0) }
    }
}

@available(macOS 12.0, *)

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIVieew(img: nil)
    }
}
