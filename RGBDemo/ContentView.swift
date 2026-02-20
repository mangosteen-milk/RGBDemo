//
// ContentView.swift
// RGBDemo
//

import SwiftUI

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

struct ContentView: View {
    // 状态变量 - 存储输入和颜色值
    @State private var redValue: String = ""
    @State private var greenValue: String = ""
    @State private var blueValue: String = ""
    @State private var backgroundColor: Color = .white
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    // 常用色值管理
    @StateObject private var presetManager = ColorPresetManager()
    @State private var showingAddPreset = false
    @State private var showingPresetList = false
    
    // 色卡选中状态
    @State private var selectedPresetId: UUID?
    
    // 跟踪焦点状态
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
        VStack(spacing: 20) {
            // 标题
            Text("title".localized)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            Spacer()
            
            // 输入区域
            VStack(spacing: 15) {
                // 红色输入框
                HStack {
                    Text("red_label".localized)
                        .font(.title2)
                        .frame(width: 40)
                    
                    TextField("red_placeholder".localized, text: $redValue)
                        .focused($isTextFieldFocused)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .font(.title2)
                    
                    Color.red
                        .frame(width: 30, height: 30)
                        .cornerRadius(5)
                }
                
                // 绿色输入框
                HStack {
                    Text("green_label".localized)
                        .font(.title2)
                        .frame(width: 40)
                    
                    TextField("green_placeholder".localized, text: $greenValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .font(.title2)
                    
                    Color.green
                        .frame(width: 30, height: 30)
                        .cornerRadius(5)
                }
                
                // 蓝色输入框
                HStack {
                    Text("blue_label".localized)
                        .font(.title2)
                        .frame(width: 40)
                    
                    TextField("blue_placeholder".localized, text: $blueValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .font(.title2)
                    
                    Color.blue
                        .frame(width: 30, height: 30)
                        .cornerRadius(5)
                }
            }
            .padding(.horizontal, 40)
            
            // 错误提示
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.callout)
            }
            
            // 应用颜色按钮
            Button(action: applyColor) {
                Text("apply".localized)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            // 当前颜色预览
            VStack {
                Text("current_color".localized)
                    .font(.headline)
                
                Text(String(format: "rgb_format".localized,
                           redValue.isEmpty ? "-" : redValue,
                           greenValue.isEmpty ? "-" : greenValue,
                           blueValue.isEmpty ? "-" : blueValue))
                    .font(.subheadline)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // 新增：常用色值快捷区域
            if !presetManager.presets.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("preset_colors_title".localized)
                            .font(.headline)
                        
                        Spacer()
                        
                        Button {
                            showingPresetList = true
                        } label: {
                            Text("manage".localized)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(presetManager.presets.prefix(5)) { preset in
                                Button {
                                    setColorFromPreset(preset)
                                } label: {
                                    VStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(preset.color)
                                            .frame(width: 60, height: 60)
                                        
                                        Text(preset.name)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                            .frame(width: 60)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            
            Spacer()
            
            Text("usage_hint".localized)
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // 右上角新建按钮
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddPreset = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddPreset) {
            AddColorPresetView(presetManager: presetManager)
        }
        .sheet(isPresented: $showingPresetList) {
            NavigationView {
                ColorPresetListView(presetManager: presetManager) { red, green, blue in
                    backgroundColor = Color(red: red/255, green: green/255, blue: blue/255)
                    redValue = String(Int(red))
                    greenValue = String(Int(green))
                    blueValue = String(Int(blue))
                    showingPresetList = false
                }
                .navigationTitle("presets_management_title".localized)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("close".localized) {
                            showingPresetList = false
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showingPresetList = false
                            showingAddPreset = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
            // 只在键盘弹出时添加点击手势
            .overlay(
                Group {
                    if isTextFieldFocused {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                hideKeyboard()
                            }
                    }
                }
            )
    }
}
    
    // applyColor 函数
    func applyColor() {
        guard let red = Double(redValue), (0...255).contains(red),
              let green = Double(greenValue), (0...255).contains(green),
              let blue = Double(blueValue), (0...255).contains(blue) else {
            showError = true
            errorMessage = "error_message".localized
            return
        }
        
        showError = false
        errorMessage = ""
        
        backgroundColor = Color(
            red: red / 255,
            green: green / 255,
            blue: blue / 255
        )
    }
    
    // 从常用色值设置颜色
    func setColorFromPreset(_ preset: ColorPreset) {
        backgroundColor = preset.color
        redValue = String(Int(preset.red))
        greenValue = String(Int(preset.green))
        blueValue = String(Int(preset.blue))
        showError = false
    }

    // hideKeyboard 函数
    func hideKeyboard() {
        isTextFieldFocused = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                      to: nil, from: nil, for: nil)
    }
}

// 预览
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
