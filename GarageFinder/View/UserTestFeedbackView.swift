//
//  UserTestFeedbackView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 04/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class UserTestFeedbackView: UIView {

    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        label.numberOfLines = 0
        label.text = """
                    Opa, tudo bem?
                    Agradecemos o seu interesse pelo nosso app e muito em breve você poderá encontrar garagens por aqui para estacionar normalmente.
                    Atenciosamente, Equipe Finder! ;)
                    """
//        let textLines = ["Opa, tudo bem?",
//                        "Agradecemos o seu interesse pelo nosso app, porém, estamos com problemas e esta versão ainda não está funcionando.",
//                        "Contudo, muito em breve você poderá encontrar garagens por aqui para estacionar normalmente.",
//                        "Atenciosamente, Equipe Finder! ;)"]
//        textLines.forEach { line in
//            label.text = "\(label.text ?? "")\(line) "
//        }
//        label.textAlignment = .center
        return label
    }()
    
    lazy var dismissButton: GFButton = {
        let button = GFButton()
        button.setTitle("Ok, entendo!", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(dismissButton)
        backgroundColor = .white
        setConstraints()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    private func setConstraints() {
        label.anchor
        .left(leftAnchor, padding: 16)
        .right(rightAnchor, padding: 16)
        .centerY(centerYAnchor)
        .height(heightAnchor, multiplier: 0.75)
        
        dismissButton.anchor
        .left(label.leftAnchor, padding: -4)
        .right(label.rightAnchor, padding: -4)
        .bottom(bottomAnchor, padding: 16)
        .height(dismissButton.widthAnchor, multiplier: 0.16)
    }

}
