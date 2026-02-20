//
// AddColorPresetView.swift
// RGBDemo
//

import SwiftUI

struct AddColorPresetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var presetManager: ColorPresetManager
    
    @State private var name: String = ""
    @State private var redValue: String = ""
    @State private var greenValue: String = ""
    @State private var blueValue: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("color_info".localized)) {
                    TextField("color_name_placeholder".localized, text: $name)
                        .textInputAutocapitalization(.never)
                    
                    HStack {
                        Text("R")
                            .foregroundColor(.red)
                            .frame(width: 30)
                        TextField("0-255", text: $redValue)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Text("G")
                            .foregroundColor(.green)
                            .frame(width: 30)
                        TextField("0-255", text: $greenValue)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Text("B")
                            .foregroundColor(.blue)
                            .frame(width: 30)
                        TextField("0-255", text: $blueValue)
                            .keyboardType(.numberPad)
                    }
                }
                
                Section(header: Text("preview".localized)) {
                    if let red = Double(redValue),
                       let green = Double(greenValue),
                       let blue = Double(blueValue),
                       (0...255).contains(red),
                       (0...255).contains(green),
                       (0...255).contains(blue) {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: red/255, green: green/255, blue: blue/255))
                            .frame(height: 100)
                            .overlay(
                                Text(name.isEmpty ? "preview".localized : name)
                                    .foregroundColor(.white)
                                    .shadow(radius: 2)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 100)
                            .overlay(
                                Text("preview_hint".localized)
                                    .foregroundColor(.gray)
                            )
                    }
                }
                
                if showError {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("add_preset_color_title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel".localized) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("save".localized) {
                        savePreset()
                    }
                }
            }
        }
    }
    
    private func savePreset() {
        // 验证名称
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            showError = true
            errorMessage = "color_name_missing_err_msg".localized
            return
        }
        
        // 验证RGB值
        guard let red = Double(redValue), (0...255).contains(red),
              let green = Double(greenValue), (0...255).contains(green),
              let blue = Double(blueValue), (0...255).contains(blue) else {
            showError = true
            errorMessage = "error_message".localized
            return
        }
        
        // 保存
        presetManager.addPreset(name: name, red: red, green: green, blue: blue)
        dismiss()
    }
}

#Preview {
    AddColorPresetView(presetManager: ColorPresetManager())
}
