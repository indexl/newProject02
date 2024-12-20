<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>

<%@ page import="javax.xml.parsers.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>버스정류장 정보</title>
    <style>
        .search-container {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            gap: 10px;
        }
        
        .search-input {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            width: 150px;
            order: 2;
        }
        
        .search-input::placeholder {
            color: #aaa;
        }
        
        h1 {
            text-align: center;
            margin-bottom: 30px;
        }
        
        body {
            font-family: 'Noto Sans KR', sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        
        .info-box {
            margin: 10px 0;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        
        .info-label {
            font-weight: bold;
            color: #333;
            margin-right: 10px;
        }
        
        .route-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }
        
        .route-number {
            background-color: #007bff;
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 14px;
        }
        
        .button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
        }
        
        .button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>버스정류장 정보</h1>
        
        <div class="search-container">
            <input type="text" id="busStopIdInput" class="search-input" placeholder="정류장 입력" value="8001378">
            <button class="button" onclick="loadBusStopInfo()">근처 정류장 정보 불러오기</button>
        </div>
        
        <div id="busStopInfo">
            <%
                try {
                    String serviceKey = "EfInCPvp1KaSRfM%2BCL%2FNaAOmlo%2FM%2BhjKoLRHOcQ8%2FoqhkalDqtHzKQ8KB1cdtWuNP3xVFG56nJ6WGUSpdQoWRQ%3D%3D";
                    String busStopId = request.getParameter("busStopId");
                    if (busStopId == null || busStopId.trim().isEmpty()) {
                        busStopId = "8001378";  // 기본값 설정
                    }
                    String urlStr = "http://openapitraffic.daejeon.go.kr/api/rest/stationinfo/getStationByStopID" +
                                  "?serviceKey=" + serviceKey +
                                  "&BusStopID=" + busStopId;
                    
                    URL url = new URL(urlStr);
                    DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
                    DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
                    Document doc = dBuilder.parse(url.openStream());
                    
                    doc.getDocumentElement().normalize();
                    
                    NodeList itemList = doc.getElementsByTagName("itemList");
                    if (itemList.getLength() > 0) {
                        Node item = itemList.item(0);
                        if (item.getNodeType() == Node.ELEMENT_NODE) {
                            Element element = (Element) item;
                            %>
                            <div class="info-box">
                                <p><span class="info-label">정류장 이름:</span> <%= getNodeValue(element, "BUSSTOP_NM") %></p>
                                <p><span class="info-label">영문 이름:</span> <%= getNodeValue(element, "BUSSTOP_ENG_NM") %></p>
                                <p><span class="info-label">도로명:</span> <%= getNodeValue(element, "ROAD_NM") %></p>
                                <p><span class="info-label">GPS 좌표:</span> 
                                   위도 <%= getNodeValue(element, "GPS_LATI") %>, 
                                   경도 <%= getNodeValue(element, "GPS_LONG") %>
                                </p>
                                <p><span class="info-label">버스 노선:</span></p>
                                <div class="route-list">
                                    <%
                                    String routes = getNodeValue(element, "ROUTE_NO");
                                    if (routes != null && !routes.trim().isEmpty()) {
                                        String[] routeArray = routes.split(",");
                                        for (String route : routeArray) {
                                            %>
                                            <span class="route-number"><%= route.trim() %></span>
                                            <%
                                        }
                                    }
                                    %>
                                </div>
                            </div>
                            <%
                        }
                    }
                } catch (Exception e) {
                    out.println("에러 발생: " + e.getMessage());
                }
            %>
        </div>
    </div>
    
    <script>
        function loadBusStopInfo() {
            const busStopId = document.getElementById('busStopIdInput').value;
            if (busStopId.trim() === '') {
                alert('정류장 ID를 입력해주세요.');
                return;
            }
            // 입력받은 정류장 ID로 페이지 새로고침
            window.location.href = window.location.pathname + '?busStopId=' + busStopId;
        }

        // Enter 키 이벤트 처리
        document.addEventListener('DOMContentLoaded', function() {
            const input = document.getElementById('busStopIdInput');
            input.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    loadBusStopInfo();
                }
            });
        });
    </script>
</body>
</html>

<%!
    private String getNodeValue(Element element, String tagName) {
        NodeList nodeList = element.getElementsByTagName(tagName);
        if (nodeList.getLength() > 0) {
            Node node = nodeList.item(0);
            if (node.hasChildNodes()) {
                return node.getFirstChild().getNodeValue();
            }
        }
        return "";
    }
%>