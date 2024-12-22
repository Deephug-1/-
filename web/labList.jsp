<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2024/12/10
  Time: 10:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>实验室预约系统 - 实验室列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* 复用 index.jsp 的基础样式 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7fafc;
            min-height: 100vh;
        }

        /* 导航栏样式 */
        .navbar {
            background: #2d3748;
            color: white;
            padding: 1rem 2rem;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 100;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: bold;
            color: white;
            text-decoration: none;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .logout-btn {
            padding: 0.5rem 1rem;
            background: #e53e3e;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9rem;
        }

        /* 侧边栏样式 */
        .sidebar {
            position: fixed;
            left: 0;
            top: 60px;
            bottom: 0;
            width: 250px;
            background: white;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
            padding: 2rem 0;
        }

        .menu-item {
            padding: 1rem 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            color: #4a5568;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .menu-item:hover {
            background: #edf2f7;
            color: #2b6cb0;
        }

        .menu-item.active {
            background: #ebf8ff;
            color: #2b6cb0;
            border-right: 3px solid #2b6cb0;
        }

        /* 主要内容区域 */
        .main-content {
            margin-left: 250px;
            margin-top: 60px;
            padding: 2rem;
        }

        /* 实验室列表特定样式 */
        .lab-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            padding: 1rem;
        }

        .lab-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.2s ease;
        }

        .lab-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .lab-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .lab-info {
            padding: 1.5rem;
        }

        .lab-name {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.5rem;
        }

        .lab-description {
            color: #718096;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .lab-stats {
            display: flex;
            justify-content: space-between;
            padding: 1rem;
            background: #f8fafc;
            border-top: 1px solid #e2e8f0;
        }

        .stat {
            text-align: center;
        }

        .stat-label {
            font-size: 0.875rem;
            color: #718096;
        }

        .stat-value {
            font-size: 1.25rem;
            font-weight: 600;
            color: #2b6cb0;
        }

        .reserve-btn {
            display: block;
            width: 100%;
            padding: 0.75rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-align: center;
            text-decoration: none;
            border: none;
            border-radius: 0 0 10px 10px;
            font-weight: 500;
            transition: opacity 0.2s ease;
        }

        .reserve-btn:hover {
            opacity: 0.9;
        }

        .reserve-btn.disabled {
            background: #cbd5e0;
            cursor: not-allowed;
        }

        .search-bar {
            margin-bottom: 2rem;
            padding: 1rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .search-input {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            font-size: 1rem;
            outline: none;
            transition: border-color 0.2s ease;
        }

        .search-input:focus {
            border-color: #667eea;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">
            实验室预约系统
        </a>
        <div class="user-info">
            <span>欢迎，${sessionScope.user.studentName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> 退出
            </a>
        </div>
    </nav>

    <!-- 侧边栏 -->
    <div class="sidebar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="menu-item">
            <i class="fas fa-home"></i>
            <span>主页</span>
        </a>
        <a href="${pageContext.request.contextPath}/labList.jsp" class="menu-item active">
            <i class="fas fa-flask"></i>
            <span>实验室列表</span>
        </a>
        <a href="${pageContext.request.contextPath}/reserveList.jsp" class="menu-item">
            <i class="fas fa-calendar-alt"></i>
            <span>我的预约</span>
        </a>
        <c:if test="${sessionScope.user.role == 1}">
            <a href="${pageContext.request.contextPath}/admin/labManage.jsp" class="menu-item">
                <i class="fas fa-cog"></i>
                <span>实验室管理</span>
            </a>
        </c:if>
    </div>

    <!-- 主要内容区域 -->
    <main class="main-content">
        <div class="search-bar">
            <input type="text" 
                   class="search-input" 
                   placeholder="搜索实验室..."
                   onkeyup="searchLabs(this.value)">
        </div>

        <div class="lab-grid">
            <c:forEach var="lab" items="${labs}">
                <div class="lab-card">
                    <img src="${pageContext.request.contextPath}/images/lab-default.jpg" 
                         alt="${lab.labName}" 
                         class="lab-image">
                    <div class="lab-info">
                        <h3 class="lab-name">${lab.labName}</h3>
                        <p class="lab-description">${lab.labDescription}</p>
                    </div>
                    <div class="lab-stats">
                        <div class="stat">
                            <div class="stat-label">总容量</div>
                            <div class="stat-value">${lab.enableReserveNum}</div>
                        </div>
                        <div class="stat">
                            <div class="stat-label">已预约</div>
                            <div class="stat-value">${lab.reservedNum}</div>
                        </div>
                        <div class="stat">
                            <div class="stat-label">剩余</div>
                            <div class="stat-value">${lab.enableReserveNum - lab.reservedNum}</div>
                        </div>
                    </div>
                    <c:choose>
                        <c:when test="${lab.enableReserveNum > lab.reservedNum}">
                            <a href="${pageContext.request.contextPath}/reserve/add?labId=${lab.labId}" 
                               class="reserve-btn">
                                立即预约
                            </a>
                        </c:when>
                        <c:otherwise>
                            <button class="reserve-btn disabled" disabled>
                                已满
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:forEach>
        </div>
    </main>

    <script>
        function searchLabs(keyword) {
            // 实现搜索功能
            const cards = document.querySelectorAll('.lab-card');
            cards.forEach(card => {
                const name = card.querySelector('.lab-name').textContent.toLowerCase();
                const description = card.querySelector('.lab-description').textContent.toLowerCase();
                if (name.includes(keyword.toLowerCase()) || 
                    description.includes(keyword.toLowerCase())) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>