
<%
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
java.util.Date start = sdf.parse("2015/10/19 17:46:00");
java.util.Date end = sdf.parse("2015/10/19 17:50:00");

java.util.Date now = new java.util.Date();

if(now.after(start) && now.before(end)){
	response.sendRedirect("https://www.tstartel.com/CWS/systemServiceNote.php");
}

%>

