import UIKit

var str = "Hello, playground"


func BitwiseTwo(_ strArr: [String]) -> String {
//
//    var temp = ""
//    var string1 = strArr[0]
//    var string2 = strArr[1]
//
//    while string1.count>0 && string2.count>0
//    {
//        if string1.first == "1" && string2.first == "1"
//        {
//            temp.append("1")
//        }
//        else
//        {
//            temp.append("0")
//        }
//        print(string1)
//        string1 = String(string1.dropFirst())
//        string2 = String(string2.dropFirst())
//    }
//    return temp
//
//}
    
    let temp1 = strArr[0]
    let temp2 = strArr[1]
    let temp3 = zip(temp1,temp2)
    let temp4 = temp3.map{"\($0)\($1)" == "11" ? "1" : "0"}
    let temp5 = temp4.joined(separator:"")
    
    print(temp4)
    
    return zip(strArr[0].characters,strArr[1].characters).map{ "\($0)\($1)" == "11" ? "1" : "0"}.joined(separator:"")
    
}
// keep this function call here
BitwiseTwo(["100","000"])
