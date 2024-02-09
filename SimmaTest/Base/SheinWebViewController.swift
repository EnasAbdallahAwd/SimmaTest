//
//  SheinWebViewController.swift
//  SimmaTest
//
//  Created by Enas Abdallah on 08/02/2024.
//

import UIKit
import WebKit

class SheinWebViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var continerView: UIView!
    @IBOutlet weak var showCartButton: UIButton!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var itemPriceLabel: UILabel!

    private var webView: WKWebView!
    var showCart:Bool = false
    let baseUrl = URL(string: "https://us.shein.com")
    let cartUrl = URL(string: "https://us.shein.com/cart")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWebConfig()
        setshowCartButtonShadow()
    }
    
    func setUpWebConfig() {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        config.userContentController = userContentController
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = WKPreferences()

        // Here's the new magic for iOS 14:
        let webPageDefaultPrefs = WKWebpagePreferences()
        webPageDefaultPrefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = webPageDefaultPrefs

        
        webView = WKWebView(frame: continerView.bounds, configuration: config)
        webView.navigationDelegate = self // Set navigation delegate
        webView.uiDelegate = self
        continerView.addSubview(webView)
        webView?.load(URLRequest(url: baseUrl!))
        
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)

        
    }
    
    @IBAction func showCart(_ sender: Any) {
      webView?.load(URLRequest(url:showCart ? cartUrl! : baseUrl!))
    }
    
    
    deinit {
        webView.removeObserver(self, forKeyPath: "URL")
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url), let newURL = webView.url {
            print("URL changed to: \(newURL)")
            let targetURLString = "https://m.shein.com/us/cart"
            extractGoodsID(from: newURL.absoluteString)
            // Correctly use 'contains' on the 'absoluteString' of 'newURL'
            if newURL.absoluteString.contains(targetURLString) {
                print("Navigated to or on the cart page.")
                // The URL contains the target URL string
                showCart = false
                showCartButton.setTitle("Checkout", for: .normal)
            } else {
                showCart = true
                showCartButton.setTitle("Show Cart", for: .normal)
                print("URL changed to a different page: \(String(describing: webView.url))")
            }
        }
    }

    
    func setshowCartButtonShadow(){
        showCartButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        showCartButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        showCartButton.layer.shadowOpacity = 1.0
        showCartButton.layer.shadowRadius = 0.0
        showCartButton.layer.masksToBounds = false
        showCartButton.layer.cornerRadius = 15
    }
    
}
extension SheinWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        LoadingHud.showDefaultHUD(self.view,.quarbit)
        print("Navigation started")

    }
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        LoadingHud.dismissHUD()
    }

    

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
           print("WebView failed to load with error: \(error.localizedDescription)")
           // Handle error appropriately
       }
       
       func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
           print("WebView navigation failed with error: \(error.localizedDescription)")
           // Handle error appropriately
       }

   
}

   


extension SheinWebViewController {
   
    func extractGoodsID(from urlString: String) {
        let pattern = "(\\d+)\\.html"
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsRange = NSRange(urlString.startIndex..<urlString.endIndex, in: urlString)
            if let match = regex.firstMatch(in: urlString, options: [], range: nsRange) {
                let matchRange = match.range(at: 1)
                if let swiftRange = Range(matchRange, in: urlString) {
                    let id = String(urlString[swiftRange])
                    print("Extracted ID: \(id)")
                   
                    getProductDetails(goolsID: id)
                }
            }else{
                priceView.isHidden = true

            }
        } catch {
            print("Regex error: \(error)")
        }
        
    }

    
    func getProductDetails(goolsID:String) {
        ProductRequest.productDetails(goolsID: goolsID).send(ProductResponse.self){ [weak self](response) in
            guard let self = self else { return }
            switch response {
            case .failure(let error):
                guard let errorMessage = error as? APIErrorResponse else {
                    return print( error?.localizedDescription.localized ?? "")
                }
                print( errorMessage.localizedDescription.localized)
                self.priceView.isHidden = true
            case .success(let value):
                print("productValue==",value)
                self.priceView.isHidden = false
                self.itemPriceLabel.text = "ItemPrice : \(value.info?.mallInfoList?[0].salePrice?.amountWithSymbol ?? "0")"
            }
            
        }
    }
    
}
