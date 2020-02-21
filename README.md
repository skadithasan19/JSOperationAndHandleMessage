
# JumboProject


I have used JS a long time ago. Since it’s a long time so I start reading WKWebview first, Like how it works and how to call the javascript method/Intercepting message. Then start working. 

According to the question I have to display the message in the native UI that’s why I choose table view in order to display all the message comes from JS. And I am loading JS in Html header in order to interact with JS. So when web view loads successfully then I call startoperation(‘id’) and JS starts firing message. Inorder to intercept those messages I created WKScriptMessageHandler and added that in WKUserContentController. So for each message I get a delegate callback in userContentController: didReceive. and I display those messages in table view sequentially. Overall I feel its working based on my understanding. But I would love to learn more about any mistake or Advice. Please share your thoughts.
 
