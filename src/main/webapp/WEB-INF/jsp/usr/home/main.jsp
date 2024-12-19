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
    <!-- Custom CSS -->
    <style>
        .hero-section {
            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            padding: 100px 0;
            color: white;
        }

        .feature-card {
            border-radius: 15px;
            transition: transform 0.3s ease;
            background: white;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .feature-card:hover {
            transform: translateY(-10px);
        }

        .icon-circle {
            width: 80px;
            height: 80px;
            background: #eef2ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }

        .stats-section {
            background: #f8fafc;
            padding: 80px 0;
        }

        .stat-card {
            text-align: center;
            padding: 30px;
            border-radius: 15px;
            background: white;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #4f46e5;
        }

        .cta-section {
            padding: 80px 0;
            background: #eef2ff;
        }

        .news-section {
            padding: 80px 0;
        }

        .news-card {
            border-radius: 15px;
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .news-card:hover {
            transform: translateY(-5px);
        }

        .custom-btn {
            padding: 15px 30px;
            border-radius: 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .custom-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }
    </style>
</head>
<body>
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row justify-content-center text-center">
                <div class="col-md-8">
                    <h1 class="display-4 fw-bold mb-4">스마트하고 효율적인 시스템</h1>
                    <p class="lead mb-5">사용자의 편안함을 선사하여 더 나은 미래를 만들어갑니다</p>
                    <a href="#" class="btn btn-light btn-lg custom-btn">시작하기</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-5">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-3">
                    <div class="feature-card p-4">
                        <div class="icon-circle">
                            <i class="fas fa-bus fa-2x text-primary"></i>
                        </div>
                        <h3 class="h5 text-center mb-3"></h3>
                        <p class="text-muted text-center"></p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="feature-card p-4">
                        <div class="icon-circle">
                            <i class="fas fa-train fa-2x text-primary"></i>
                        </div>
                        <h3 class="h5 text-center mb-3"></h3>
                        <p class="text-muted text-center"></p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="feature-card p-4">
                        <div class="icon-circle">
                            <i class="fas fa-car fa-2x text-primary"></i>
                        </div>
                        <h3 class="h5 text-center mb-3"></h3>
                        <p class="text-muted text-center"></p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="feature-card p-4">
                        <div class="icon-circle">
                            <i class="fas fa-plane fa-2x text-primary"></i>
                        </div>
                        <h3 class="h5 text-center mb-3"></h3>
                        <p class="text-muted text-center"></p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-number">1M+</div>
                        <p class="text-muted mb-0">일일 이용객</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-number">95%</div>
                        <p class="text-muted mb-0">고객 만족도</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-number">24/7</div>
                        <p class="text-muted mb-0">실시간 서비스</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- News Section -->
    <section class="news-section">
        <div class="container">
            <h2 class="text-center mb-5">최신 소식</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="news-card shadow">
                        <img src="/api/placeholder/400/200" class="card-img-top" alt="뉴스 이미지">
                        <div class="card-body p-4">
                            <h5 class="card-title">새로운 버스 노선 개통</h5>
                            <p class="card-text text-muted">더욱 편리해진 대중교통 서비스를 만나보세요.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="news-card shadow">
                        <img src="/api/placeholder/400/200" class="card-img-top" alt="뉴스 이미지">
                        <div class="card-body p-4">
                            <h5 class="card-title">실시간 교통정보 업데이트</h5>
                            <p class="card-text text-muted">더 정확한 실시간 정보를 제공합니다.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="news-card shadow">
                        <img src="/api/placeholder/400/200" class="card-img-top" alt="뉴스 이미지">
                        <div class="card-body p-4">
                            <h5 class="card-title">친환경 교통수단 확대</h5>
                            <p class="card-text text-muted">탄소중립을 위한 새로운 발걸음</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>