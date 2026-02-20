//
// ColorPresetListView.swift
// RGBDemo
//

import SwiftUI

struct ColorPresetListView: View {
    @ObservedObject var presetManager: ColorPresetManager
    var onSelectPreset: (Double, Double, Double) -> Void
        
    var body: some View {
        List {
            ForEach(presetManager.presets) { preset in
                
                HStack {
                    // 色块预览
                    RoundedRectangle(cornerRadius: 8)
                        .fill(preset.color)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            // 点击色块也触发选择
                            onSelectPreset(preset.red, preset.green, preset.blue)
                        }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(preset.name)
                            .font(.headline)
                        
                        Text(preset.rgbString)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        // 点击文字也触发选择
                        onSelectPreset(preset.red, preset.green, preset.blue)
                    }
                    
                    Spacer()
                    
                    // 使用按钮
                    Button {
                        onSelectPreset(preset.red, preset.green, preset.blue)
                    } label: {
                        Image(systemName: "paintbrush.fill")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(.vertical, 4)
                .contentShape(Rectangle()) // 让整个行可以点击
                .onTapGesture {
                    // 整行点击也触发选择
                    onSelectPreset(preset.red, preset.green, preset.blue)
                }
            }
            .onDelete(perform: presetManager.deletePreset)
        }
        .overlay {
            if presetManager.presets.isEmpty {
                VStack {
                    Image(systemName: "paintpalette")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("no_preset_color".localized)
                        .foregroundColor(.gray)
                    Text("click_plus_to_add".localized)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
