<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>위치 공유</title>
</head>
<body>
    <button onclick="startSharing()">위치 공유 시작</button>
    <div id="status"></div>

    <script>
        const socket = new WebSocket('ws://여기에_서버주소_입력/location');
        let watchId;

        function startSharing() {
            if (navigator.geolocation) {
                const options = {
                    enableHighAccuracy: true,
                    maximumAge: 0,
                    timeout: 5000
                };

                watchId = navigator.geolocation.watchPosition(
                    position => {
                        const locationData = {
                            lat: position.coords.latitude,
                            lng: position.coords.longitude,
                            accuracy: position.coords.accuracy
                        };
                        socket.send(JSON.stringify(locationData));
                        document.getElementById('status').textContent = 
                            `공유 중... (정확도: ${locationData.accuracy}m)`;
                    },
                    error => {
                        document.getElementById('status').textContent = 
                            '위치 정보를 가져올 수 없습니다.';
                    },
                    options
                );
            }
        }
    </script>
</body>
</html>