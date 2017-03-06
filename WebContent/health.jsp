
<%@include file="outOfService.jsp" %>
<%
//response.sendRedirect("https://www.tstartel.com/CWS/systemServiceNote.php");
%>

<HTML>
  <HEAD>
    <TITLE>Health Check</TITLE>
  </HEAD>
  <BODY>
    <H1>Server is OK</H1>
    Today is: <%= new java.util.Date().toString() %>
  </BODY>
</HTML>