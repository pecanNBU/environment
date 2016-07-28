<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

    String type = request.getParameter("type");
    String svg = request.getParameter("svg");
    String filename = request.getParameter("filename");
	
	/*
	if(filename ==null) {
		filename = "chart";
	}
	
	String export_type = "";
	if(type.equals("image/png")) {
		export_type = "png";
	}
	if(type.equals("image/jpeg")) {
		export_type = "jpg";
	}
	*/
    System.out.println(type + svg + filename);
    System.out.println(path + "/");
    //File svgFile = new File(path+"temp");
%>