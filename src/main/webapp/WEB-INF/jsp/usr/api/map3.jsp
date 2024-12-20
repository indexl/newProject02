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
    
    <!-- 네이버 지도 -->
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ukkuio3cf4"></script>
    <!-- QR코드 -->
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
    <style>
        body { 
            margin: 0; 
            padding: 20px; 
            font-family: Arial, sans-serif; 
        }
        #map { 
            width: 100%;
            height: 400px;
            max-width: 800px;
            margin: 20px auto;
            border-radius: 8px;
            border: 1px solid #ddd;
        }
        .status {
            text-align: center;
            padding: 10px;
            margin: 10px auto;
            max-width: 800px;
            border-radius: 4px;
            background-color: #f8f9fa;
        }
        #qrcode {
            text-align: center;
            margin: 20px auto;
            max-width: 200px;
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
    
    <!-- PC에서만 보이는 QR코드 -->
    <div id="qrcode" class="desktop-only">
        <p>휴대폰으로 스캔하세요</p>
    </div>

    <div id="map"></div>

    <script>
        // 초기 위치 설정 (서울시청)
        const initialLocation = {
            latitude: 37.5666805,
            longitude: 126.9784147
        };

        // 고유한 공유 ID 생성
        // 고유한 공유 ID 생성 및 표시 부분 수정
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

        // 위치 표시 함수
        function displayLocation(lat, lng) {
            const location = new naver.maps.LatLng(lat, lng);

            if (marker) {
                marker.setPosition(location);
            } else {
                marker = new naver.maps.Marker({
                    position: location,
                    map: map
                });
            }

            map.setCenter(location);
            document.getElementById('status').textContent = '위치앱을 켠 상태로';
        }

        // 초기화 함수
        function initialize() {
            // 페이지 로드/새로고침 시 이전 위치 데이터 삭제
            resetLocation();

            // 지도 초기화 (초기 위치로)
            map = new naver.maps.Map('map', {
                center: new naver.maps.LatLng(initialLocation.latitude, initialLocation.longitude),
                zoom: 17,
                zoomControl: true
            });

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
                } else {
                    // 데이터가 없으면 초기 위치 표시
                    displayLocation(initialLocation.latitude, initialLocation.longitude);
                }
            });
        }

        // beforeunload 이벤트에 리스너 추가 (페이지 나갈 때 초기화)
        window.addEventListener('beforeunload', resetLocation);

        // 페이지 로드 완료 후 초기화
        window.onload = initialize;
    </script>
</body>
</html>