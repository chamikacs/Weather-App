//
//  BottomView.swift
//  MNAD_CW_TEST
//
//  Created by Chamika Sakalasuriya on 2024-01-01.
//

import SwiftUI

struct BottomView: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}


