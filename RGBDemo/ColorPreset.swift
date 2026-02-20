//
// ColorPreset.swift
// RGBDemo
//

import Foundation
import SwiftUI

struct ColorPreset: Identifiable, Codable {
    let id: UUID
    var name: String
    var red: Double
    var green: Double
    var blue: Double
    
    init(id: UUID = UUID(), name: String, red: Double, green: Double, blue: Double) {
        self.id = id
        self.name = name
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    var color: Color {
        Color(red: red / 255, green: green / 255, blue: blue / 255)
    }
    
    var rgbString: String {
        String(format: "RGB: %.0f, %.0f, %.0f", red, green, blue)
    }
}

// 用于管理常用色值的类
class ColorPresetManager: ObservableObject {
    @Published var presets: [ColorPreset] = []
    
    private let saveKey = "ColorPresets"
    
    init() {
        loadPresets()
    }
    
    func addPreset(name: String, red: Double, green: Double, blue: Double) {
        let preset = ColorPreset(name: name, red: red, green: green, blue: blue)
        presets.append(preset)
        savePresets()
    }
    
    func deletePreset(at indexSet: IndexSet) {
        presets.remove(atOffsets: indexSet)
        savePresets()
    }
    
    func updatePreset(_ preset: ColorPreset) {
        if let index = presets.firstIndex(where: { $0.id == preset.id }) {
            presets[index] = preset
            savePresets()
        }
    }
    
    private func savePresets() {
        if let encoded = try? JSONEncoder().encode(presets) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadPresets() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([ColorPreset].self, from: data) {
            presets = decoded
        }
    }
}
