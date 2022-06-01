//
//  UIViewExtensions.swift
//  CoreDataMusicApp
//
//  Created by Consultant on 6/1/22.
//

import UIKit

extension UIView {
    
    convenience init(resistancePriority: UILayoutPriority, huggingPriority: UILayoutPriority) {
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setContentHuggingPriority(huggingPriority, for: .vertical)
        self.setContentHuggingPriority(huggingPriority, for: .horizontal)
        self.setContentCompressionResistancePriority(resistancePriority, for: .vertical)
        self.setContentCompressionResistancePriority(resistancePriority, for: .horizontal)
        self.backgroundColor = .clear
    }
    
    func bindToSuperView(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        
        guard let superview = self.superview else {
            fatalError("Forgot to add to the view hierarchy")
        }
        
        self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom).isActive = true
        
    }
    
}
