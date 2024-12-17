<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>실시간 위치 공유</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d39ebf45ab30101c92bd6b1126db076c"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <style>
        #map { width: 100%; height: 500px; }
        #qrcode { text-align: center; margin: 20px; }
    </style>
</head>
<body>
    <div id="map"></div>
    <div id="qrcode"></div>
    <script>
        // WebSocket 연결
        const socket = new WebSocket('ws://여기에_서버주소_입력/location');
        let map, marker;

        // 모바일용 위치 공유 페이지 URL
        const mobilePageUrl = "http://여기에_서버주소_입력/mobile-location.jsp";

        // 지도 초기화
        const initMap = () => {
            const options = {
                center: new kakao.maps.LatLng(37.5665, 126.9780),
                level: 3
            };
            map = new kakao.maps.Map(document.getElementById('map'), options);
        };

        // WebSocket 이벤트 처리
        socket.onmessage = (event) => {
            const location = JSON.parse(event.data);
            updateMarker(location.lat, location.lng);
        };

        // 마커 업데이트
        const updateMarker = (lat, lng) => {
            const position = new kakao.maps.LatLng(lat, lng);
            
            if (!marker) {
                marker = new kakao.maps.Marker({
                    position: position,
                    map: map
                });
            } else {
                marker.setPosition(position);
            }
            
            map.setCenter(position);
        };

        window.onload = initMap;
    </script>
</body>
</html>