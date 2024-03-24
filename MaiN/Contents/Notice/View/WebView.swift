import SwiftUI
import WebKit
import Moya

struct WebView: UIViewRepresentable {

    var url: URL
    let webView: WKWebView = WKWebView()
    @Binding var shouldNavigateToHome: Bool

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
    
    func clearCache() {
        let dataStore = WKWebsiteDataStore.default()
        let dateFrom = Date(timeIntervalSince1970: 0)
        dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: dateFrom) {}
    }
}

extension WebView {
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var isFirstLoad = true
        init(_ webView: WebView) {
            self.parent = webView
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

            guard let currentPageURL = webView.url?.absoluteString else { return }

            if currentPageURL.contains("https://saint.ssu.ac.kr/irj/portal") {
                let forcedURL = URL(string: "https://saint.ssu.ac.kr/webSSUMain/main_student.jsp")!
                let request = URLRequest(url: forcedURL)
                webView.load(request)
                return
            }

            if isFirstLoad {
                isFirstLoad = false
                return
            }

            let jsDepartment = "document.querySelector('body > div > div.main_wrap > div.main_left > div.main_box09 > div.main_box09_con_w > ul > li:nth-child(2) > dl > dd > a > strong').innerText"

            webView.evaluateJavaScript(jsDepartment) { (result, error) in
                if let departmentName = result as? String, departmentName == "AI융합학부" {
                    let jsSchoolNumber = "document.querySelector('body > div > div.main_wrap > div.main_left > div.main_box09 > div.main_box09_con_w > ul > li:nth-child(1) > dl > dd > a > strong').innerText"
                    
                    webView.evaluateJavaScript(jsSchoolNumber) { (result, error) in
                        if let schoolNumber = result as? String {
                            UserDefaults.standard.set(schoolNumber, forKey: "schoolNumber")
                            print(schoolNumber)
                            
                            let provider = MoyaProvider<UserService>()
                            provider.request(.addUser(studentId: schoolNumber)) { result in
                                switch result {
                                case let .success(response):
                                    let responseData = String(data: response.data, encoding: .utf8)
                                    print("Success: \(responseData ?? "")")
                                case let .failure(error):
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                    self.parent.shouldNavigateToHome = true
                    self.parent.clearCache()
                }
            }
        }
    }
}
