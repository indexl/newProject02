<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
        // Firebase App 가져오기
        import { initializeApp } from 'https://www.gstatic.com/firebasejs/9.23.0/firebase-app.js';
        import { getDatabase, ref, set, onValue, remove } from 'https://www.gstatic.com/firebasejs/9.23.0/firebase-database.js';

        // Firebase 구성
        const firebaseConfig = {
            apiKey: "AIzaSyB5nFk9H6Bv-DDIV4D--7mJ03DT0KtEf3k",
            authDomain: "indexl-e3f8b.firebaseapp.com",
            databaseURL: "https://indexl-e3f8b-default-rtdb.firebaseio.com",
            projectId: "indexl-e3f8b"
        };

        // Firebase 초기화
        const app = initializeApp(firebaseConfig);
        const database = getDatabase(app);

        // 전역 변수로 내보내기
        window.database = database;
        window.dbRef = ref;
        window.dbSet = set;
        window.dbOnValue = onValue;
        window.dbRemove = remove;
    </script>

<!-- 카카오맵 -->
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d39ebf45ab30101c92bd6b1126db076c"></script>
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

.container {
    display: flex;
    gap: 20px;
    max-width: 1600px;
    margin: 20px auto 20px 250px;
    justify-content: center;
}

#map {
    width: 48%;
    height: 500px;
    border-radius: 8px;
    border: 1px solid rgba(0, 0, 0, 0.1);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

#roadview {
    width: 48%;
    height: 500px;
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

@media ( max-width : 768px) {
	.desktop-only {
		display: none;
	}
    .container {
        flex-direction: column;
    }
    #map, #roadview {
        width: 100%;
    }
}

