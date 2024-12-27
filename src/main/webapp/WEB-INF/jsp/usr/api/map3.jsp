<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>실시간 위치 공유</title>

<!-- Firebase SDK -->
<script type="module">
        import { initializeApp } from 'https://www.gstatic.com/firebasejs/9.23.0/firebase-app.js';
        import { getDatabase, ref, set, onValue, remove } from 'https://www.gstatic.com/firebasejs/9.23.0/firebase-database.js';

        const firebaseConfig = {
            apiKey: "AIzaSyB5nFk9H6Bv-DDIV4D--7mJ03DT0KtEf3k",
            authDomain: "indexl-e3f8b.firebaseapp.com",
            databaseURL: "https://indexl-e3f8b-default-rtdb.firebaseio.com",
            projectId: "indexl-e3f8b"
        };

        const app = initializeApp(firebaseConfig);
        const database = getDatabase(app);

        window.database = database;
        window.dbRef = ref;
        window.dbSet = set;
        window.dbOnValue = onValue;
        window.dbRemove = remove;
    </script>

<!-- 카카오맵 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d39ebf45ab30101c92bd6b1126db076c&libraries=services"></script>
<!-- QR코드 -->
<script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
<style>
body {
    margin: 0;
    padding: 20px;
    font-family: Arial, sans-serif;
    background: linear-gradient(135deg, #F0FFFF 0%, #8FE5D0 100%);
    min-height: 100vh;
}

#map {
    width: 100%;
    height: 500px;
    max-width: 1200px;
    margin: 20px auto;
    border-radius: 8px;
    border: 1px solid rgba(0, 0, 0, 0.1);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.status {
    text-align: center;
    padding: 10px;
    margin: 10px auto;
    max-width: 800px;
    border-radius: 4px;
    color: #333;
}

#qrcode {
    text-align: center;
    margin: 20px auto;
    max-width: 200px;
    padding: 15px;
}

@media (max-width: 768px) {
    .desktop-only { display: none; }
}

@media (min-width: 769px) {
    .mobile-only { display: none; }
}
</style>
</head>
<body>
    <div id="status" class="status">연결 중...</div>
    <div id="qrcode" class="desktop-only"></div>
    <div id="map"></div>

    <script>
        const initialLocation = {
            latitude: 36.36156,
            longitude: 127.34412
        };

        const urlParams = new URLSearchParams(window.location.search);
        let shareId = urlParams.get('id');
        
        if (!shareId) {
            shareId = Math.random().toString(36).substring(2, 8);
            window.history.replaceState(null, '', `?id=${shareId}`);
        }

        function isMobile() {
            return /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        }

        if (!isMobile() && document.getElementById('qrcode')) {
            new QRCode(document.getElementById('qrcode'), {
                text: window.location.href,
                width: 200,
                height: 200
            });
        }

        let currentLocationMarker = null;  // 현재 위치 마커
        let busStopMarkers = [];  // 버스정류장 마커 배열

        function resetLocation() {
            if (shareId) {
                window.dbRemove(window.dbRef(window.database, `locations/${shareId}`));
            }
        }

        function updateLocation(position) {
            const lat = position.coords.latitude;
            const lng = position.coords.longitude;
            
            window.dbSet(window.dbRef(window.database, `locations/${shareId}`), {
                latitude: lat,
                longitude: lng,
                timestamp: Date.now()
            });
        }

        function displayLocation(lat, lng) {
            const latlng = new kakao.maps.LatLng(lat, lng);

            if (currentLocationMarker) {
                currentLocationMarker.setPosition(latlng);
            } else {
                currentLocationMarker = new kakao.maps.Marker({
                    position: latlng,
                    map: map,
                    image: new kakao.maps.MarkerImage(
                        'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_blue.png',
                        new kakao.maps.Size(31, 35)
                    )
                });
            }

            map.setCenter(latlng);
            document.getElementById('status').textContent = '휴대폰으로 위치앱을 켠 상태로 스캔하세요';
        }

        function initialize() {
            resetLocation();

            const mapContainer = document.getElementById('map');
            const mapOption = {
                center: new kakao.maps.LatLng(initialLocation.latitude, initialLocation.longitude),
                level: 3
            };

            map = new kakao.maps.Map(mapContainer, mapOption);
            
            const zoomControl = new kakao.maps.ZoomControl();
            map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

            if (isMobile() && "geolocation" in navigator) {
                navigator.geolocation.watchPosition(updateLocation, error => {
                    document.getElementById('status').textContent = 
                        `위치 오류: ${error.message}`;
                }, {
                    enableHighAccuracy: true,
                    timeout: 10000,
                    maximumAge: 0
                });
            }

            window.dbOnValue(window.dbRef(window.database, `locations/${shareId}`), (snapshot) => {
                const data = snapshot.val();
                if (data) {
                    displayLocation(data.latitude, data.longitude);
                } else {
                    displayLocation(initialLocation.latitude, initialLocation.longitude);
                }
            });

            // 버스정류장 마커 표시 및 클릭 이벤트 추가
            const ps = new kakao.maps.services.Places(map);
            
            kakao.maps.event.addListener(map, 'idle', function() {
                // 이전 마커들을 제거
                busStopMarkers.forEach(marker => marker.setMap(null));
                busStopMarkers = [];

                ps.categorySearch('BU8', function(data, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        for (let i = 0; i < data.length; i++) {
                            const busStopMarker = new kakao.maps.Marker({
                                position: new kakao.maps.LatLng(data[i].y, data[i].x),
                                map: map,
                                image: new kakao.maps.MarkerImage(
                                    'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
                                    new kakao.maps.Size(31, 35)
                                )
                            });
                            
                            busStopMarkers.push(busStopMarker);

                            // 정류장 마커 클릭 이벤트
                            kakao.maps.event.addListener(busStopMarker, 'click', function() {
                                const lat = data[i].y;
                                const lng = data[i].x;
                                
                                // 클릭한 위치의 위도/경도를 표시
                                const infowindow = new kakao.maps.InfoWindow({
                                    content: `
                                        <div style="padding:5px;font-size:12px;">
                                            ${data[i].place_name}<br>
                                            위도: ${lat}<br>
                                            경도: ${lng}
                                        </div>
                                    `
                                });
                                
                                infowindow.open(map, busStopMarker);
                                
                                // 콘솔에도 출력
                                console.log('클릭한 정류장 위치:', {
                                    name: data[i].place_name,
                                    latitude: lat,
                                    longitude: lng
                                });
                            });
                        }
                    }
                });
            });
        }

        window.addEventListener('beforeunload', resetLocation);
        window.onload = initialize;
    </script>
</body>
</html>