import SwiftUI
import WebKit
import Moya

struct WebView: UIViewRepresentable {
    @EnvironmentObject var loginVM: LogInViewModel

    var url: URL = URL(string: "https://smartid.ssu.ac.kr/Symtra_sso/smln.asp?apiReturnUrl=https%3A%2F%2Fsaint.ssu.ac.kr%2FwebSSO%2Fsso.jsp")!
    
    let webView: WKWebView = WKWebView()

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension WebView {
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ webView: WebView) {
            self.parent = webView
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
    }
}