@media ( min-width : 769px) {
	.mobile-only {
		display: none;
	}
}
</style>
</head>
<body>
	<div id="status" class="status">연결 중...</div>
	
	<div id="coordinates" class="status" style="font-family: monospace;">
		위도: <span id="latitude">--</span>° / 경도: <span id="longitude">--</span>°
	</div>

	<!-- PC에서만 보이는 QR코드 -->
	<div id="qrcode" class="desktop-only"></div>

    <div class="container">
        <div id="map"></div>
        <div id="roadview"></div>
    </div>

	<script>
        // 초기 위치 설정 (대전시청)
        const initialLocation = {
            latitude: 36.3515740181875,
            longitude: 127.386528844404 
        };

        // 고유한 공유 ID 생성
        const urlParams = new URLSearchParams(window.location.search);
        let shareId = urlParams.get('id');
        
        // ID가 없으면 새로 생성
        if (!shareId) {
            shareId = Math.random().toString(36).substring(2, 8);
            window.history.replaceState(null, '', `?id=${shareId}`);
        }

        // 모바일 여부 확인
        function isMobile() {
            return /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        }

        // QR 코드 생성 (PC에서만)
        if (!isMobile() && document.getElementById('qrcode')) {
            new QRCode(document.getElementById('qrcode'), {
                text: window.location.href,
                width: 200,
                height: 200
            });
        }

        let map;
        let marker = null;
        let roadview;
        let roadviewClient;

        // 페이지 로드/새로고침 시 Firebase 데이터 초기화
        function resetLocation() {
            if (shareId) {
                window.dbRemove(window.dbRef(window.database, `locations/${shareId}`));
            }
        }

        // 위치 업데이트 함수
        function updateLocation(position) {
            const lat = position.coords.latitude;
            const lng = position.coords.longitude;
            
            // Firebase에 위치 저장
            window.dbSet(window.dbRef(window.database, `locations/${shareId}`), {
                latitude: lat,
                longitude: lng,
                timestamp: Date.now()
            });
        }

        // 로드뷰 업데이트 함수
        function updateRoadview(lat, lng) {
            const position = new kakao.maps.LatLng(lat, lng);
            
            roadviewClient.getNearestPanoId(position, 50, function(panoId) {
                if (panoId) {
                    roadview.setPanoId(panoId, position);
                } else {
                    // 로드뷰가 없는 경우 메시지 표시
                    document.getElementById('roadview').innerHTML = 
                        '<div style="padding: 20px; text-align: center;">' +
                        '<p>이 위치에서는 로드뷰를 이용할 수 없습니다.</p>' +
                        '<p>주변 도로 위치에서 다시 시도해주세요.</p>' +
                        '</div>';
                }
            });
        }

        // 위치 표시 함수
        function displayLocation(lat, lng) {
            const latlng = new kakao.maps.LatLng(lat, lng);

            if (marker) {
                marker.setPosition(latlng);
            } else {
                marker = new kakao.maps.Marker({
                    position: latlng,
                    map: map
                });
            }

            map.setCenter(latlng);
            document.getElementById('status').textContent = '휴대폰으로 위치앱을 켠 상태로 스캔하세요';
            
            // 로드뷰 업데이트
            updateRoadview(lat, lng);
        }

        // 초기화 함수
        function initialize() {
            // 페이지 로드/새로고침 시 이전 위치 데이터 삭제
            resetLocation();

            // 지도 초기화 (초기 위치로)
            const mapContainer = document.getElementById('map');
            const mapOption = {
                center: new kakao.maps.LatLng(initialLocation.latitude, initialLocation.longitude),
                level: 3
            };

            map = new kakao.maps.Map(mapContainer, mapOption);
            
            // 로드뷰 초기화
            roadview = new kakao.maps.Roadview(document.getElementById('roadview'));
            roadviewClient = new kakao.maps.RoadviewClient();
            
            // 지도 컨트롤 추가
            const zoomControl = new kakao.maps.ZoomControl();
            map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

            // 위치 정보 수신 및 오류 처리 (모바일에서만)
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

            // Firebase에서 위치 변경 감지
            window.dbOnValue(window.dbRef(window.database, `locations/${shareId}`), (snapshot) => {
                const data = snapshot.val();
                if (data) {
                    displayLocation(data.latitude, data.longitude);
                    updateCoordinates(data.latitude, data.longitude);
                } else {
                    displayLocation(initialLocation.latitude, initialLocation.longitude);
                    updateCoordinates(initialLocation.latitude, initialLocation.longitude);
                }
            });

            // 카카오맵 카테고리 (버스정류장) 표시
            const ps = new kakao.maps.services.Places(map);
            
            // 지도 이동 완료 이벤트 등록
            kakao.maps.event.addListener(map, 'idle', function() {
                ps.categorySearch('BU8', function(data, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        for (let i = 0; i < data.length; i++) {
                            const marker = new kakao.maps.Marker({
                                position: new kakao.maps.LatLng(data[i].y, data[i].x),
                                map: map
                            });

                            // 인포윈도우 생성
                            const infowindow = new kakao.maps.InfoWindow({
                                content: '<div style="padding:5px;font-size:12px;">' + data[i].place_name + '</div>'
                            });

                            // 마커에 마우스오버 이벤트 등록
                            kakao.maps.event.addListener(marker, 'mouseover', function() {
                                infowindow.open(map, marker);
                            });

                            // 마커에 마우스아웃 이벤트 등록
                            kakao.maps.event.addListener(marker, 'mouseout', function() {
                                infowindow.close();
                            });
                        }
                    }
                });
            });
        }

        // 위도/경도 업데이트 함수
        function updateCoordinates(lat, lng) {
            document.getElementById('latitude').textContent = lat.toFixed(6);
            document.getElementById('longitude').textContent = lng.toFixed(6);
        }

        // beforeunload 이벤트에 리스너 추가 (페이지 나갈 때 초기화)
        window.addEventListener('beforeunload', resetLocation);

        // 페이지 로드 완료 후 초기화
        window.onload = initialize;
    </script>
</body>
</html>