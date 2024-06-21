import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String
    @EnvironmentObject var loginVM: LogInViewModel
    @Binding var showAlert: Bool
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url, url.absoluteString.contains("https://saint.ssu.ac.kr/webSSO/sso.jsp"), let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                decisionHandler(.cancel)
                print("⭐️Usaint 로그인 성공")
                if let sToken = components.queryItems?.first(where: { $0.name == "sToken" })?.value,
                   let sIdno = components.queryItems?.first(where: { $0.name == "sIdno" })?.value {
                    parent.loginVM.usaintTokenInfo = UsaintTokenInfo(sToken: sToken, sIdno: Int(sIdno) ?? 0)
                    parent.loginVM.isAuthenticating = true
                }
                
            } else {
                decisionHandler(.allow)
            }
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "jsHandler", let responseText = message.body as? String {
                print("🔥\(responseText)")
                if responseText.contains("아이디와 비밀번호가 일치하지 않거나 잘못되었습니다.") || responseText.contains("비밀번호가 틀립니다.") || responseText.contains("로그인실패 5회 이상으로 계정이 잠깁니다.") {
                        print("제발")
//                    parent.loginVM.isAuthenticating = true
                        parent.loginVM.alertMessage = "아이디와 비밀번호가\n일치하지 않거나 잘못되었습니다."
                        parent.showAlert = true
                    }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        
        let contentController = webView.configuration.userContentController
        contentController.add(context.coordinator, name: "jsHandler")
        
        let script = WKUserScript(source: "window.webkit.messageHandlers.jsHandler.postMessage(document.documentElement.outerHTML);", injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        contentController.addUserScript(script)
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No update needed
    }
}
