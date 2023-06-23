//
//  SwiftUIView.swift
//  
//
//  Created by Gregor Feigel on 21.06.23.
//

import SwiftUI

@available(macOS 12.0, *)
public class DataModel: ObservableObject {
    static var shared = DataModel()
    
    @Published var settings: Preset = .init(name: "Default",
                                            author: "(c) 2023 Gregor Feigel.",
                                            max: "45",
                                            min: "-30",
                                            parameter: "Temp",
                                            icon: "thermometer",
                                            width: 500,
                                            heigth: 350,
                                            isScaled: false,
                                            colors: [.init(color: #colorLiteral(red: 0.1725490196, green: 0.04808554798, blue: 0.3024318814, alpha: 1)), .init(color: #colorLiteral(red: 0.1603391171, green: 0.4209778607, blue: 0.9343066812, alpha: 1)), .init(color: #colorLiteral(red: 0.3725490196, green: 0.7929377556, blue: 0.9450980392, alpha: 1)), .init(color: #colorLiteral(red: 0.8849725127, green: 0.8025459647, blue: 0.1648095548, alpha: 1)), .init(color: #colorLiteral(red: 1, green: 0.4636012316, blue: 0.08806506544, alpha: 1)), .init(color:  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8470588235))],
                                            padding_top: 15,
                                            padding_bottom: 15,
                                            padding_left: 15,
                                            padding_right: 15,
                                            date: "15:00")
    
}

struct StorableColor: Codable, Identifiable {
    
    init(id: UUID = UUID(), red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.id = id
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(color c: NSColor) {
        self.id    = UUID()
        self.red   = c.redComponent
        self.green = c.greenComponent
        self.blue  = c.blueComponent
        self.alpha = c.alphaComponent
    }
    
    var id: UUID = UUID()
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
    
    var color: NSColor { .init(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha) }
}

struct Preset: Codable {
     var id: UUID = UUID()
     var name: String
    
     var author: String
     var max: String
     var min: String
     var parameter: String
     var icon: String
    
     var width: CGFloat
     var heigth: CGFloat
    
     var imageSize: CGSize?
     var isScaled: Bool
     var scale_1: CGFloat = 1
     var scale_2: CGFloat = 1
     var scale_3: CGFloat = 1

     var colors: [StorableColor]
    
     var padding_top: CGFloat
     var padding_bottom: CGFloat
     var padding_left: CGFloat
     var padding_right: CGFloat
    
     var date: String
}

struct DefaultStorageObject: Identifiable, Hashable {
    let id: UUID = UUID()
    let url: URL
    let name: String
}

@available(macOS 13.0, *)
struct Sidebar: View {
    var img: Data?
    @ObservedObject var model = DataModel.shared
    
    let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    @State private var selcted: DefaultStorageObject? = nil
    @State private var selection: [DefaultStorageObject] = []
    @State private var alert: Bool = false
    @State private var name: String = ""
    
    @State private var error_msg: String = ""
 

    var body: some View {
        ScrollView {
//            Text(verbatim: error_msg)
            
            VStack(alignment: .leading, spacing: 15) {
 
                author_setting
                
                size_setting
                
                color_scale_setting
                
                padding_setting
                
                Divider()
                
                Button {
                    withAnimation {
                        alert.toggle()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Safe")
                        Spacer()
                    }
                }
                
                Button {
                    if let sel = selcted {
                        do {
                            let base_url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("b86b0a5a-11f8-11ee-be56-0242ac120002")
                            var isDir: ObjCBool = true
                            if FileManager.default.fileExists(atPath: base_url.path, isDirectory: &isDir) == false {
                                try FileManager.default.createDirectory(at: base_url, withIntermediateDirectories: true)
                            }
                            let data = try JSONEncoder().encode(model.settings)
                            try data.write(to: sel.url)
                        }
                        catch { print(error); error_msg = "\(error)" } }
                    else {
                        withAnimation {
                            alert.toggle()
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Update")
                        Spacer()
                    }
                }
 
                
                if !selection.isEmpty {
                    Picker(selection: $selcted) {
                    // Text("").tag(nil as DefaultStorageObject?)
                     ForEach(selection, id: \.id) { n in
                         Text(verbatim:  n.name).tag(n as DefaultStorageObject?)
                     }
                    } label: {
                        Text(verbatim: "Template")
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .task {
            do { try await load() }
            catch { print(error); error_msg = "\(error)" }
        }
        .onChange(of: selcted, perform: { _ in
            if let sel = selcted {
                do {
                    let data = try Data(contentsOf: sel.url)
                    model.settings = try JSONDecoder().decode(Preset.self, from: data)
                }
                catch {  print(error); error_msg = "\(error)" }
            }
        })
        .alert("Name your template!", isPresented: $alert) {
                    TextField("name", text: $name)
                    Button("Safe") {
                        do {
                            let base_url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("b86b0a5a-11f8-11ee-be56-0242ac120002")
                            var isDir: ObjCBool = true
                            if FileManager.default.fileExists(atPath: base_url.path, isDirectory: &isDir) == false {
                                try FileManager.default.createDirectory(at: base_url, withIntermediateDirectories: true)
                            }
                            let data = try JSONEncoder().encode(model.settings)
                            try data.write(to: base_url.appendingPathComponent(UUID().uuidString + "-" + name))
                            
                            Task { try await load() }
                        }
                        catch { print(error); error_msg = "\(error)" }
                    }
                } message: {
                    Text("Name your template!")
                }
       // .frame(width: 250, height: 600)
    }
    
    
    func load() async throws {
        var container: [DefaultStorageObject] = []
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("b86b0a5a-11f8-11ee-be56-0242ac120002")
        let data = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        
        for n in data where !n.lastPathComponent.contains(".DS") {
            container.append(.init(url: n, name: String(n.lastPathComponent.dropFirst(37))))
        }
        
        await MainActor.run {
            selection = container
        }
    }
    
    func calculateProportion(from image: CGSize) -> Double? {
        let width = Double(image.width)
        let height = Double(image.height)
        
        // Check if the dimensions are valid
        guard width > 0, height > 0 else {
            return nil
        }
        
        let aspectRatio = width / height
        return aspectRatio
    }
    
    func adjustSizeToAspectRatio(aspectRatio: Double, width: Double, height: Double) -> (adjustedWidth: Double, adjustedHeight: Double) {
        let currentAspectRatio = width / height

        if currentAspectRatio > aspectRatio {
            let adjustedHeight = width / aspectRatio
            return (width, adjustedHeight)
        } else if currentAspectRatio < aspectRatio {
            let adjustedWidth = height * aspectRatio
            return (adjustedWidth, height)
        } else {
            return (width, height)
        }
    }
    
    var size_setting: some View {
        VStack(alignment: .leading) {
            Divider()
            Text("Size")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading) {
             
                
                HStack {
                    Text("W:")
                    TextField("width", value: $model.settings.width, formatter: amountFormatter)
                        .onSubmit {
                            if let size = model.settings.imageSize, let aspect = calculateProportion(from: size) {
                                 let new = adjustSizeToAspectRatio(aspectRatio: aspect,
                                                                    width: model.settings.width,
                                                                    height: model.settings.heigth)
                                model.settings.heigth = new.adjustedHeight
                            }
                        }
                    
                    Text("H:")
                    TextField("heigth", value: $model.settings.heigth, formatter: amountFormatter)
                        .onSubmit {
                            if let size = model.settings.imageSize, let aspect = calculateProportion(from: size) {
                                 let new = adjustSizeToAspectRatio(aspectRatio: aspect,
                                                                    width: model.settings.width,
                                                                    height: model.settings.heigth)
                                model.settings.width = new.adjustedWidth
                            }
                        }
                }
                
                Button {
                    if let size = model.settings.imageSize {
                        model.settings.width = size.width
                        model.settings.heigth = size.height
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text(verbatim: "Original Size")
                        Spacer()
                    }
                }
                .disabled(model.settings.imageSize == nil)
                
                
                Toggle("Scale View", isOn: $model.settings.isScaled)
                    .padding(.top)

                if model.settings.isScaled {
                    HStack {
                        VStack {
                            TextField("scale_1", value: $model.settings.scale_1, formatter: amountFormatter)
                            Text("Author")
                        }
                        
                        VStack {
                            TextField("scale_2", value: $model.settings.scale_2, formatter: amountFormatter)
                            Text("Scale")
                        }
                        
                        VStack {
                            TextField("scale_3", value: $model.settings.scale_3, formatter: amountFormatter)
                            Text("Date")
                        }
                    }
                }
                
            }
            .padding(.leading)
        }
    }
    
    let columns = [
           GridItem(.adaptive(minimum: 15))
       ]
    @State private var bgColor = Color.red
    @State private var picker: Bool = false

    var color_scale_setting: some View {
        VStack(alignment: .leading) {
            Divider()
            Text("Color Scale")
                .font(.title3)
                .fontWeight(.semibold)
        
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("Value:")
                    TextField("parameter", text: $model.settings.parameter)
                }
                
                HStack {
                    Text("Icon:  ")
                    TextField("icon", text: $model.settings.icon)
                }
               
                HStack {
                    Text(verbatim: "Min:")
                    TextField("max", text: $model.settings.min)
                    Text(verbatim: "Max:")
                    TextField("min", text: $model.settings.max)
                }
                .padding(.bottom)

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(model.settings.colors, id: \.id) { n in
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color(n.color))
                            .contextMenu {
                                Button("Remove") {
                                    if let index = model.settings.colors.firstIndex(where: {  $0.id == n.id }) {
                                        model.settings.colors.remove(at: index)
                                    }
                                }
                            }
                    }
                    
                    Image(systemName: "plus")
                        .fontWeight(.semibold)
                        .padding(2)
                        .background(.black.opacity(0.2))
                        .cornerRadius(5)
                        .popover(isPresented: $picker) {
                            HStack {
                                ColorPicker("", selection: $bgColor)
                                Spacer()
                                Button("Add") {
                                    model.settings.colors.append(.init(color: NSColor(bgColor)))
                                }
                            }
                                .padding()
                        }
                        .onTapGesture {
                            withAnimation {
                                picker = true
                            }
                        }

                }


            }
            .padding(.leading)
        }
    }
    
    var author_setting: some View {
        VStack(alignment: .leading) {
            
            Text("Author")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Text:")
                    TextField("author", text: $model.settings.author)
                }
                HStack {
                    Text("Date:")
                    TextField("date", text: $model.settings.date)
                }

            }
            .padding(.leading)
        }
    }
    
    var padding_setting: some View {
        VStack(alignment: .leading) {
            Divider()
            Text("Padding")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading) {
                
                HStack {
                    
                    VStack(spacing: 3) {
                        TextField("top", value: $model.settings.padding_top, formatter: amountFormatter)
                            Text(verbatim: "Top")
                    }
                    
                    VStack(spacing: 3) {
                        TextField("bottom", value: $model.settings.padding_bottom, formatter: amountFormatter)
                            Text(verbatim: "Bottom")
                    }
                    
                    VStack(spacing: 3) {
                        TextField("left", value: $model.settings.padding_left, formatter: amountFormatter)
                            Text(verbatim: "Left")
                    }
                    
                    VStack(spacing: 3) {
                        TextField("right", value: $model.settings.padding_right, formatter: amountFormatter)
                            Text(verbatim: "Right")
                    }
                    
                }
            
            }
            .padding(.leading)
        }
    }
}
 
