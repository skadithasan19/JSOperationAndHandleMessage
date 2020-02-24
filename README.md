
# Interacting with JS and Intercept JS Message
 

Here i am using a WKWebview in order to interact with JS. According to the question I need to display progress/error/stats in the native UI that’s why I choose tableview with UIProgressbar in order to display all the status/progress comes from JS. So when web view loads successfully then I call startoperation(‘id’) and JS starts sending message/progress. Inorder to intercept those message I created WKScriptMessageHandler and added that in WKUserContentController. So for each message I get a delegate callback in userContentController:didReceive. I create SaveMessageHandler inorder to avoid memory leak. Overall I feel its working based on my understanding. But I would love to learn more about any mistake or Advice. Please share your thoughts



* Does it work? Is there an independent visual representation for each operation? Is it updated with the progress? Does it communicate the error/success state?
    Yes its working. I used  WKWebView to run the JS. Yes I am showing status in a tableview  after executing startOperation(‘id’). Yes it does UIProgressbar with progress. Yes it does.  I am displaying progress/Completed/error. 

* Architecture. Are concerns separated? What dependencies are there?
I tried used MVVM in order to keep concerns separated. VC has dependecy with WebViewmodel and tableviewmodel

* Memory Management
    Probably WKWebview use separate process. But It turns out that the WKUserContentController retains its message handler.  since it could hardly send a message to its message handler if its message handler had ceased to exist.  it also causes a retain cycle, because the WKUserContentController itself is leaking.  I implemented didReceiveMemoryWarning to watch memory warning. will reload the content again cause it lose content when memory warning occurs 

* Error handling (beside the operation's error)
 handle error message as much as icould through delegate
 
* Tests. We don't do test-driven-development, but we do like code which is written in a way that it's easily testable. Make a decision which code should be tested, and how. We don't aim for 100% test-coverage, but want to be smart about what we test.
    I have created a few test case 
* Documentation. Both in the code (in a file, for functions, and for special cases,) as well documentation as an overview of your choices and how the system works as a whole make it easy for us to evaluate your work, and give us a sense of how you think about the problem, and the decisions you made -- this can just be in a readme

     
