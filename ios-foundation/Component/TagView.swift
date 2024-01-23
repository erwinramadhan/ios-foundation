//
//  ViewController.swift
//  ios-foundation
//
//  Created by Erwin Ramadhan Edwar Putra on 23/01/24.
//

import UIKit

class TagView: UIView {
    @IBOutlet weak var parentSV: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
        setupCornerRadius()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setData(title: String) {
        titleLabel.text = title
    }
    
    private func initialSetup() {
        let view = loadNib()
        addSubview(view)
        view.frame = bounds
        view.backgroundColor = .clear
    }
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: TagView.self)
        guard let nibName = type(of: self).description().components(separatedBy: ".").last else { return UIView() }
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }
    
    func setupCornerRadius() {
        parentSV.layer.cornerRadius = parentSV.frame.size.height / 2
        parentSV.clipsToBounds = true
//        layer.cornerRadius = radius
//        clipsToBounds = true
    }
}
