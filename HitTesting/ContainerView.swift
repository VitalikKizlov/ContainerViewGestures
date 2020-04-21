//
//  ContainerView.swift
//  HitTesting
//
//  Created by Vitalii Kizlov on 21.04.2020.
//  Copyright © 2020 Vitalii Kizlov. All rights reserved.
//

import UIKit

class ContainerView: UIView, UIGestureRecognizerDelegate {
    
    var pinchGesture: UIPinchGestureRecognizer?
    var rotationGesture: UIRotationGestureRecognizer?
    var panGesture: UIPanGestureRecognizer?
    var tapGesture: UITapGestureRecognizer?
    
    private var initialCenter = CGPoint()
    var isSelected = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        pinchGesture = UIPinchGestureRecognizer()
        pinchGesture?.addTarget(self, action: #selector(handlePinchGesture(_:)))
        pinchGesture?.delegate = self
        self.addGestureRecognizer(pinchGesture!)
        
        configureRotationGesture()
        configurePanGesture()
        configureTapGesture()
    }
    
    private func configureRotationGesture() {
        rotationGesture = UIRotationGestureRecognizer()
        rotationGesture?.addTarget(self, action: #selector(handleRotationGesture(_:)))
        rotationGesture?.delegate = self
        self.addGestureRecognizer(rotationGesture!)
    }
    
    private func configurePanGesture() {
        panGesture = UIPanGestureRecognizer()
        panGesture?.addTarget(self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGesture!)
    }
    
    public func configureTapGesture() {
        tapGesture = UITapGestureRecognizer()
        tapGesture?.addTarget(self, action: #selector(handleTapGesture(_:)))
        self.addGestureRecognizer(tapGesture!)
    }
    
    @objc private func handleRotationGesture(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        let p = gestureRecognizer.location(in: gestureRecognizer.view)
        //let p = gestureRecognizer.location(ofTouch: 0, in: gestureRecognizer.view)
        let v = gestureRecognizer.view?.hitTest(p, with: nil)
        if v == self {
            print("Blue vieww")
        } else if let view = v as? UIView {
            if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
               view.transform = view.transform.rotated(by: gestureRecognizer.rotation)
               gestureRecognizer.rotation = 0
            }
        }
    }
    
    @objc private func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        let p = gestureRecognizer.location(in: gestureRecognizer.view)
        //let p = gestureRecognizer.location(ofTouch: 0, in: gestureRecognizer.view)
        let v = gestureRecognizer.view?.hitTest(p, with: nil)
        if v == self {
            print("Blue vieww")
        } else if let view = v as? UIView {
            if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                view.transform = (view.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))
                gestureRecognizer.scale = 1.0
            }
        }
    }
    
    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        let p = gestureRecognizer.location(in: gestureRecognizer.view)
        //let p = gestureRecognizer.location(ofTouch: 0, in: gestureRecognizer.view)
        let v = gestureRecognizer.view?.hitTest(p, with: nil)
        
        if v == self {
            print("blue view")
        } else if let view = v as? UIView {
            
            let piece = view
            
            let translation = gestureRecognizer.translation(in: piece.superview)
            
            if gestureRecognizer.state == .began {
                self.initialCenter = piece.center
            }
            
            if gestureRecognizer.state != .cancelled {
                let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
                piece.center = newCenter
            } else {
                piece.center = initialCenter
            }
        }
    }
    
    @objc private func handleTapGesture(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        let p = gestureRecognizer.location(in: gestureRecognizer.view)
        let v = gestureRecognizer.view?.hitTest(p, with: nil)
        
        if v == self {
            print("blue view")
        } else if let view = v as? UIView {
            
            if gestureRecognizer.state == .ended {
                self.isSelected = !self.isSelected
                view.layer.borderColor = self.isSelected ? UIColor.red.cgColor : nil
                view.layer.borderWidth = self.isSelected ? 3 : 0
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        let simultaneousRecognizers = [pinchGesture, rotationGesture, panGesture, tapGesture]
        return simultaneousRecognizers.contains(gestureRecognizer) &&
               simultaneousRecognizers.contains(otherGestureRecognizer)
    }
    
}
