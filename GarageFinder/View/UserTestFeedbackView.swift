//
//  UserTestFeedbackView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 04/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class UserTestFeedbackView: UIView {

    lazy var field: UITextView = {
        let field = UITextView()
        field.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        field.text = """
                    Opa, tudo bem?
                    Agradecemos o seu interesse pelo nosso app e muito em breve você poderá encontrar garagens por aqui para estacionar normalmente.
                    Por ora, você pode testar o fluxo da aplicação.
                    Se você criar uma conta, nós o notificaremos via e-mail em breve.
                    Atenciosamente, Equipe Finder! ;)
                    """
        field.isEditable = false
        field.isSelectable = false
        return field
    }()
    
    lazy var dismissButton: GFButton = {
        let button = GFButton()
        button.setTitle("Ok, entendo!", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(field)
        addSubview(dismissButton)
        backgroundColor = .white
        setConstraints()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    private func setConstraints() {
        field.anchor
        .left(leftAnchor, padding: 16)
        .right(rightAnchor, padding: 16)
        .centerY(centerYAnchor)
        .height(heightAnchor, multiplier: 0.75)
        
        dismissButton.anchor
        .left(field.leftAnchor, padding: -4)
        .right(field.rightAnchor, padding: -4)
        .bottom(bottomAnchor, padding: 16)
        .height(dismissButton.widthAnchor, multiplier: 0.16)
    }

}
