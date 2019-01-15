//
//  ViewController.swift
//  CardIOScanSample
//
//  Created by Kojiro Yokota on 2018/10/16.
//  Copyright © 2018年 macneko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!

    lazy var cardInfo = CardIOCreditCardInfo()

    override func viewDidLoad() {
        super.viewDidLoad()

        if !CardIOUtilities.canReadCardWithCamera() {
            // カメラが使えない場合。
            // ここでスキャンボタンを非表示にする処理等を行う
        } else {
            // スキャンの遅延防止のためにCardIO SDKのリソースをあらかじめ読み込む
            CardIOUtilities.preloadCardIO()
        }
    }

    @IBAction func showPaymentViewController(_ sender: Any) {
        let vc = CardIOPaymentViewController(paymentDelegate: self)
        vc?.modalPresentationStyle = .formSheet
        present(vc!, animated: true) { [weak self] in
            self?.updateLabels()
        }
    }

    @IBAction func showCustomViewController(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomViewController") as! CustomViewController
        present(vc, animated: true)
    }

    func updateLabels() {
        cardNumberLabel.text = cardInfo.cardNumber != "" ? cardInfo.cardNumber : "番号"
        if cardInfo.expiryMonth > 0 && cardInfo.expiryYear > 0 {
            expirationDateLabel.text = String(cardInfo.expiryMonth) + "/" + String(cardInfo.expiryYear)
        } else {
            expirationDateLabel.text = "有効期限"
        }
        codeLabel.text = cardInfo.cvv != "" ? cardInfo.cvv : "セキュリティコード"
    }
}

extension ViewController: CardIOPaymentViewControllerDelegate {
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        // キャンセルボタンをタップした時に呼ばれる。
        updateLabels()
        dismiss(animated: true)
    }

    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        // カード番号のスキャン後にセキュリティーコードを手入力して完了ボタンをタップした場合や、全て手入力して完了ボタンをタップした場合に呼ばれる。
        self.cardInfo = cardInfo
        dismiss(animated: true, completion: { [weak self] in
            self?.updateLabels()
        })
    }
}
