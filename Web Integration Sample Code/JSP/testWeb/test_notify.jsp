<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
<body>

<h1>Notify page</h1>

<br><br>
<% 
Map<String,String[]> allMap=request.getParameterMap();
for(String key:allMap.keySet()){
    String[] strArr=(String[])allMap.get(key);
    for(String val:strArr){
%>    	
<p><%=key %>: <%=val %> </p>
<%
    }   
}

%>

</body>
</html>