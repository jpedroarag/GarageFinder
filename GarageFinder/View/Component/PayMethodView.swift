//
//  PayMethodView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 13/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class PayMethodView: UIView {
    //TODO: CHOOSE PAYMENT METHOD(FINISH IMPLEMENTATION)
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Forma de pagamento: "
        return label
    }()
    lazy var credidCardButton: UIButton = {
        let button = UIButton(withTitle: "Cartão de crédito(em breve)")
        button.setImage(UIImage(named: "radio_unFill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.titleLabel?.textAlignment = .left
        button.alpha = 0.5
        return button
    }()
    
    lazy var cashButton: UIButton = {
        let button = UIButton(withTitle: "Dinheiro")
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.setImage(UIImage(named: "radio_fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.textColor = .lightBlue
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews([titleLabel, credidCardButton, cashButton])
        setConstraints()
    }
    
    private func setConstraints() {
        titleLabel.anchor
            .top(safeAreaLayoutGuide.topAnchor, padding: 8)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
        
        credidCardButton.anchor
            .top(titleLabel.bottomAnchor, padding: 8)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 8)
            .height(constant: 15)
        
        cashButton.anchor
            .top(credidCardButton.bottomAnchor, padding: 4)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 8)
            .height(constant: 15)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
}
