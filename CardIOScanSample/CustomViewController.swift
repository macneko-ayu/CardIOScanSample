//
//  CustomViewController.swift
//  CardIOScanSample
//
//  Created by Kojiro Yokota on 2018/10/17.
//  Copyright © 2018年 macneko. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // スキャンの遅延防止のためにCardIO SDKのリソースをあらかじめ読み込む
        CardIOUtilities.preloadCardIO()

        let cardIOView = CardIOView(frame: view.frame)
        cardIOView.hideCardIOLogo = true // スキャンのビューの右上に表示されるロゴを非表示にする
        cardIOView.scanInstructions = "枠内にカード全体が入るようにしてください" // 文言設定
        cardIOView.guideColor = UIColor.orange // 枠線の色をオレンジに
        cardIOView.delegate = self
        view.addSubview(cardIOView)
        view.sendSubviewToBack(cardIOView)
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension CustomViewController: CardIOViewDelegate {
    func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
        let parentVC = presentingViewController as! ViewController
        dismiss(animated: true) {
            parentVC.cardInfo = cardInfo
            parentVC.updateLabels()
        }
    }
}
