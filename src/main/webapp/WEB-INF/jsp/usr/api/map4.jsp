<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>
<%@ page import="javax.xml.parsers.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>버스정류장 정보</title>
 
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background: linear-gradient(135deg, #F0FFFF 0%, #8FE5D0 100%);
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

        .arrival-info {
            background-color: #f8f9fa;
            padding: 15px;
            margin-top: 20px;
            border-radius: 5px;
        }

        .bus-arrival {
            margin: 10px 0;
            padding: 10px;
            border-left: 4px solid #007bff;
            background-color: white;
        }

        .arrival-time {
            color: #dc3545;
            font-weight: bold;
        }

        #lastUpdateTime {
            color: #666;
            margin: 10px 0;
            font-style: italic;
        }
        
        .button-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>버스정류장 정보</h1>
        <div id="lastUpdateTime"></div>

        <div id="busStopInfo">
            <%
                String serviceKey = "EfInCPvp1KaSRfM%2BCL%2FNaAOmlo%2FM%2BhjKoLRHOcQ8%2FoqhkalDqtHzKQ8KB1cdtWuNP3xVFG56nJ6WGUSpdQoWRQ%3D%3D";
                String busStopId = request.getParameter("busStopId");
                if(busStopId == null || busStopId.isEmpty()) {
                    busStopId = "8002721"; // 기본값
                }
                
                try {
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
                            String latitude = getNodeValue(element, "GPS_LATI");
                            String longitude = getNodeValue(element, "GPS_LONG");
                            %>
                            <div class="button-container" style="display: flex; justify-content: space-between; align-items: center; gap: 20px;">
                                <button class="button" onclick="loadBusStopInfo()">정보 새로고침</button>
                                
                                <div style="text-align: center;">
                                    <input type="text" id="busStopIdInput" 
                                        placeholder="정류장ID 입력" 
                                        style="padding: 8px;
                                               border-radius: 4px;
                                               border: 1px solid #ccc;
                                               width: 120px;
                                               margin-bottom: 2px;"
                                        onkeypress="if(event.keyCode==13) updateBusStopId()">
                                    <div style="color: #888; font-size: 12px;">
                                        8002721 충남대학교<br>
                                        8001378 대전광역시청<br>
                                        8001195 대덕구청
                                    </div>
                                </div>
                                
                                <button class="button" style="background-color: #007bff;" 
                                        onclick="location.href='/usr/api/map5?lat=<%= latitude %>&lng=<%= longitude %>'">
                                    거리뷰 확인
                                </button>
                            </div>

                            <div class="info-box">
                                <p><span class="info-label">정류장 이름:</span> <%= getNodeValue(element, "BUSSTOP_NM") %></p>
                                <p><span class="info-label">영문 이름:</span> <%= getNodeValue(element, "BUSSTOP_ENG_NM") %></p>
                                <p><span class="info-label">도로명:</span> <%= getNodeValue(element, "ROAD_NM") %></p>
                                <p><span class="info-label">GPS 좌표:</span> 
                                   위도 <%= latitude %>, 
                                   경도 <%= longitude %>
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

                    String arrivalUrlStr = "http://openapitraffic.daejeon.go.kr/api/rest/arrive/getArrInfoByStopID" +
                                         "?serviceKey=" + serviceKey +
                                         "&BusStopID=" + busStopId;
                    
                    url = new URL(arrivalUrlStr);
                    doc = dBuilder.parse(url.openStream());
                    doc.getDocumentElement().normalize();
                    
                    NodeList arrivalList = doc.getElementsByTagName("itemList");
                    %>
                    <div class="arrival-info">
                        <h2>버스 도착 예정 정보</h2>
                    <%
                    if (arrivalList.getLength() > 0) {
                        List<Element> sortedArrivals = new ArrayList<>();
                        for (int i = 0; i < arrivalList.getLength(); i++) {
                            Node arrivalItem = arrivalList.item(i);
                            if (arrivalItem.getNodeType() == Node.ELEMENT_NODE) {
                                sortedArrivals.add((Element) arrivalItem);
                            }
                        }

                        Collections.sort(sortedArrivals, (a, b) -> {
                            int timeA = Integer.parseInt(getNodeValue(a, "EXTIME_MIN")) * 60 
                                    + Integer.parseInt(getNodeValue(a, "EXTIME_SEC"));
                            int timeB = Integer.parseInt(getNodeValue(b, "EXTIME_MIN")) * 60 
                                    + Integer.parseInt(getNodeValue(b, "EXTIME_SEC"));
                            return timeA - timeB;
                        });

                        for (Element arrivalElement : sortedArrivals) {
                            int seconds = Integer.parseInt(getNodeValue(arrivalElement, "EXTIME_SEC"));
                            int additionalMinutes = seconds / 60;
                            int remainingSeconds = seconds % 60;
                            int totalMinutes = Integer.parseInt(getNodeValue(arrivalElement, "EXTIME_MIN")) + additionalMinutes;
                            %>
                            <div class="bus-arrival">
                                <p><span class="info-label">버스번호:</span> 
                                   <%= getNodeValue(arrivalElement, "ROUTE_NO") %>
                                </p>
                                <p><span class="info-label">도착지:</span> 
                                   <%= getNodeValue(arrivalElement, "DESTINATION") %>
                                </p>
                                <p><span class="info-label">예상 도착 시간:</span> 
                                   <span class="arrival-time">
                                       <%= totalMinutes %>분 
                                       <% if (remainingSeconds > 0) { %>
                                           <%= remainingSeconds %>초
                                       <% } %>
                                   </span>
                                </p>
                                <p><span class="info-label">차량번호:</span> 
                                   <%= getNodeValue(arrivalElement, "CAR_REG_NO") %>
                                </p>
                                <p><span class="info-label">정보 제공 시각:</span> 
                                   <%= getNodeValue(arrivalElement, "INFO_OFFER_TM") %>
                                </p>
                            </div>
                            <%
                        }
                    } else {
                        %>
                        <div class="bus-arrival">
                            <p>현재 운행 중인 버스가 없습니다.</p>
                            <p>* 첫차 시간 이전이거나 막차 시간 이후일 수 있습니다.</p>
                        </div>
                        <%
                    }
                    %>
                    </div>
                    <%                 
                    
                } catch (Exception e) {
                    out.println("에러 발생: " + e.getMessage());
                }
            %>
        </div>
    </div>
    
    <script>
        function updateLastUpdateTime() {
            const now = new Date();
            const timeString = now.toLocaleTimeString();
            document.getElementById('lastUpdateTime').textContent = 
                '마지막 업데이트: ' + timeString;
        }

        function loadBusStopInfo() {
            fetch(window.location.href)
                .then(response => response.text())
                .then(html => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    document.getElementById('busStopInfo').innerHTML = 
                        doc.getElementById('busStopInfo').innerHTML;
                    updateLastUpdateTime();
                });
        }

        function updateBusStopId() {
            const newBusStopId = document.getElementById('busStopIdInput').value;
            if(newBusStopId && newBusStopId.length === 7) {
                const currentUrl = new URL(window.location.href);
                currentUrl.searchParams.set('busStopId', newBusStopId);
                window.location.href = currentUrl.toString();
            } else {
                alert('정류장ID는 7자리 숫자여야 합니다.');
            }
        }

        updateLastUpdateTime();
        setInterval(loadBusStopInfo, 30000);
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