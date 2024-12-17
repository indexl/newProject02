<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>글쓰기</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
        }
        .write-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            padding: 30px;
            margin-top: 50px;
        }
        .form-check-input:checked {
            background-color: #007bff;
            border-color: #007bff;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 write-container">
                <h2 class="mb-4 text-center">새 글 작성</h2>
                <form action="doWrite" method="post" onsubmit="return writeForm_onSubmit(this);">
                    <div class="mb-3">
                        <label class="form-label">게시판</label>
                        <div class="d-flex">
                            <div class="form-check me-4">
                                <input class="form-check-input" type="radio" name="boardId" id="noticeBoard" value="1">
                                <label class="form-check-label" for="noticeBoard">
                                    공지사항
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="boardId" id="freeBoard" value="2" checked>
                                <label class="form-check-label" for="freeBoard">
                                    자유게시판
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="titleInput" class="form-label">제목</label>
                        <input type="text" class="form-control" id="titleInput" name="title" 
                               placeholder="제목을 입력해주세요" required>
                    </div>

                    <div class="mb-3">
                        <label for="bodyTextarea" class="form-label">내용</label>
                        <textarea class="form-control" id="bodyTextarea" name="body" 
                                  rows="5" placeholder="내용을 입력해주세요" required></textarea>
                    </div>

                    <div class="d-flex justify-content-between">
                        <button type="button" class="btn btn-secondary" onclick="history.back();">
                            뒤로가기
                        </button>
                        <button type="submit" class="btn btn-primary">
                            작성 완료
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>

    <script>
        function writeForm_onSubmit(form) {
            form.title.value = form.title.value.trim();
            form.body.value = form.body.value.trim();

            if (form.title.value.length === 0) {
                alert('제목을 입력해주세요');
                form.title.focus();
                return false;
            }

            if (form.body.value.length === 0) {
                alert('내용을 입력해주세요');
                form.body.focus();
                return false;
            }

            return true;
        }
    </script>

    <!-- Bootstrap JS (optional, but recommended) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>