@available(macOS 12.0, *)
struct SwiftUIVieew: View {
    var img: Data?
    @ObservedObject var model = DataModel.shared
 
    var body: some View {
        ZStack {
            
            if let img_d = img, let i = NSImage(data: img_d) {
                Image(nsImage: i)
                    .resizable()
                    .scaledToFit()
            }
            
            // Copy right
            Text(model.settings.author)
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                .background(.thinMaterial)
                .cornerRadius(5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.bottom, model.settings.padding_bottom)
                .padding(.leading, model.settings.padding_left)
                .scaleEffect(model.settings.scale_1)
            
            if  !model.settings.date.isEmpty  {
                // Copy right
                Text(model.settings.date)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .background(.thinMaterial)
                    .cornerRadius(5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.bottom, model.settings.padding_bottom)
                    .padding(.trailing, model.settings.padding_right)
                    .scaleEffect(model.settings.scale_3)
            }

            
            // Unit Bar
            VStack(alignment: .trailing) {
                
                HStack(spacing: 4) {
                    Text(model.settings.parameter)
                        .fontWeight(.semibold)
                        .font(.system(size: 12))
                        .lineLimit(1)
                    
                    Image(systemName: model.settings.icon)
                        .font(.system(size: 12))
                        .accentColor(.primary)
                }
                
                // index body
                HStack {
                    VStack(alignment: .trailing) {
                        Text(model.settings.max)
                            .fontWeight(.semibold)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(model.settings.min)
                            .fontWeight(.semibold)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    LinearGradient(colors:  model.settings.colors.map({ $0.color }).asColors().reversed(),
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
            .padding(.top, model.settings.padding_top)
            .padding(.trailing, model.settings.padding_right)
            .scaleEffect(model.settings.scale_2)
        }
        .frame(width: model.settings.width, height: model.settings.heigth)
        .onChange(of: img) { _ in
            Task {
                if let imgd = img {
                    if let image = NSImage(data: imgd) {
                        await MainActor.run {
                            model.settings.imageSize = .init(width: image.size.width,
                                                             height: image.size.height)
         
                        }
                    }
                }
            }
        }
        //.fixedSize()
     }
    
     
}

@available(macOS 10.15, *)
public extension Array where Element == NSColor {
    func asColors() -> [Color] {
        return self.map { Color($0) }
    }
}

@available(macOS 13.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
       // SwiftUIVieew(img: nil)
        Sidebar()
    }
}
