<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2024/12/10
  Time: 11:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预约信息列表 - 实验室预约系统</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, sans-serif;
        }

        .page-container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            font-size: 24px;
            color: #333;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .reserve-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .reserve-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .reserve-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .reserve-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .reserve-number {
            font-size: 16px;
            color: #4CAF50;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .reserve-info {
            margin: 15px 0;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            color: #666;
        }

        .info-item i {
            color: #4CAF50;
        }

        .time-info {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: #888;
            margin-top: 15px;
            padding-top: 10px;
            border-top: 1px solid #eee;
        }

        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 20px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 5px;
            color: white;
        }

        .btn-danger {
            background: linear-gradient(145deg, #ff5252, #f44336);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 30px;
            gap: 10px;
            background: rgba(255, 255, 255, 0.95);
            padding: 15px;
            border-radius: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .page-info {
            color: #666;
            font-size: 14px;
        }

        .page-btn {
            padding: 8px 15px;
            border: none;
            border-radius: 20px;
            background: white;
            color: #4CAF50;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
        }

        .page-btn:hover {
            background: #4CAF50;
            color: white;
        }

        .page-btn:disabled {
            background: #ddd;
            cursor: not-allowed;
        }

        .return-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: #4CAF50;
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            text-decoration: none;
        }

        .return-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
        }

        .empty-message {
            text-align: center;
            padding: 40px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            color: #666;
        }
    </style>
</head>
<body>
<div class="page-container">
    <div class="header">
        <h1 class="page-title">
            <i class="material-icons">event_note</i>
            预约信息列表
        </h1>
    </div>

    <c:if test="${empty reserves}">
        <div class="empty-message">
            <i class="material-icons" style="font-size: 48px; color: #ccc;">event_busy</i>
            <p>暂无预约记录</p>
        </div>
    </c:if>

    <div class="reserve-grid">
        <c:forEach items="${reserves}" var="reserve">
            <div class="reserve-card">
                <div class="reserve-header">
                    <div class="reserve-number">
                        <i class="material-icons">confirmation_number</i>
                        ${reserve.reserveNum}
                    </div>
                    <c:if test="${user.role == 1 || user.studentId == reserve.studentId}">
                        <button class="btn btn-danger" onclick="deleteReserve(${reserve.reserveId})">
                            <i class="material-icons">delete</i>
                            取消预约
                        </button>
                    </c:if>
                </div>

                <div class="reserve-info">
                    <div class="info-item">
                        <i class="material-icons">science</i>
                        <span>实验室：${reserve.labName}</span>
                    </div>
                    <div class="info-item">
                        <i class="material-icons">person</i>
                        <span>预约人：${reserve.studentName}</span>
                    </div>
                    <div class="info-item">
                        <i class="material-icons">phone</i>
                        <span>联系电话：${reserve.tel}</span>
                    </div>
                </div>

                <div class="time-info">
                    <span>
                        <i class="material-icons" style="font-size: 14px;">event</i>
                        预约时间：<fmt:formatDate value="${reserve.reserveTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </span>
                    <span>
                        <i class="material-icons" style="font-size: 14px;">access_time</i>
                        创建时间：<fmt:formatDate value="${reserve.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </span>
                </div>
            </div>
        </c:forEach>
    </div>

    <div class="pagination">
        <span class="page-info">第${page}/${totalPages}页 每页${pageSize}条 共${total}条记录</span>
        <button class="page-btn" onclick="changePage(${page-1})" ${page <= 1 ? 'disabled' : ''}>
            <i class="material-icons">chevron_left</i>
        </button>
        <button class="page-btn" onclick="changePage(${page+1})" ${page >= totalPages ? 'disabled' : ''}>
            <i class="material-icons">chevron_right</i>
        </button>
    </div>

    <a href="${pageContext.request.contextPath}/lab/list" class="return-btn">
        <i class="material-icons">keyboard_backspace</i>
    </a>
</div>

<script>
    function deleteReserve(reserveId) {
        if (confirm('确定要取消这个预约吗？')) {
            window.location.href = '${pageContext.request.contextPath}/reserve/delete?reserveId=' + reserveId;
        }
    }

    function changePage(page) {
        window.location.href = '${pageContext.request.contextPath}/reserve/list?page=' + page;
    }
</script>
</body>
</html>