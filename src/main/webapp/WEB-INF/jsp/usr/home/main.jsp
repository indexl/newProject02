<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/sidebar.jsp"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>교통 서비스</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

		<style>
	    body {
	        margin: 0;
	        padding: 0;
	        min-height: 100vh;
	        background: linear-gradient(135deg, #F0FFFF 0%, #8FE5D0 100%);
	    }
	
	    .content-section {
	        padding: 0;
	        min-height: 100vh;
	    }
	
	    .hero-section {
	        padding: 100px 0;
	        color: #2C3E50;
	        margin: 0;
	        display: flex;
	        align-items: center;
	        justify-content: center;
	        min-height: 60vh;
	    }
	
	    .feature-card {
	        border-radius: 15px;
	        transition: transform 0.3s ease;
	        background: rgba(255, 255, 255, 0.9);
	        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	        height: 250px;
	        display: flex;
	        flex-direction: column;
	        justify-content: center;
	        border: 1px solid rgba(143, 229, 208, 0.3);
	    }
	
	    .feature-card:hover {
	        transform: translateY(-10px);
	        box-shadow: 0 6px 12px rgba(143, 229, 208, 0.4);
	    }
	
	    .icon-circle {
	        width: 80px;
	        height: 80px;
	        background: #8FE5D0;
	        border-radius: 50%;
	        display: flex;
	        align-items: center;
	        justify-content: center;
	        margin: 0 auto 20px;
	    }
	
	    .icon-circle i {
	        color: white !important;
	    }
	
	    .features-container {
	        display: flex;
	        justify-content: center;
	        margin: -100px auto; /* 폼을 3배 더 위로 올리기 위한 음수 마진 */
	        max-width: 900px;
	        padding-top: 0px; /* 상단 패딩 제거 */
	    }
	
	    .custom-btn {
	        padding: 15px 30px;
	        border-radius: 30px;
	        font-weight: 600;
	        transition: all 0.3s ease;
	        background-color: #8FE5D0 !important;
	        border: none;
	        color: #2C3E50 !important;
	    }
	
	    .custom-btn:hover {
	        transform: translateY(-2px);
	        box-shadow: 0 4px 12px rgba(143, 229, 208, 0.5);
	        background-color: #7DD1BC !important;
	    }
	
	    h3.h5 {
	        color: #2C3E50;
	    }
	
	    .text-muted {
	        color: #5D6D7E !important;
	    }
	
	    .lead {
	        color: #34495E;
	    }
	</style>
	

  

</head>
<body>
    <!-- 메인 콘텐츠 영역 -->
    <div class="content-section">
        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <div class="row justify-content-center text-center">
                    <div class="col-md-8">
                        <h1 class="display-4 fw-bold mb-4">스마트한 시스템을 제공합니다</h1>
                        <p class="lead mb-5">효율적인 솔루션으로 더 나은 미래를 만들어 갑니다</p>
                        <a href="/usr/api/map3" class="btn btn-lg custom-btn">시작하기</a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Features Section -->
        <section class="py-5">
            <div class="container">
                <div class="features-container">
                    <div class="row g-4 justify-content-center">
                        <div class="col-md-4">
                            <div class="feature-card p-4">
                                <div class="icon-circle">
                                    <i class="fas fa-bus fa-2x"></i>
                                </div>
                                <h3 class="h5 text-center mb-3">스마트 위치</h3>
                                <p class="text-muted text-center">실시간 위치 제공</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="feature-card p-4">
                                <div class="icon-circle">
                                    <i class="fas fa-bus fa-2x"></i>
                                </div>
                                <h3 class="h5 text-center mb-3">스마트 정류장 정보</h3>
                                <p class="text-muted text-center">한눈에 보이는 정류장과 노선정보 제공</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="feature-card p-4">
                                <div class="icon-circle">
                                    <i class="fas fa-bus fa-2x"></i>
                                </div>
                                <h3 class="h5 text-center mb-3">스마트 정류장 뷰</h3>
                                <p class="text-muted text-center">정류장 사진 및 전송기능</p>                           
                            </div>               
                        </div>             
                    </div>           
                </div>          
            </div>
        </section>
    </div>
    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>