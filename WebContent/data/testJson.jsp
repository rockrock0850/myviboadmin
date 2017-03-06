<%@ page language="java" pageEncoding="utf-8" contentType="text/html;charset=utf-8" %>
<html>
<body>

<h1>Customers</h1>
<div id="id01"></div>

<script>
var xmlhttp = new XMLHttpRequest();
var url = "/myviboadmin/data/json_20141006_ios.json";

function myFunction(response) {
    var arr = JSON.parse(response);
    arr = arr.promote_banner.promote_data;
    var i;
    var out = "<table>";

    for(i = 0; i < arr.length; i++) {
        out += "<tr><td><a href='"+ arr[i].url +"'><img src='http://172.23.1.129:8080/" +
        arr[i].pic + 
        "' /></a></td><td>" +
        arr[i].url +
        "</td></tr>";
    }
    out += "</table>";
    document.getElementById("id01").innerHTML = out;
};

xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        myFunction(xmlhttp.responseText);
    }
};
xmlhttp.open("GET", url, true);
xmlhttp.send();
</script>

<div id="id01"></div>
</body>
</html>