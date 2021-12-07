//
//  ViewController.swift
//  rulerview
//
//  Created by Dohyun Kim on 2021/12/03.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - Public Properties
    var valueChanged: ((Double) -> Void)?
    
    // MARK: - Private Properties
    private var rulerControl: RulerControl?
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.text = "0.0"
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createRulerControl()
        setupUI()
    }
    
    // MARK: - Private Methods
    private func createRulerControl() {
        rulerControl = RulerControl(unit: Length.Unit.centimeter, length: 20, step: 0.1)
        rulerControl?.tintColor = .black
        rulerControl?.addTarget(self, action: #selector(_rulerValueChanged(_:)), for: .valueChanged)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupValueLabel()
        setupRulerControl()
    }
    
    private func setupValueLabel() {
        view.addSubview(valueLabel)
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupRulerControl() {
        guard let rulerControl = rulerControl else { return }
        
        view.addSubview(rulerControl)
        
        rulerControl.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(40)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(69)
        }
    }
    
    // MARK: - Actions
    @objc private func _rulerValueChanged(_ ruler: RulerControl) {
        print(String.init(format: "%.1f", ruler.value))
        valueLabel.text = "\(Float(ruler.value))"
        valueChanged?(Double(ruler.value))
    }
}

